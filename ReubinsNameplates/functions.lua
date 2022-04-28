----------------------------------------
-- NAMESPACES
----------------------------------------
local myAddon, core = ...
core.func = {}
core.frames = {}
local func = core.func
local frames = core.frames
local marks_table = {}
local health_table = {}
local holder_table = {}
local Ticker
----------------------------------------
-- SETTINGS
----------------------------------------
ReubinsNameplates_settings = ReubinsNameplates_settings or {} -- Settings table
ReubinsNameplates_settings.Tank = ReubinsNameplates_settings.Tank or false -- Tank mode
ReubinsNameplates_settings.Solo = ReubinsNameplates_settings.Solo or true -- Solo
ReubinsNameplates_settings.Party = ReubinsNameplates_settings.Party or true -- Party
ReubinsNameplates_settings.ShowText = ReubinsNameplates_settings.ShowText or true -- Show Text
ReubinsNameplates_settings.TextSize = ReubinsNameplates_settings.TextSize or 16 -- Text Size
----------------------------------------
-- COLORS
----------------------------------------
local transparent = {0, 0, 0, 0}
local gray = {0.69, 0.69, 0.69, 1}
local green = {0.11, 1, 0, 1}
local yellow = {1, 1, 0.47, 1}
local orange = {1, 0.6, 0, 1}
local red = {1, 0, 0, 1}
local gold = {1, 0.99, 0.32, 1}
local function color(color)
    r,g,b,a = unpack{color[1],color[2],color[3],color[4]}
    return r,g,b,a
end
----------------------------------------
-- POSITIONS
----------------------------------------
local xy_mark = {-1, -7}
local xy_heath = {0, -7}
local function position(frame)
    x,y = unpack{frame[1],frame[2]}
    return x,y
end
----------------------------------------
-- RESET HEALTH FRAME
----------------------------------------
local function Reset_Health(unit)
    for key, value in pairs(health_table) do
        if unit == key then 
            value:SetText("")
            value:ClearAllPoints()
            value:Hide()
            key = nil
        end
    end
    for key, value in pairs(holder_table) do
        if unit == key then 
            value:ClearAllPoints()
            key = nil
        end
    end
end
----------------------------------------
-- FORMATING NUMBER
----------------------------------------
local function format_number(number)
    if number >= 10^6 then
        return string.format("%.2fm", number / 10^6)
    elseif number >= 10^4 then
        return string.format("%.0fk", number / 10^3)
    elseif number >= 10^3 then
        return string.format("%.1fk", number / 10^3)
    else
        return tostring(number)
    end
end
----------------------------------------
-- UPDATING MARKS
----------------------------------------
local function Update_Mark()
    for key, value in pairs(marks_table) do
        local frame_anchor = C_NamePlate.GetNamePlateForUnit(key)
        local nameplate, aggro, tank, threat, status = func:FilterMark(key)
        if ReubinsNameplates_settings.Tank == false then
            -- Hiding mark
            if status == nil and aggro == false then 
                value:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\mark")
                value:SetVertexColor(color(transparent))
                value:Hide()
                value:SetPoint("LEFT", frame_anchor, "RIGHT", position(xy_mark))
            end
            -- low on threat
            if status == 0 then 
                value:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\mark")
                value:SetVertexColor(color(transparent))
                value:Show()
                value:SetPoint("LEFT", frame_anchor, "RIGHT", position(xy_mark))
            end
            -- high threat
            if status == 1 then 
                value:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\mark")
                value:SetVertexColor(color(yellow))
                value:Show()
                value:SetPoint("LEFT", frame_anchor, "RIGHT", position(xy_mark))
            end
            -- primary target but not on high threat
            if status == 2 then 
                value:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\mark")
                value:SetVertexColor(color(orange))
                value:Show()
                value:SetPoint("LEFT", frame_anchor, "RIGHT", position(xy_mark))
            end
            -- primary target and high threat
            if status == 3 then
                value:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\mark")
                value:SetVertexColor(color(red))
                value:Show()
                value:SetPoint("LEFT", frame_anchor, "RIGHT", position(xy_mark))
            end
            -- primary target but threat is unknown
            if status == nil and aggro == true then
                value:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\mark")
                value:SetVertexColor(color(red))
                value:Show()
                value:SetPoint("LEFT", frame_anchor, "RIGHT", position(xy_mark))
            end
        else
            ----------------------------------------
            -- TANK MODE
            ----------------------------------------
            -- Hiding mark
            if status == nil and aggro == false then 
                value:SetVertexColor(color(transparent))
                value:Hide()
                value:SetPoint("LEFT", frame_anchor, "RIGHT", position(xy_mark))
            end
            -- low on threat
            if status == 0 then 
                value:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\shield_2")
                value:SetVertexColor(color(red))
                value:Show()
                value:SetPoint("LEFT", frame_anchor, "RIGHT", position(xy_mark))
            end
            -- high threat
            if status == 1 then
                value:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\shield_2")
                value:SetVertexColor(color(red))
                value:Show()
                value:SetPoint("LEFT", frame_anchor, "RIGHT", position(xy_mark))
            end
            -- primary target but not on high threat
            if status == 2 then
                value:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\shield_1")
                value:SetVertexColor(color(orange))
                value:Show()
                value:SetPoint("LEFT", frame_anchor, "RIGHT", position(xy_mark))
            end
            -- primary target and high threat
            if status == 3 then
                value:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\shield_1")
                value:SetVertexColor(color(green))
                value:Show()
                value:SetPoint("LEFT", frame_anchor, "RIGHT", position(xy_mark))
            end
            -- primary target but threat is unknown
            if status == nil and aggro == true then
                value:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\shield_1")
                value:SetVertexColor(color(green))
                value:Show()
                value:SetPoint("LEFT", frame_anchor, "RIGHT", position(xy_mark))
            end
        end
    end
end
----------------------------------------
-- UPDATING HEALTH
----------------------------------------
local function Update_Health(unit)
    local frame_anchor = C_NamePlate.GetNamePlateForUnit(unit)
    for key, value in pairs(holder_table) do
        if unit == key then
            value:SetPoint("CENTER", frame_anchor, "CENTER", position(xy_heath))
        end
    end
    for key, value in pairs(health_table) do
        if unit == key then
            value:SetText(format_number(UnitHealth(unit)))
            value:SetPoint("CENTER", frame_anchor, "CENTER", position(xy_heath))
        end
    end
end
----------------------------------------
-- FILTERING, CHECKING AGGRO AND THREAT
----------------------------------------
function func:FilterMark(unit)
    if UnitExists(unit) then
        if not UnitIsPlayer(unit) and not UnitIsOtherPlayersPet(unit) then 
            local tank, status, threat = UnitDetailedThreatSituation("player", unit) 
            local aggro = UnitIsUnit(unit.."target", "player") 
            local nameplate = unit 
            return nameplate, aggro, tank, threat, status
        end
    end
end
----------------------------------------
-- FILTERING, CHECKING HEALTH
----------------------------------------
function func:FilterHealth(unit)
    if UnitExists(unit) then
        if not UnitIsPlayer(unit) and not UnitIsOtherPlayersPet(unit) then 
            local health = format_number(UnitHealth(unit)) 
            local nameplate = unit 
            return nameplate, health
        end
    end
end
----------------------------------------
-- CHECKING MARK OPTIONS
----------------------------------------
function func:Mark_Options_Check()
    for key, value in pairs(marks_table) do
        if key then
            -- If neither
            if ReubinsNameplates_settings.Solo == false and ReubinsNameplates_settings.Party == false then
                value:Hide()
            end
            -- If Both
            if ReubinsNameplates_settings.Solo == true and ReubinsNameplates_settings.Party == true then
                Update_Mark()
            end
            -- If solo only
            if ReubinsNameplates_settings.Solo == true and ReubinsNameplates_settings.Party == false then
                if UnitInParty("player") == false then
                    Update_Mark()
                end
            end
            -- If in party
            if ReubinsNameplates_settings.Solo == false and ReubinsNameplates_settings.Party == true then
                if UnitInParty("player") == true then
                    Update_Mark()
                end
            end
        else
            local nameplate, aggro, tank, threat, status = func:FilterMark(key)
            Marks:CreateMark(func:FilterMark(unit))
        end
    end
end
----------------------------------------
-- CREATING MARK
----------------------------------------
function func:CreateMark(nameplate, aggro, tank, threat)
    if nameplate then
        local table_key = nameplate
        local frame_anchor = C_NamePlate.GetNamePlateForUnit(nameplate)
        local nameplate = CreateFrame("Frame", "ReubinsNameplates_mark_"..table_key, UIParent)
        nameplate.mark = nameplate:CreateTexture(nil,"ARTWORK", UIParent)
        nameplate.mark:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\mark")
        nameplate.mark:SetVertexColor(0, 0, 0, 0) 
        nameplate.mark:SetPoint("LEFT", frame_anchor, "RIGHT", position(xy_mark))
        nameplate.mark:SetSize(22, 22)
        nameplate.mark:SetParent(frame_anchor)
        nameplate.mark:Hide()
        marks_table[table_key] = nameplate.mark
    end
end
----------------------------------------
-- CREATING HEALTH TEXT
----------------------------------------
function func:CreateHealth(nameplate, health)
    if nameplate then
        local table_key = nameplate
        local frame_anchor = C_NamePlate.GetNamePlateForUnit(nameplate)
        local nameplate = CreateFrame("Frame", nil, UIParent)
        nameplate.holder = CreateFrame("Frame", nil, frame_anchor) 
        nameplate.holder:SetFrameStrata("DIALOG") 
        nameplate.holder:SetParent(frame_anchor) 
        nameplate.health = nameplate:CreateFontString(nil, "OVERLAY") 
        nameplate.health:SetPoint("CENTER", frame_anchor, "CENTER", position(xy_heath))
        nameplate.health:SetParent(nameplate.holder)
        nameplate.health:SetFont("Fonts\\FRIZQT__.TTF", ReubinsNameplates_settings.TextSize, "OUTLINE")
        nameplate.health:SetTextColor(color(gold))
        nameplate.health:SetShadowColor(0, 0, 0, 1)
        nameplate.health:SetShadowOffset(1, -1)
        nameplate.health:SetText(health)
        nameplate.health:SetIgnoreParentScale(true)
        nameplate.health:SetShown(ReubinsNameplates_settings.ShowText)
        holder_table[table_key] = nameplate.holder
        health_table[table_key] = nameplate.health
    end
end
----------------------------------------
-- HEALTH TEXT UPDATE FUNCTION
----------------------------------------
function func:UpdateHealth(unit)
    Update_Health(unit)
end
----------------------------------------
-- HIDING MARKS
----------------------------------------
function func:HideMark(unit)
    for key, value in pairs(marks_table) do
        if unit == key then
            value:Hide() 
            value:ClearAllPoints()
            key = nil
        end
    end
end
----------------------------------------
-- HIDING HEALTH TEXT
----------------------------------------
function func:HideHealth(unit)
    Reset_Health(unit)
end
----------------------------------------
-- UPDATE HEALTH TEXT OPTIONS
----------------------------------------
function func:UpdateOptionsHealth()
    for _, value in pairs(health_table) do
        value:SetShown(ReubinsNameplates_settings.ShowText)
        value:SetFont("Fonts\\FRIZQT__.TTF", ReubinsNameplates_settings.TextSize, "OUTLINE")
    end
end
----------------------------------------
-- STARTING TICKER
----------------------------------------
function func:StartTicker()
    Ticker = C_Timer.NewTicker(0.33, function() 
        func:Mark_Options_Check()
    end)
end 
----------------------------------------
-- STOPPING TICKER
----------------------------------------
function func:StopTicker() 
    Ticker:Cancel()
    for key, value in pairs(marks_table) do
        value:Hide() 
        value:ClearAllPoints()
        key = nil
    end
end