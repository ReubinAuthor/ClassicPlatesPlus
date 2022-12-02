----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- HANDLING EVENTS 
----------------------------------------
function core:init(event, ...)
    local arg = ...

    if event == "VARIABLES_LOADED" then
        func:CVars(event);
    end
    if event == "ADDON_LOADED" then
        if arg == myAddon then
            func:Load_Settings();
        end
    end
    if event == "PLAYER_LOGOUT" then
        func:Save_Settings();
        func:CVars(event);
    end
    if event == "NAME_PLATE_CREATED" then
        func:Nameplate_Created(arg);
    end
    if event == "NAME_PLATE_UNIT_ADDED" then
        func:Nameplate_Added(arg);
    end
    if event == "NAME_PLATE_UNIT_REMOVED" then
        func:Nameplate_Removed(arg);
    end
    if event == "UNIT_THREAT_LIST_UPDATE" then
        func:Update_ThreatPercentage(arg);
        func:Update_ThreatIcon(arg);
    end
    if event == "UNIT_THREAT_SITUATION_UPDATE" then
        func:Update_ThreatIcon(arg);
    end
    if event == "UNIT_CLASSIFICATION_CHANGED" then
        func:Update_Classification(arg);
    end
    if event == "UNIT_HEALTH_FREQUENT" then
        func:Update_Health(arg);
    end
    if event == "UNIT_POWER_FREQUENT" then
        func:Update_Powerbar(arg);
    end
    if event == "UNIT_AURA" then
        func:Update_Auras(arg);
    end
    if event == "GROUP_ROSTER_UPDATE" then
        func:Update_Roster();
    end
    if event == "PLAYER_ENTERING_WORLD" then
        func:Update_Roster();
    end
    if event == "PLAYER_TARGET_CHANGED" then
        func:Selected();
    end
    if event == "UPDATE_MOUSEOVER_UNIT" then
        func:Mouseover();
    end
    if event == "PLAYER_FLAGS_CHANGED" then
        func:Update_healthbar(arg);
    end
    if event == "UNIT_FACTION" then
        func:Update_healthbar(arg);
        func:Update_Portrait(arg);
        func:Update_PVP_Flag(arg);
    end
    if event == "UNIT_PORTRAIT_UPDATE" then
        func:Update_Portrait(arg);
        func:Update_Powerbar(arg);
    end
    if event == "UNIT_NAME_UPDATE" then
        func:Update_Name(arg);
    end
    if event == "UNIT_LEVEL" then
        func:Update_Level(arg);
    end
    if event == "UNIT_COMBAT" then
        func:Update_Name(arg);
        func:Update_healthbar(arg);
    end
    if event == "UNIT_MAXHEALTH" then
        func:Update_Health(arg);
        func:Update_healthbar(arg);
    end
    if event == "UNIT_MAXPOWER" then
        func:Update_Powerbar(arg);
    end
    if event == "MODIFIER_STATE_CHANGED" then
        local key, down = ...
        func:Hotkeys_Pressed(key, down);
    end
    if event == "UNIT_SPELLCAST_START"
    or event == "UNIT_SPELLCAST_CHANNEL_START"
    or event == "UNIT_SPELLCAST_DELAYED"
    or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
        func:Castbar_Start(event, arg);
    end
    if event == "UNIT_SPELLCAST_STOP"
    or event == "UNIT_SPELLCAST_CHANNEL_STOP"
    or event == "UNIT_SPELLCAST_FAILED"
    or event == "UNIT_SPELLCAST_FAILED_QUIET"
    or event == "UNIT_SPELLCAST_INTERRUPTED"
    or event == "UNIT_SPELLCAST_SUCCEEDED" then
        func:Castbar_End(event, arg);
    end
    if event == "RAID_TARGET_UPDATE" then
        func:RaidTargetIndex();
    end
    if event == "UPDATE_SHAPESHIFT_FORM" then
        local nameplates = C_NamePlate.GetNamePlates();

        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    local UnitFrame = v.UnitFrame;
                    local inInstance, instanceType = IsInInstance();
                    local unit = v.unitFrame.unit;

                    -- Hiding Blizzard's nemplates for enemies inside dungeons
                    if inInstance and (instanceType == "party" or instanceType == "raid") then
                        if not UnitPlayerOrPetInParty(unit) then
                            UnitFrame:Hide();
                        end
                    else
                        UnitFrame:Hide();
                    end
                end
            end
        end
    end
end

----------------------------------------
-- REGISTERING SLASH COMMANDS
----------------------------------------
SLASH_RPLATES1 = "/rplates";

local function Slash_Handler(msg)
    if msg == "tank" then
        local nameplates = C_NamePlate.GetNamePlates();

        ReubinsNameplates_settings.TankMode = ReubinsNameplates_settings.TankMode or false;
        ReubinsNameplates_settings.TankMode = not ReubinsNameplates_settings.TankMode;

        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    func:Update_ThreatIcon(v.unitFrame.unit);
                end
            end
        end

        -- Typing out confirmation in the chat
        if ReubinsNameplates_settings.TankMode then
            print("|cfff563ff[Reubin's Nameplates] |cffffffffTank mode activated!");
        else
            print("|cfff563ff[Reubin's Nameplates] |cffffffffTank mode deactivated!");
        end

        data.TankModeCheckButton:SetChecked(ReubinsNameplates_settings.TankMode);
    end
end

SlashCmdList["RPLATES"] = Slash_Handler;

----------------------------------------
-- REGISTERING EVENTS
----------------------------------------
local events = CreateFrame("Frame");

-- Events
events:RegisterEvent("ADDON_LOADED");
events:RegisterEvent("VARIABLES_LOADED");
events:RegisterEvent("NAME_PLATE_CREATED");
events:RegisterEvent("NAME_PLATE_UNIT_ADDED");
events:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
events:RegisterEvent("PLAYER_LOGOUT");
events:RegisterEvent("PLAYER_ENTERING_WORLD");
events:RegisterEvent("PLAYER_REGEN_ENABLED");
events:RegisterEvent("PLAYER_REGEN_DISABLED");
events:RegisterEvent("PLAYER_FLAGS_CHANGED");
events:RegisterEvent("PLAYER_TARGET_CHANGED");
events:RegisterEvent("UNIT_THREAT_LIST_UPDATE");
events:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE");
events:RegisterEvent("UNIT_CLASSIFICATION_CHANGED");
events:RegisterEvent("UNIT_HEALTH_FREQUENT");
events:RegisterEvent("UNIT_POWER_FREQUENT");
events:RegisterEvent("UNIT_AURA");
events:RegisterEvent("UNIT_FACTION");
events:RegisterEvent("UNIT_PORTRAIT_UPDATE");
events:RegisterEvent("UNIT_NAME_UPDATE");
events:RegisterEvent("UNIT_LEVEL");
events:RegisterEvent("UNIT_COMBAT");
events:RegisterEvent("UNIT_MAXHEALTH");
events:RegisterEvent("UNIT_MAXPOWER");
events:RegisterEvent("GROUP_ROSTER_UPDATE");
events:RegisterEvent("MODIFIER_STATE_CHANGED");
events:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
events:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
events:RegisterEvent("RAID_TARGET_UPDATE");
events:RegisterEvent("UPDATE_SHAPESHIFT_FORM");

-- Castbar events
events:RegisterEvent("UNIT_SPELLCAST_START");
events:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
events:RegisterEvent("UNIT_SPELLCAST_DELAYED");
events:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
events:RegisterEvent("UNIT_SPELLCAST_STOP");
events:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
events:RegisterEvent("UNIT_SPELLCAST_FAILED");
events:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET");
events:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
events:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");

-- Scripts
events:SetScript("OnEvent", core.init);