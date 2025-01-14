param (
    [Parameter()]
    [System.Collections.Hashtable]
    $Options,
    [Parameter()]
    [System.Collections.Hashtable]
    $Overrides
)

if ($Overrides.SkinDirectory) { $dir = $Overrides.SkinDirectory.Trim() } else { $dir = "Settings" }

$RmAPI.Log($Overrides.SkinDirectory)

return @"
[Metadata]
Name=settings by: Settings
Author=Sceleri
Information=This settings skin was generated by Settings! https://github.com/sceleri/settings
Version=1.4
License=CC BY-NC-SA 4.0

[Variables]
; Settings saves scroll values to the current file
s_CurrentFile=$($Options.SettingsFile)
s_ScrollLeft=0
s_ScrollRight=0
s_CurrentCategory=0

[Rainmeter]
Update=-1
;This updates measures like the scroll measure once
OnRefreshAction=[!Update][!Redraw]
AccurateText=1
@IncludesOnChangeAction=#ROOTCONFIGPATH#$($dir)\Includes\s_OnChangeAction.inc
@IncludeInternalVariables=#ROOTCONFIGPATH#$($dir)\Includes\Variables.inc
@IncludeTheme=$($Options.ThemeFile)
@IncludeSkinVariables=$($Options.SettingsFile)
SkinHeight=[#s_PanelH]
SkinWidth=([#s_LeftPanelW] + [#s_RightPanelW])

[FrostedGlass]
Measure=Plugin
Plugin=FrostedGlass
Type=[#s_FrostedGlassMode]
Border=[#s_FrostedGlassBorders]

[Ternary]
Measure=Script
ScriptFile=Addons\Ternary.lua

[ColorPickerUI]
Measure=Script
ScriptFile=Addons\ColorPickerUI\ColorPickerUI.lua
Animations=0
OnFinishAction=[#s_SaveScroll][#s_OnChangeAction][!Refresh]

[IncludeMeterStyles]
@IncludeMeterStyles=#ROOTCONFIGPATH#$($dir)\Includes\MeterStyles.inc

[IncludeBackground]
@IncludeBackground=#ROOTCONFIGPATH#$($dir)\Includes\Background.inc

[IncludeCategoryList]
@IncludeCategoryList=#ROOTCONFIGPATH#$($dir)\Categories\CategoryList.inc

[IncludeCurrentCategory]
@IncludeCategory=#ROOTCONFIGPATH#$($dir)\Categories\[#s_CurrentCategory].inc

[IncludeTitleBar]
@IncludeBackground=#ROOTCONFIGPATH#$($dir)\Includes\TitleBar.inc


"@

