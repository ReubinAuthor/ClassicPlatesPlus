----------------------------------------
-- Namespace
----------------------------------------
local myAddon, core = ...
local func = core.func
local frames = core.frames
----------------------------------------
-- HANDLING EVENTS 
----------------------------------------
function core:init(event, ...)
    if event == "ADDON_LOADED" then
        local name = ...
        if name == myAddon then
            func:Settings() -- Settings
        end
    end
    ----------------------------------------
    if event == "PLAYER_LOGOUT" then
        func:Save_Settings() -- Saving settings
    end
    ----------------------------------------
    if event == "NAME_PLATE_UNIT_ADDED" then
        local unit = ...
        func:CreateMark(func:FilterMark(unit))
        func:CreateHealth(func:FilterHealth(unit))
    end
    ----------------------------------------
    if event == "NAME_PLATE_UNIT_REMOVED" then
        local unit = ...
        func:HideMark(unit)
        func:HideHealth(unit)
    end
    ----------------------------------------
    if event == "PLAYER_REGEN_DISABLED" then
        func:StartTicker()
    end
    ----------------------------------------
    if event == "PLAYER_REGEN_ENABLED" then
        func:StopTicker()
    end
    ----------------------------------------
    if event == "UNIT_THREAT_LIST_UPDATE" then
        func:Mark_Options_Check()
    end
    ----------------------------------------
    if event == "UNIT_HEALTH_FREQUENT" then
        local unit = ...
        func:UpdateHealth(unit) 
    end
end
----------------------------------------
-- REGISTERING SLASH COMMANDS
----------------------------------------
SLASH_RPLATES1 = "/rplates"
local function Slash_Handler(msg)
    if msg == "tank" then
        ReubinsNameplates_settings.Tank = ReubinsNameplates_settings.Tank or false
        ReubinsNameplates_settings.Tank = not ReubinsNameplates_settings.Tank
        func:Mark_Options_Check()
        if ReubinsNameplates_settings.Tank == true then
            print("|cff00ccffReubin's Nameplates: |cffFFFC54Tank mode activated")
        else
            print("|cff00ccffReubin's Nameplates: |cffFFFC54Tank mode deactivated")
        end
    end
end
SlashCmdList["RPLATES"] = Slash_Handler
----------------------------------------
-- Registering events
----------------------------------------
local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_LOGOUT")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:RegisterEvent("PLAYER_REGEN_DISABLED")
events:RegisterEvent("NAME_PLATE_UNIT_ADDED")
events:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
events:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
events:RegisterEvent("UNIT_HEALTH_FREQUENT")
events:SetScript("OnEvent", core.init)