param (
    [Parameter()]
    [System.Collections.Hashtable]
    $Variable,
    [Parameter()]
    [String]
    $SettingsFile
)

return @"
$(Title)

[VarContainer$($Variable.Index)]
MeterStyle=VarContainer | RightPanel
Meter=Image
H=([#s_ToggleSize] + [#s_VariableYPadding])

[ToggleOff$($Variable.Index)]
Meter=Shape
Shape=Line 0,0,([#s_ToggleLength]),0 | Extend Line
Shape2=Ellipse ([#s_TogglePadding]/2),0,(([#s_ToggleSize] - ([#s_TogglePadding] * 2))/2),(([#s_ToggleSize] - ([#s_TogglePadding] * 2))/2) | Extend Circle
Circle=StrokeWidth 0 | Fill Color [#s_RightPanelBackgroundColor]
Line=StrokeWidth [#s_ToggleSize] | Stroke Color [#s_FontColor] | StrokeStartCap Round | StrokeEndCap Round
Hidden=([#$($Variable.Key)])
MeterStyle=VarToggle
Container=VarContainer$($Variable.Index)
LeftMouseUpAction=[!WriteKeyValue Variables "$($Variable.Key)" 1 "$($SettingsFile)"][!SetVariable "$($Variable.Key)" 1][!Update][!Redraw][#s_OnChangeAction]

[ToggleOn$($Variable.Index)]
Meter=Shape
Shape=Line 0,0,([#s_ToggleLength]),0 | Extend Line
Shape2=Ellipse (([#s_ToggleLength]) - ([#s_TogglePadding]/2)),0,(([#s_ToggleSize] - ([#s_TogglePadding] * 2))/2),(([#s_ToggleSize] - ([#s_TogglePadding] * 2))/2) | Extend Circle
Circle=StrokeWidth 0 | Fill Color [#s_RightPanelBackgroundColor]
Line=StrokeWidth [#s_ToggleSize] | Stroke Color [#s_ToggleActiveColor] | StrokeStartCap Round | StrokeEndCap Round
Hidden=([#$($Variable.Key)] - 1)
MeterStyle=VarToggle
Container=VarContainer$($Variable.Index)
LeftMouseUpAction=[!WriteKeyValue Variables "$($Variable.Key)" 0 "$($SettingsFile)"][!SetVariable "$($Variable.Key)" 0][!Update][!Redraw][#s_OnChangeAction]
"@