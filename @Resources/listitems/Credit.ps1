
$ini = @"
[CreditIcon]
FontSize=[#s_CreditIconSize]
AntiAlias=1
Meter=String
Text=[\xF259]
FontWeight=400
AccurateText=1
Padding=0,0,0,0
DynamicVariables=1
SolidColor=0,0,0,1
MeterStyle=LeftPanel
FontColor=[#s_FontColor]
X=[#s_CreditIconPadding]
FontWeight=[#s_FontWeight]
FontFace=Segoe MDL2 Assets
ToolTipTitle=Generated by Settings
ToolTipText=https://github.com/sceleri/settings
LeftMouseUpAction=["https://github.com/sceleri/settings"]
Y=([#s_PanelH] - [CreditIcon:H] - [#s_CreditIconPadding])
"@



return $ini