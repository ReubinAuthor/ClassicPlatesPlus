----------------------------------------
-- NAMESPACES
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local frames = core.frames;

----------------------------------------
-- HANDLING EVENTS 
----------------------------------------
function core:init(event, ...)
    local arg = ...

    -- Tweaking CVars
    if event == "VARIABLES_LOADED" then
        SetCVar("nameplateSelectedScale", 1.15);
        SetCVar("nameplateTargetRadialPosition", 1);
        SetCVar("clampTargetNameplateToScreen", 1);
    end
    ----------------------------------------
    if event == "ADDON_LOADED" then
        if arg == myAddon then
            func:Load_Settings();
            --func:Hide_Blizzard();
        end
    end
    ----------------------------------------
    if event == "PLAYER_LOGOUT" then
        func:Save_Settings();

        --Restoring CVars on logout to avoid poluting CVars in case user decides to uninstall addon
        SetCVar("nameplateSelectedScale", 1);
        SetCVar("nameplateTargetRadialPosition", 0);
        SetCVar("clampTargetNameplateToScreen", 0);
    end
    ----------------------------------------
    --[[
    if event == "NAME_PLATE_CREATED" then
        func:Create_Nameplate(arg);
    end
    ]]
    ----------------------------------------
    if event == "NAME_PLATE_UNIT_ADDED" then
        func:Add_Nameplate(arg);
    end

    if event == "NAME_PLATE_UNIT_REMOVED" then
        func:Remove_Nameplate(arg);
    end
    ----------------------------------------
    if event == "UNIT_THREAT_LIST_UPDATE" then
        func:Update_Threat(arg);
    end
    ----------------------------------------
    if event == "UNIT_HEALTH_FREQUENT" then
        func:Update_Health(arg);
    end
    ----------------------------------------
    if event == "UNIT_AURA" then
        func:Update_Auras(arg);
    end
    ----------------------------------------
    if event == "PLAYER_REGEN_ENABLED" then
        frames.combat = false;
        for k, v in pairs(frames.threat) do
            if k then
                v:SetShown(func:Threat_Toggle());
            end
        end
    end
    ----------------------------------------
    if event == "PLAYER_REGEN_DISABLED" then
        frames.combat = true;
        for k, v in pairs(frames.threat) do
            if k and UnitExists(k) then
                v:SetShown(func:Threat_Toggle());
            end
        end
    end
    ----------------------------------------
    if event == "GROUP_ROSTER_UPDATE" then
        func:Roster_Update();
        for k, v in pairs(frames.threat) do
            if k then
                func:Update_Threat(k);
            end
        end

        for k, v in pairs(frames.health) do
            if k then
                func:Update_Health(k);
            end
        end
    end
    ----------------------------------------
    if event == "PLAYER_ENTERING_WORLD" then
        func:Roster_Update();
    end
end

----------------------------------------
-- REGISTERING SLASH COMMANDS
----------------------------------------
SLASH_RPLATES1 = "/rplates";

local function Slash_Handler(msg)
    if msg == "tank" then
        ReubinsNameplates_settings.Tank = ReubinsNameplates_settings.Tank or false;
        ReubinsNameplates_settings.Tank = not ReubinsNameplates_settings.Tank;

        -- Applying Threat visibility & Tank mode settings
        for k, v in pairs(frames.threat) do
            if k then
                if not ReubinsNameplates_settings.Tank then
                    v:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\aggro");
                else
                    v:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\tanking");
                end
                func:Update_Threat(k);
            end
        end

        if ReubinsNameplates_settings.Tank == true then
            print("|cff00ccffReubin's Nameplates: |cffFFFC54Tank mode activated");
        else
            print("|cff00ccffReubin's Nameplates: |cffFFFC54Tank mode deactivated");
        end
    end
end

SlashCmdList["RPLATES"] = Slash_Handler;

----------------------------------------
-- REGISTERING EVENTS
----------------------------------------
local events = CreateFrame("Frame");

events:RegisterEvent("VARIABLES_LOADED");
events:RegisterEvent("ADDON_LOADED");
events:RegisterEvent("PLAYER_LOGOUT");
events:RegisterEvent("NAME_PLATE_UNIT_ADDED");
events:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
events:RegisterEvent("UNIT_THREAT_LIST_UPDATE");
events:RegisterEvent("UNIT_HEALTH_FREQUENT");
events:RegisterEvent("UNIT_AURA");
events:RegisterEvent("PLAYER_REGEN_ENABLED");
events:RegisterEvent("PLAYER_REGEN_DISABLED");
events:RegisterEvent("GROUP_ROSTER_UPDATE");
events:RegisterEvent("PLAYER_ENTERING_WORLD");
--events:RegisterEvent("PLAYER_TARGET_CHANGED");
--events:RegisterEvent("NAME_PLATE_CREATED");

events:SetScript("OnEvent", core.init);