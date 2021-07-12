[Variables]

;! | SkinName Theme 1 | SkinDirectory Themes 
s_OnChangeAction=[!Refresh #ROOTCONFIG#][!CommandMeasure Generator Construct #ROOTCONFIG#]

;@About | Name About theme: [#s_Theme1Name] | Description Customize the theme here 

;@Topic | Name Customization
;@ | Name Background
;?Integer | Name Left panel width | Description 
s_LeftPanelW=200
;?Integer | Name Right panel width | Description 
s_RightPanelW=500
;?Integer | Name Skin height | Description 
s_PanelH=600
;?Color | Name Right panel background color
s_RightPanelBackgroundColor=26,26,38,125
;?Color | Name Left panel background color 
s_LeftPanelBackgroundColor=28,28,43,125
;?Integer | Name Background corner radius
s_BackgroundRounding=5
;? | Name FrostedGlass mode | Description Only available on Windows 10#CRLF#A certain Windows 10 update made Acrylic very laggy so it's not recommended.#CRLF#Available modes: Acrylic, Blur, None
s_FrostedGlassMode=Blur
;? | Name FrostedGlass border | Description All, None, Left, Right, Top and Bottom. Can be combined with pipes
s_FrostedGlassBorders=None

;@ | Name Font
;? | Name Font face | Description 
s_FontFace=Segoe UI
;? | Name Icon font face | Description 
s_IconFontFace=Segoe MDL2 Assets
;?Color | Name Font color | Description 
s_FontColor=235,235,235
;?Integer | Name Font size 1 | Description Used for category titles
s_FontSize1=20
;?Integer | Name Font size 2 | Description Used for variable titles
s_FontSize2=16
;?Integer | Name Font size 3 | Description Used for variable values
s_FontSize3=12
s_InputTextFontSize=[#s_FontSize3]
;?Integer | Name Font size 4 | Description Used for descriptions
s_FontSize4=10
;?Integer | Name Font size 5 | Description Unused (for now)
s_FontSize5=8
;?Integer | Name Selected item font weight | Description 
s_SelectedFontWeight=500
;?Integer | Name Font weight | Description 
s_FontWeight=400

;@ | Name Scroll indicators
;?Integer | Name Right scroll indicator Y padding | Description uses s_VariableYPadding
s_RightScrollIndicatorYPadding=25
s_RightScrollIndicatorMaxHeight=([#s_PanelH] - ([#s_RightScrollIndicatorYPadding] * 2))
;?Integer | Name Right scroll indicator X padding | Description 
s_RightScrollIndicatorXPadding=5
;?Integer | Name Right scroll indicator width | Description 
s_RightScrollIndicatorWidth=5
;?Color | Name Right scroll indicator color | Description 
s_RightScrollIndicatorColor=255,255,255
;?Integer | Name Right scroll indicator rounding | Description From 0 - 1 (where 0 is no rounding, 1 is fully rounded)
s_RightScrollIndicatorRounding=1
;?Integer | Name Left scroll indicator Y padding | Description uses s_VariableYPadding
s_LeftScrollIndicatorYPadding=25
s_LeftScrollIndicatorMaxHeight=([#s_PanelH] - ([#s_LeftScrollIndicatorYPadding] * 2))
;?Integer | Name Left scroll indicator X padding | Description 
s_LeftScrollIndicatorXPadding=5
;?Integer | Name Left scroll indicator width | Description 
s_LeftScrollIndicatorWidth=5
;?Color | Name Left scroll indicator color | Description 
s_LeftScrollIndicatorColor=240,240,240
;?Integer | Name Left scroll indicator rounding | Description From 0 - 1 (where 0 is no rounding, 1 is fully rounded)
s_LeftScrollIndicatorRounding=1

;@ | Name Selected indicator
;?Color | Name Selected color | Description Most selected items use this color
s_SelectedColor=1671D9
;?Integer | Name Indicator height padding | Description 
s_SelectorPadding=5
;?Integer | Name Indicator width  | Description 
s_SelectorWidth=3
;?Integer | Name Indicator rounding | Description default: [#s_SelectorWidth]
s_SelectorRounding=[#s_SelectorWidth]

;@Topic | Name Categories
;@ | Name Category
;?Integer | Name Category title top and bottom padding | Description 
s_CategoryTitleXPadding=20
;?Integer | Name Category title top padding | Description 
s_CategoryTitleTopPadding=35
;?Integer | Name Category title bottom padding | Description 
s_CategoryTitleBottomPadding=20
;?Integer | Name Category title font weight | Description 
s_CategoryTitleFontWeight=500
;?Integer | Name Category description font weight | Description 
s_CategoryDescriptionFontWeight=500
;? | Name Category icon nudge | Description Visually center the category icon
s_CategoryIconNudge=5
s_CategoryIconTopPadding=([#s_CategoryTitleTopPadding] + [#s_CategoryIconNudge])

;@Topic | Name Category list

;@ | Name General
;?Integer | Name List item top and bottom padding | Description 
s_ListYPadding=7
;? | Name List item right padding | Description Used for width calculations for ClipString=2
s_ListRightPadding=15
;?Info | Name Settings credit icon padding | Description Move the Settings link/credit icon
5=https://www.youtube.com/watch?v=dQw4w9WgXcQ
s_CreditIconPadding=(5 + [#s_BackgroundRounding] / 2)
s_CreditIconSize=12

;@ | Name About items
;?Integer | Name About item top padding | Description 
s_ListAboutTopPadding=100
;?Integer | Name About item bottom padding | Description 
s_ListAboutBottomPadding=15
s_ListAboutTotalPadding=([#s_ListAboutTopPadding] + [#s_ListAboutBottomPadding])
;?Integer | Name About item left padding | Description 
s_ListAboutLeftPadding=15
;?Integer | Name About item icon gap | Description 
s_ListAboutGap=7

;@ | Name Default items
;?Integer | Name Default item top padding | Description 
s_ListDefaultTopPadding=0
;?Integer | Name Default item bottom padding | Description 
s_ListDefaultBottomPadding=0
s_ListDefaultTotalPadding=([#s_ListDefaultTopPadding] + [#s_ListDefaultBottomPadding])
;?Integer | Name Default item left padding | Description 
s_ListDefaultLeftPadding=15
;?Integer | Name Default item icon gap | Description 
s_ListDefaultGap=0

;@ | Name Topic items
;?Integer | Name Topic item top padding | Description 
s_ListTopicTopPadding=15
;?Integer | Name Topic item bottom padding | Description 
s_ListTopicBottomPadding=0
s_ListTopicTotalPadding=([#s_ListTopicTopPadding] + [#s_ListTopicBottomPadding])
;?Integer | Name Topic item left padding | Description 
s_ListTopicLeftPadding=15
;?Integer | Name Topic item icon gap | Description 
s_ListTopicGap=5

;@Topic | Name Variables
;@ | Name Variable
;?Integer | Name Variable title font weight | Description s_VariableTitleFontWeight
s_VariableTitleFontWeight=400
;? | Name Variable icon gap | Description Gap between Variable icons and titles
s_VariableIconGap=5
;? | Name Variable icon top padding | Description Visually center the variable icon
s_VariableIconTopPadding=10
;?Integer | Name Variable value meter top and bottom padding | Description s_VariableYPadding
s_VariableYPadding=5
;?Integer | Name Variable item left and right padding | Description s_VariableXPadding (applies for variable titles, descriptions and values)
s_VariableXPadding=20
;?Toggle | Name Indent variables | Description Not implemented
s_IndentVariables=1

;@ | Name Color
;?Integer | Name Color circle radius | Description s_ColorSize
s_ColorSize=15
;?Integer | Name Color circle stroke width | Description s_ColorStrokeWidth
s_ColorStrokeWidthDefault=1
s_ColorStrokeWidth=1
;?Integer | Name Color circle stroke width on hover | Description s_ColorStrokeWidthSelected
s_ColorStrokeWidthSelected=2
;?Color | Name Color circle stroke color | Description s_ColorStrokeColor (will change to s_Selected when hovered)
s_ColorStrokeColor=200,200,200
;?Integer | Name Gap between the circle and the string | Description s_ColorStringLeftPadding
s_ColorStringLeftPadding=10

;@ | Name Toggle
;?Integer | Name Toggle height | Description s_ToggleSize
s_ToggleSize=20
;?Integer | Name Toggle width | Description s_ToggleLength
s_ToggleLength=25
;?Integer | Name Toggle internal padding | Description s_TogglePadding
s_TogglePadding=2.5
;?Info | Name TODO | Link 0
More variables for Toggle customization=
s_ToggleActiveColor=[#s_SelectedColor]
s_ToggleInactiveColor=[#s_RightPanelBackgroundColor]
