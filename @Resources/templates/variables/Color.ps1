param (
    [Parameter()]
    [System.Collections.Hashtable]
    $Variable,
    [Parameter()]
    [String]
    $SettingsFile
)

$ini = &"$variableTitleScript" -Variable $Variable

$ini += @"
[VarContainer$($Variable.Index)]
MeterStyle=VarContainer | RightPanel
Meter=Image
H=([ColorVariableValue$($Variable.Index):H] > [ColorStringValue$($Variable.Index):H]) ? [ColorVariableValue$($Variable.Index):H] : [ColorStringValue$($Variable.Index):H]

[ColorVariableValue$($Variable.Index)]
Meter=Shape
Shape=Ellipse [#s_ColorSize],[#s_ColorSize],[#s_ColorSize],[#s_ColorSize] | Fill Color [#$($Variable.Key)] | StrokeWidth [#s_ColorStrokeWidth] | Extend Outline
Outline=Stroke Color [#s_ColorStrokeColor]
MeterStyle=VarColorValue
LeftMouseUpAction=[!CommandMeasure "RainRGB$($Variable.Index)" "Run"]
Container=VarContainer$($Variable.Index)

[ColorStringValue$($Variable.Index)]
Meter=String
Text=[#$($Variable.Key)]
MeterStyle=VarStringValue | VarColorString
LeftMouseUpAction=[!CommandMeasure "RainRGB$($Variable.Index)" "Run"]
Container=VarContainer$($Variable.Index)

[RainRGB$($Variable.Index)]
Measure=Plugin
Plugin=RunCommand
Program=""#CURRENTPATH#addons\RainRGB4RunCommand.exe""
Parameter=""VarName=$($Variable.Key)" "FileName=$($SettingsFile)" "RefreshConfig=-1""
OutputType=ANSI
FinishAction=[!Refresh][#s_OnChangeAction]
"@

return $ini