function Update {

}

# Implemented types
$variableTypes = @("String", "Integer", "Color", "Toggle")
$defaultVariableType = @("String")
$categoryTypes = @("Default", "About")
$listTypes = @("Default", "Super", "About")

# Variables from Rainmeter
$settingsFilePath = "$($RmAPI.VariableStr('s_SettingsFile'))"

# Testfile
$testfile = "$($RmAPI.VariableStr('@'))test.inc"

# Generator directories
$includeDir = "$($RmAPI.VariableStr('@'))includes\"
$templatesDir = "$($RmAPI.VariableStr('@'))templates\"
$variableTemplatesDir = "$($templatesDir)variable\"
$categoryTemplatesDir = "$($templatesDir)category\"
$listTemplatesDir = "$($templatesDir)list\"

# Generated directories
$generatedSkinDir = "$($RmAPI.VariableStr('ROOTCONFIGPATH'))settings\"
$generatedCategoriesDir = "$($generatedSkinDir)categories\"
$generatedIncludeDir = "$($generatedSkinDir)includes\"

# Generated files
$generatedSkinFile = "$($generatedSkinDir)settings.ini"

function Construct {
    # Reset directories, copy files etc.
    Prepare-Directories

    # Read settings file
    $settingsFileContent = Get-Content $settingsFilePath -Raw

    # Filter settings file into staggered array
    $settings = Settings-Array -String $settingsFileContent

    # Variable to hold generated .ini
    # Get rainmeter section from template
    $ini = Get-Content -Path "$($templatesDir)Rainmeter.inc" -Raw

    # Construct categories
    $i = 0
    foreach ($category in $settings) {
        Category-Ini -category $category -i $i
        $i++
    }

    Category-List -Settings $settings

    $ini > $generatedSkinFile
}

function Settings-Array {
    param (
        [Parameter(Mandatory=$true)]
        [Alias("String")]
        $settingsFileContent
    )

    # Regex patterns
    $categoryPattern = '(?s-m)(;@.*?)(?=;@|$)'
    $variablePattern = '(?s-m)(;;.*?)\n(?![;$]).*?[\n|$]'
    $variablePatterns = @{
        "Type" = '(?<=;;Type=)(.*?)(?=\n)'
        "Name" = '(?<=;;Name=)(.*?)(?=\n)'
        "Description" = '(?<=;;Description=)(.*?)(?=\n)'
        "DefaultValue" = '(?<=;;DefaultValue=)(.*?)(?=\n)'
        "RealName" = '(?m-s)^(?!;)(.*?)(?==)'
        "CurrentValue" = '(?m-s)^(?!;).*=(.*?)(?=\n|$)'
    }
    $categoryPatterns = @{
        "Title" = '(?s-m)(?<=;@)(.*?)(?=\n)'
        "Type" = '(?<=;!Type=)(.*?)(?=\n)'
        "Icon" = '(?<=;!Icon=)(.*?)(?=\n)'
        "UnfilteredVariables" = '(?s-m)(;;.*)'
        "Description" = '(?<=;!Description=)(.*?)(?=\n)'
    }

    # Fallback pattern for getting variables from unformatted files
    $unformattedVariablePattern = '(?sm)(?<=[^;])^([^;]+?)$'

    # Declare $settings as an empty array to make sure that $settings is an array
    $settings = @()

    # Handle unformatted variable files
    if($settingsFileContent -notmatch $variablePattern) {
        $RmAPI.LogWarning("Filtering unformatted variables file")
        $c = @{"Title" = "settings"; "Variables" = @()}
        Select-String -Pattern $unformattedVariablePattern -input $settingsFileContent -AllMatches | Foreach {
            foreach($match in $_.Matches) {
                $var = Filter-Hashtable -Properties $variablePatterns -String $match
                # check if processing empty $match
                if($var.RealName) {
                    $RmAPI.Log("Matched unformatted variable: $($var.RealName)")
                    $var["Name"] = $var["RealName"]
                    $var["Description"] = " "
                    $c.Variables += $var
                }
            }
        }
        $settings += $c
        return $settings
    }

    # Get all $categoryPattern matches from $settingsFileContent to %_ with Foreach
    Select-String -Pattern $categoryPattern -input $settingsFileContent -AllMatches | Foreach {

        # Iterate over each matched $category in $_.Matches
        foreach ($category in $_.Matches) {

            # Filter category hashtables
            $c = Filter-Hashtable -String $category -Properties $categoryPatterns

            # Debug log
            $RmAPI.Log("Building category: $($c.Title).")

            # Create empty Variables array
            $c.Add("Variables", @())

            # Get all $variablePattern matches from $c.UnfilteredVariables to %_ with Foreach
            Select-String -Pattern $variablePattern -input $c.UnfilteredVariables -AllMatches | Foreach {
                # Debug log
                $RmAPI.Log("Filtering variables from: $($_.Matches)")
                # Iterate over each matched $variable in $_.Matches
                foreach ($variable in $_.matches) {
                    # Filter $variable hashtables
                    $var = Filter-Hashtable -String $variable -Properties $variablePatterns

                    # Debug log
                    $RmAPI.Log("$($var.Name): $($var.keys)")

                    # Add the filtered variable hashtable to the $c.Variables array
                    $c.Variables += , $var
                }
            }

            # Add the filtered category hashtable to the $settings array 
            $settings += , $c

        }
    }

    return $settings

}

function Category-Ini {
    param (
        [Parameter(Mandatory=$true)]
        $Category,
        [Parameter(Mandatory=$true)]
        $i
    )

    # path to current category.inc
    $file = "$($generatedCategoriesDir)$($i).inc"

    # Properties to replace in templates
    $Properties = @{
        "Index" = $i
        "Title" = $Category.Title
        "Icon" = "$($category.Icon)"
        "Container" = "RightPanel"
        "Description" = $Category.Description
    }

    # First Item template
    $ini = Get-Content -Path "$($templatesDir)FirstItem.inc" -Raw
    $ini = Filter-Template -Template $ini -Properties @{"Container" = "RightPanel"; "Type" = "CategoryItem"}

    # If category type is not implemented, make it Default
    if($categoryTypes -NotContains $category.Type) {
        $type = "Default"
    } else {
        $type = $category.Type
    }

    # Build category from template
    $template = Get-Content -Path "$($categoryTemplatesDir)$($type).inc" -Raw
    $ini += Filter-Template -Template $template -Properties $Properties

    # get variables hashtable array
    $variables = $Category.Variables

    $j = 0
    foreach ($var in $variables) {
        $ini += Variable-Ini -Variable $var -Index $j
        $j++
    }

    $last = Get-Content -Path "$($templatesDir)LastItem.inc" -Raw
    $ini += Filter-Template -Template $last -Properties @{"Container" = "RightPanel"; "Type" = "CategoryItem"}

    $ini > $file

}

function Variable-Ini {
    param (
        [Parameter(Mandatory=$true)]
        $Variable,
        [Parameter(Mandatory=$true)]
        $Index
    )

    # Properties used internally for skin generation, not user submitted
    $internalVariableProperties = @{
        "Index" = $Index
        "Container" = "RightPanel"
    }

    # Default to string variable
    if ($variableTypes -NotContains $Variable.Type) {
        $Variable["Type"] = $defaultVariableType
    }

    # Get template for type
    $ini = Get-Content -Path "$($variableTemplatesDir)$($Variable.Type).inc" -Raw
    # Filter template
    $ini = Filter-Template -Template $ini -Properties $internalVariableProperties
    $ini = Filter-Template -Template $ini -Properties $Variable

    return $ini

}

function Category-List {
    param(
        [Parameter(Mandatory=$true)]
        $Settings
    )

    $RmAPI.Log("Building category list.")

    $ini = Get-Content -Path "$($templatesDir)FirstItem.inc" -Raw
    $ini = Filter-Template -Template $ini -Properties @{"Container" = "LeftPanel"; "Type" = "ListItem"}

    $i = 0
    foreach ($category in $Settings) {
        $Properties = @{
            "Index" = $i
            "Icon" = "$($category.Icon)"
            "Category" = "$($category.Title)"
            "Container" = "LeftPanel"
        }

        # If category type is not implemented, make it Default
        if($listTypes -NotContains $category.Type) {
            $type = "Default"
        } else {
            $type = $category.Type
        }

        $template = Get-Content -Path "$($listTemplatesDir)$($type).inc" -Raw
        $ini += Filter-Template -Template $template -Properties $Properties
        $i++
    }

    $last = Get-Content -Path "$($templatesDir)LastItem.inc" -Raw
    $ini += Filter-Template -Template $last -Properties @{"Container" = "LeftPanel"; "Type" = "ListItem"}

    $ini > "$($generatedCategoriesDir)CategoryList.inc"

}

function Filter-Hashtable {
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $String,
        [Parameter(Mandatory=$true)]
        [System.Collections.Hashtable]
        $Properties
    )

    $hash = @{}
    $Properties.GetEnumerator() | ForEach-Object {
        if("$($String)" -match "$($_.Value)") {
            # Save the matched string
            $s = $Matches[1]
            if("$($_.Key)" -notmatch "UnfilteredVariables") {
                $s = Remove-Newline -String $s
            }
            $hash.Add("$($_.Key)",$s)
        }
    }

    return $hash

}

function Filter-Template {
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Template,
        [Parameter(Mandatory=$true)]
        [System.Collections.Hashtable]
        $Properties
    )

    # Iterate over the template for each property of the variable
    $Properties.GetEnumerator() | ForEach-Object {
        $Template = $Template.replace("{$($_.Key)}","$($_.Value)")
    }

    return $Template

}

function Remove-Newline {
    param (
        [Parameter()]
        [string]
        $String
    )

    $String = $String -replace "`t|`n|`r",""

    return $String

}

function Prepare-Directories {
    # Create directories
    New-Item -Path $generatedSkinDir -ItemType "directory" -Name "categories"
    New-Item -Path $generatedSkinDir -ItemType "directory" -Name "includes"
    # Remove files in generated directories
    Get-ChildItem -Path "$generatedCategoriesDir*" -Include *.inc | Remove-Item
    Get-ChildItem -Path "$generatedIncludeDir*" -Include *.inc | Remove-Item
    # Copy Includes to generated skin
    Copy-Item -Path "$includeDir*" -Include "*.inc" -Destination $generatedIncludeDir -Recurse
}