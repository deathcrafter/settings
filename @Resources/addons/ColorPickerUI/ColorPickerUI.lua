color=''
path=''
config={}
colorPickerActive=''

internal={
    section='',
    option='',
    filePath='',
    actionQueue=''
}

function Initialize()
    path=SELF:GetOption('ScriptFile'):gsub('%.lua$', '.ini')
    if not path:match('^%w%:.*') then
        path=SKIN:MakePathAbsolute(path)
    end
    local file=assert(io.open(path), string.format('File path %s invalid!', path))
    file:close()
    local pathT=ParseFilePath(path)
    local rootPath=ParseFilePath(SKIN:GetVariable('ROOTCONFIGPATH'))
    if pathT.Ext then
        for i=#rootPath, #pathT-1 do
            table.insert(config, pathT[i])
        end
    else
        for i=#rootPath, #pathT do
            table.insert(config, pathT[i])
        end
    end
    config=table.concat(config, '\\')
    dofile(path:gsub('\\[^\\]+%.ini$', '')..[[\Scripts\Functions.lua]])
end

function SetColor(option, section, format, filePath, actionSection)
    local prevColor
    if section:lower()=='variables' then
        prevColor=SKIN:GetVariable(option, '255,255,255')
    else
        local sec=SKIN:GetMeasure(section) or SKIN:GetMeter(section)
        prevColor=sec and sec:GetOption(option, '255,255,255') or '255,255,255'
    end
    local colorFormats={'rgb','rgba', 'hex', 'hexa', 'hsv', 'hsva', 'hsl', 'hsla'}
    if not format then
        format='rgb'
    elseif not TableContains.Value(colorFormats, format) then
        format='rgb'
    end
    internal.section, internal.option=section, option

    filePath=filePath or ''
    if filePath=='' then
        filePath=SKIN:ReplaceVariables('#CURRENTPATH##CURRENTFILE#')
    end
    internal.filePath=filePath

    if actionSection then
        actionSection=SKIN:GetMeter(actionSection) or SKIN:GetMeasure(actionSection)
        internal.actionQueue=actionSection:GetOption('ColorChangeAction', '')
    end

    local t={'[Variables]'}

    local file = path:gsub('ColorPickerUI%.ini$', 'UserData.inc')

    SKIN:Bang('!WriteKeyValue', 'Variables', 'FilePath', internal.filePath, file)
    SKIN:Bang('!WriteKeyValue', 'Variables', 'ConfigName', SKIN:GetVariable('CURRENTCONFIG'), file)
    SKIN:Bang('!WriteKeyValue', 'Variables', 'SectionName', section, file)
    SKIN:Bang('!WriteKeyValue', 'Variables', 'OptionName', option, file)
    SKIN:Bang('!WriteKeyValue', 'Variables', 'Format', format, file)
    SKIN:Bang('!WriteKeyValue', 'Variables', 'PreviousColor', prevColor, file)
    SKIN:Bang('!WriteKeyValue', 'Variables', 'ScriptMeasure', SELF:GetName(), file)
    local theme=SELF:GetOption('Theme', 'Dark'):gsub('^%s*$', 'Dark')
    if not FileExist(path:gsub('ColorPickerUI%.ini$', [[Themes\]]..theme..'.inc')) then
        SKIN:Bang('!Log', 'Theme '..theme..' doesn\'t exist, defaulted to Dark!', 'ERROR')
        theme='Dark'
    end
    SKIN:Bang('!WriteKeyValue', 'Variables', 'Theme', theme, file)
    local animation=SELF:GetOption('Animations', '1'):gsub('^%s*$', '1')
    animation=animation=='0' and '2' or '1'

    local userData=ReadIni(path:gsub('ColorPickerUI%.ini$', 'UserData.inc'))

    if userData['INI']['Variables']['Active']=='0' then
        SKIN:Bang('!WriteKeyValue', 'Variables', 'Animations', animation, file)
        SKIN:Bang('!ActivateConfig', config)
    else
        SKIN:Bang('!Refresh', config)
    end
end

function FinishAction()
    local actionQ=ParseAction(internal.actionQueue:gsub('%$color%$', color))
    local action=ParseAction(SELF:GetOption('OnFinishAction', ''):gsub('%$color%$', color))
    if actionQ~='' then SKIN:Bang(actionQ) end
    if action~='' then SKIN:Bang(action) end
end

function DismissAction()
    local action=ParseAction(SELF:GetOption('OnDismissAction',''))
    if action~='' then SKIN:Bang(action) end
end

function ParseAction(action)
    action=action:gsub('%$section%$', internal.section)
    action=action:gsub('%$option%$', internal.option)
    action=action:gsub('%$filePath%$', internal.filePath)
    return action
end

function GetSubConfig(s) -- Gets the config name from file path
    local pathT=ParseFilePath(s)
    local configT={}
    local rootPath=ParseFilePath(SKIN:GetVariable('ROOTCONFIGPATH'))
    if pathT.Ext then
        for i=#rootPath, #pathT-1 do
            table.insert(configT, pathT[i])
        end
    else
        for i=#rootPath, #pathT do
            table.insert(configT, pathT[i])
        end
    end
    configT=table.concat(configT, '\\')
    return configT
end

function ParseFilePath(s)
	assert(type(s) == 'string', 'ParseFilePath: string expected, got ' .. type(s) .. '.')
	local t = {}
	for Piece in s:gmatch('[^\\]+') do
		table.insert(t, Piece)
	end
	-- VOLUME
	if #t > 0 then
		local UNCprefix = s:match('^(\\\\)') or ''
		t.Vol = UNCprefix .. t[1] .. '\\'
	end
	-- NAME
	if #t > 1 then
		-- DETECT FOLDER OR SEPARATE EXTENSION
		if s:match('\\$') then
			t.Name = t[#t] .. '\\'
		elseif t[#t]:match('.+%..+') then
			t.Name, t.Ext = t[#t]:match('(.-)%.([^%.]-)$')
		else
			t.Name = t[#t]
		end
	end
	-- FOLDER
	if #t > 2 then
		t.Dir = table.concat(t, '\\', 2, #t-1) .. '\\'
	end
	return t
end

function FileExist(strFileName)
    local fileHandle, strError = io.open(strFileName,"r")
	if fileHandle ~= nil then
		io.close(fileHandle)
		return true
	elseif string.match(strError,"No such file or directory") then
		return false
	end
end