[description]
Meter=String
Text=settings skin generated by Settings
MeterStyle=VarDescription | {Container}
StringAlign=Right
X=([#s_RightPanelW])
Y=([#s_PanelH] - [link:H] - [description:H] - [#s_VariablePadding])
DynamicVariables=1
[link]
Meter=String
Text=https://github.com/sceleri/settings
StringAlign=Right
X=([#s_RightPanelW])
MeterStyle=VarDescription | {Container}
MouseOverAction=[!SetOption #CURRENTSECTION# FontColor [#s_SelectedColor]][!SetOption #CURRENTSECTION# InlineSetting "Underline"][!UpdateMeter #CURRENTSECTION#][!Redraw]
MouseLeaveAction=[!SetOption #CURRENTSECTION# FontColor [#s_FontColor]][!SetOption #CURRENTSECTION# InlineSetting ""][!UpdateMeter #CURRENTSECTION#][!Redraw]
Y=0R
LeftMouseUpAction=["https://github.com/sceleri/settings"]
