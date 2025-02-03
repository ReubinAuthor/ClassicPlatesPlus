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
    local arg = ...;

    if event == "VARIABLES_LOADED" then
        func:CVars(event);
    end

    if event == "ADDON_LOADED" then
        if arg == myAddon then
            func:Load_Settings();
        end
    end

    if event == "CVAR_UPDATE" then
        local cvarName, value = ...;

        func:Update_CVars(cvarName, value);
    end

    if event == "UI_SCALE_CHANGED"
    or event == "DISPLAY_SIZE_CHANGED" then
        func:ResizeNameplates();
    end

    if event == "MODIFIER_STATE_CHANGED" then
        local nameplate = data.nameplate;
        local key, down = ...;

        if down == 0 then
            nameplate.isMoving = false;
        end

        nameplate:EnableMouse((key == "LCTRL" or key == "RCTRL") and down == 1);
    end

    if event == "PLAYER_ENTERING_WORLD" then
        func:ClassBarHeight();
        func:Update_Roster();
        func:PersonalNameplateCreate();
        if not data.isRetail then
            func:PersonalNameplateAdd();
        end
    end

    if event == "PLAYER_LOGOUT" then
        func:CVars(event);
    end

    if event == "PLAYER_TARGET_CHANGED" then
        local CFG = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile];
        func:myTarget();
        func:Update_Colors();

        if CFG.AurasOnTarget then
            if UnitExists("target") then
                if data.myTarget.previous then
                    func:HideAllAuras(data.myTarget.previous);
                end
                func:Update_Auras("target");
            elseif data.myTarget.previous then
                func:HideAllAuras(data.myTarget.previous);
            else
                func:HideAllAuras();
            end
        end
    end

    if event == "PLAYER_FLAGS_CHANGED" then
        func:Update_healthbar(arg);
    end

    if event == "PLAYER_GUILD_UPDATE" then
        if arg and string.match(arg, "nameplate") then
            func:Update_Guild(arg);
            func:Update_FellowshipBadge(arg);
        end
    end

    if event == "PLAYER_DEAD"
    or event == "PLAYER_UNGHOST"
    or event == "PLAYER_ALIVE" then
        if not data.isRetail then
            func:ToggleNameplatePersonal(event);
        end
    end

    if event == "PLAYER_REGEN_ENABLED"
    or event == "PLAYER_REGEN_DISABLED" then
        if not data.isRetail then
            func:ToggleNameplatePersonal(event);
        end
    end

    if event == "PLAYER_SPECIALIZATION_CHANGED" then
        if arg == "player" then
            func:PersonalNameplateAdd();
        end
    end

    if event == "PLAYER_TOTEM_UPDATE" then
        func:Update_ClassPower();
    end

    if event == "UPDATE_SHAPESHIFT_FORM" then
        func:ClassBarHeight();
        func:PersonalNameplateAdd();
        if UnitExists("target") then
            local nameplate = C_NamePlate.GetNamePlateForUnit("target");

            if nameplate then
                func:PositionAuras(nameplate.unitFrame);
            end
        end
    end

    if event == "TALENT_GROUP_ROLE_CHANGED" then
        local groupIndex, newRole = ...;
        func:Update_Role(groupIndex, newRole);
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

    if event == "UNIT_CLASSIFICATION_CHANGED" then
        func:Update_Classification(arg);
    end

    if event == "UNIT_HEALTH" then
        func:Update_Health(arg);
    end

    if event == "UNIT_MAXHEALTH" then
        func:Update_Health(arg);
        func:Update_healthbar(arg);
    end

    if event == 'UNIT_HEAL_PREDICTION' then
        func:PredictHeal(arg);
    end

    if event == "UNIT_POWER_FREQUENT" then
        func:Update_Power(arg);
        func:Update_ClassPower(arg);
    end

    if event == "UNIT_MAXPOWER" then
        func:Update_Power(arg);
    end

    if event == "UNIT_AURA" then
        func:Update_Auras(arg);
        if arg == "player" then
            func:Update_ExtraBar();
        end
    end

    if event == "UNIT_THREAT_LIST_UPDATE" then
        func:Update_Threat(arg)
    end

    if event == "UNIT_THREAT_SITUATION_UPDATE" then
        func:Update_Threat(arg);
    end

    if event == "UNIT_FACTION" then
        func:Update_healthbar(arg);
        func:Update_Portrait(arg);
        func:Update_Name(arg);
        func:Update_Colors(arg);
        func:Nameplate_Added(arg);
        func:Update_PVP_Flag(arg);
    end

    if event == "UNIT_PORTRAIT_UPDATE" then
        func:Update_Portrait(arg);
        func:Update_Power(arg);
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
        func:Update_Name(arg);
        func:Update_Colors(arg);
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

    if event == "GROUP_ROSTER_UPDATE" then
        func:Update_Roster();
        func:Update_FellowshipBadge();
    end

    if event == "RAID_TARGET_UPDATE" then
        func:RaidTargetIndex();
    end

    if event == "QUEST_LOG_UPDATE" then
        func:Update_quests();
    end

    if event == "FRIENDLIST_UPDATE" then
        func:Update_FellowshipBadge();
    end
end

----------------------------------------
-- Registering events
----------------------------------------
local events = CreateFrame("Frame");

-- Player
events:RegisterEvent("ADDON_LOADED");
events:RegisterEvent("VARIABLES_LOADED");
events:RegisterEvent("NAME_PLATE_CREATED");
events:RegisterEvent("NAME_PLATE_UNIT_ADDED");
events:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
events:RegisterEvent("PLAYER_ENTERING_WORLD");
events:RegisterEvent("PLAYER_LOGOUT");
events:RegisterEvent("PLAYER_FLAGS_CHANGED");
events:RegisterEvent("PLAYER_TARGET_CHANGED");
events:RegisterEvent("PLAYER_REGEN_ENABLED");
events:RegisterEvent("PLAYER_REGEN_DISABLED");
events:RegisterEvent("PLAYER_GUILD_UPDATE");
events:RegisterEvent("PLAYER_DEAD");
events:RegisterEvent("PLAYER_ALIVE");
events:RegisterEvent("PLAYER_UNGHOST");
if data.isRetail then
    events:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
end
events:RegisterEvent("QUEST_LOG_UPDATE");
events:RegisterEvent("PLAYER_TOTEM_UPDATE");

-- Unit
events:RegisterEvent("UNIT_NAME_UPDATE");
events:RegisterEvent("UNIT_PORTRAIT_UPDATE");
events:RegisterEvent("UNIT_HEALTH");
events:RegisterEvent("UNIT_MAXHEALTH");
events:RegisterEvent("UNIT_HEAL_PREDICTION");
events:RegisterEvent("UNIT_POWER_FREQUENT");
events:RegisterEvent("UNIT_MAXPOWER");
events:RegisterEvent("UNIT_AURA");
events:RegisterEvent("UNIT_LEVEL");
events:RegisterEvent("UNIT_CLASSIFICATION_CHANGED");
events:RegisterEvent("UNIT_FACTION");
events:RegisterEvent("UNIT_COMBAT");
events:RegisterEvent("UNIT_THREAT_LIST_UPDATE");
events:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE");

-- Cast events
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

-- Nameplate's base
events:RegisterEvent("UI_SCALE_CHANGED");
events:RegisterEvent("DISPLAY_SIZE_CHANGED");

-- Rest
events:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
events:RegisterEvent("GROUP_ROSTER_UPDATE");
events:RegisterEvent("RAID_TARGET_UPDATE");
events:RegisterEvent("MODIFIER_STATE_CHANGED");
events:RegisterEvent("CVAR_UPDATE");
events:RegisterEvent("FRIENDLIST_UPDATE");

-- Scripts
events:SetScript("OnEvent", core.init);