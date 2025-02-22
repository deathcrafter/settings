function Initialize()
    if SKIN:GetVariable('CURRENTCONFIG'):find('DesktopPicker') then
        dofile(SKIN:MakePathAbsolute([[..\Scripts\Functions.lua]]))
    else
        dofile(SKIN:MakePathAbsolute([[Scripts\Functions.lua]]))
    end
end

function ConvertHSV(string, format)
    return ConvertColor.HSV(string, format)
end

function GetColor(color)
    local format = SKIN:GetVariable('Format', 'rgb'):lower()
    local colorTable={}
    colorTable['rgba']=DelimAndRound(ConvertColor.HSV(color, 'rgb'),0)
    colorTable['rgb']=colorTable['rgba']:gsub('%,[^%,]+$', '')
    colorTable['hexa']=ConvertColor.HSV(color, 'hex')
    colorTable['hex']=colorTable['hexa']:gsub('%w%w$', '')
    colorTable['hsla']=DelimAndRound(ConvertColor.HSV(color, 'hsl'),2)
    colorTable['hsl']=colorTable['hsla']:gsub('%,[^%,]+$', '')
    colorTable['hsva']=DelimAndRound(color,2)
    colorTable['hsv']=colorTable['hexa']:gsub('%,[^%,]+$', '')
    return colorTable[format]
end

function SetInputColor(color, format)
    color=TruncWhiteSpace(color)
    if color:match("^#?[^,%s]+$") then
        color=color:gsub('^#?(.*)$', '%1')
        color = ConvertColor.HEX(color, rgb)
    elseif color:match('^%d+%s*,%s*%d+%s*,%s*%d+,?%d*%s*$') then
        color=color
    else
        Log('ColorPickerUI:Color format wrong!', 'ERROR')
        SKIN:Bang('!SetOption', 'ColorText', 'Text', 'Wrong format!')
        SKIN:Bang('!UpdateMeter', 'ColorText')
        SKIN:Bang('!Redraw')
        Wait(2)
        SKIN:Bang('!SetOption', 'ColorText', 'Text', '[&Color:GetColor(\'[#Hue],[#Saturation],[#Value],[#Alpha]\')]')
        SKIN:Bang('!UpdateMeter', 'ColorText')
        SKIN:Bang('!Redraw')

        return
    end
    color = ConvertColor.HEX(ConvertColor.RGB(color))
    color = Delim(color, ',')
    color = RGBtoHSV(color[1], color[2], color[3], color[4] or 255)

    local vars={'Hue', 'Saturation', 'Value', 'Alpha'}
    for k,v in ipairs(vars) do
        SKIN:Bang('!SetVariable', v, color[k])
    end
    SKIN:Bang('!UpdateMeter', '*')
    SKIN:Bang('!Update')
end

function DelimAndRound(string, num)
    string=Delim(string, ',')
    stringT={}
    for _,v in ipairs(string) do
        table.insert(stringT, Round(tonumber(v), num))
    end
    return table.concat(stringT, ',')
end

function StartDragging(variable,min,max,increment)
    SKIN:Bang('!SetOption', 'Mouse', 'LeftMouseDragAction', '[!SetVariable '..variable..' "('.. max-min ..SKIN:ReplaceVariables('*Clamp($MouseX$-20*#Scale#,0,300*#Scale#)/(300*#Scale#))"][!UpdateMeterGroup '..variable..'][!UpdateMeasure Mouse][!Redraw]'))
    SKIN:Bang('!UpdateMeasure', 'Mouse')
    SKIN:Bang('!CommandMeasure', 'Mouse', 'Start')
end

function ActivatePicker()
    local config=Get.Variable('CURRENTCONFIG')..[[\DesktopPicker]]
    SKIN:Bang('!ActivateConfig', config)
    SKIN:Bang('!SetVariable', 'Config', Get.Variable('CURRENTCONFIG'), config)
    SKIN:Bang('!Zpos', '2', config)
    SKIN:Bang('!HideFade')
end


function SetPickedColor() -- for use with desktop picker
    local color=Delim(Get.StringValue('Color'), ',')
    local config=SKIN:ReplaceVariables(Get.Variable('Config'))
    color=RGBtoHSV(color[1], color[2], color[3])
    local vars={'Hue', 'Saturation', 'Value'}
    for k,v in ipairs(vars) do
        SKIN:Bang('!SetVariable', v, color[k], config)
    end
    SKIN:Bang('!UpdateMeter', '*', config)
    SKIN:Bang('!Update', config)
    SKIN:Bang('!ShowFade', config)
    SKIN:Bang('!DeactivateConfig')
end

function WriteColor(color)
    color=GetColor(color)
    SKIN:Bang('!WriteKeyValue', Get.Variable('SectionName'), Get.Variable('OptionName'), color, SKIN:GetVariable('FilePath'))
    SKIN:Bang('!CommandMeasure', SKIN:GetVariable('ScriptMeasure'), 'color=\''..color..'\'', SKIN:GetVariable('ConfigName'))
    SKIN:Bang('!CommandMeasure', SKIN:GetVariable('ScriptMeasure'), 'FinishAction()', SKIN:GetVariable('ConfigName'))
    SKIN:Bang('!DeactivateConfig')
end