[ListIcon{Index}]
Meter=String
Text={Icon}
MeterStyle=CategoryListIcon | {Container}
[Category{Index}]
Meter=String
Text={Category}
MeterStyle=CategoryListSuperItem | {Container}
X=([ListIcon{Index}:W] > #s_ListIconLeftPadding# ? ([ListIcon{Index}:W]) : 0)r
