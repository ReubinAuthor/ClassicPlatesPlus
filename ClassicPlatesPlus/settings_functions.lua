----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

local addonName = "|cfff563ff[ClassicPlates Plus]: ";
-- Colors
local yellow = "|cff" .. "ffd100";
local white  = "|cff" .. "ffffff";
local green  = "|cff" .. "7CFC00";
local orange = "|cff" .. "FF5600";
local blue   = "|cff" .. "0072CA";
local purple = "|cff" .. "FF00FF";
local red    = "|cff" .. "FF5600";

----------------------------------------
-- Update
----------------------------------------
local function updateEverything()
    local nameplates = C_NamePlate.GetNamePlates();

    if nameplates then
        for k,v in pairs(nameplates) do
            if k and v.unitFrame.unit then
                func:Nameplate_Added(v.unitFrame.unit);
            end
        end
    end

    func:ResizeNameplates();
end

local function updateCVar()
    if not InCombatLockdown() then
        func:CVars("VARIABLES_LOADED");
    else
        if not data.tickers.CVar then
            data.tickers.CVar = C_Timer.NewTicker(1, function()
                if not InCombatLockdown() then
                    func:CVars("VARIABLES_LOADED");

                    data.tickers.CVar:Cancel();
                    data.tickers.CVar = nil;
                end
            end)
        end
    end
end

local function applyCVar(cvar, var)
    if not InCombatLockdown() then
        SetCVar(cvar, var);
    else
        if not data.tickers.CVar then
            data.tickers.CVar = C_Timer.NewTicker(1, function()
                if not InCombatLockdown() then
                    SetCVar(cvar, var);

                    data.tickers.CVar:Cancel();
                    data.tickers.CVar = nil;
                end
            end);
        end
    end
end

local function updateNameplateVisuals()
    local nameplates = C_NamePlate.GetNamePlates();

    if nameplates then
        for k,v in pairs(nameplates) do
            if k and v.unitFrame.unit then
                local unitFrame = v.unitFrame;

                if unitFrame.unit then
                    func:Nameplate_Added(unitFrame.unit, true);
                end
            end
        end
    end
end

local function updateAuras()
    local nameplates = C_NamePlate.GetNamePlates();

    if nameplates then
        for k,v in pairs(nameplates) do
            if k and v.unitFrame.unit then
                func:Update_Auras(v.unitFrame.unit);
            end
        end
    end

    func:Update_Auras("player");
end

local function updateAurasVisuals()
    local nameplates = C_NamePlate.GetNamePlates();
    local CFG = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile];

    local function work(unitFrame, filter)
        local scaleOffset = unitFrame.unit == "player" and 0.15 or 0.15;
        local scale = (CFG.AurasScale - scaleOffset) > 0 and (CFG.AurasScale - scaleOffset) or 0.1

        if unitFrame.auras and unitFrame.auras[filter] then
            for i = 1, 40 do
                if unitFrame.auras[filter][i] then
                    unitFrame.auras[filter][i]:SetScale(scale);
                    unitFrame.auras[filter][i].cooldown:SetReverse(CFG.AurasReverseAnimation);
                    unitFrame.auras[filter][i].countdown:SetShown(CFG.AurasCountdown);
                    unitFrame.auras[filter][i].countdown:ClearAllPoints();
                    if CFG.AurasCountdownPosition == 1 then
                        unitFrame.auras[filter][i].countdown:SetPoint("right", unitFrame.auras[filter][i].second, "topRight", 5, -2.5);
                        unitFrame.auras[filter][i].countdown:SetJustifyH("right");
                    elseif CFG.AurasCountdownPosition == 2 then
                        unitFrame.auras[filter][i].countdown:SetPoint("center", unitFrame.auras[filter][i].second, "center");
                        unitFrame.auras[filter][i].countdown:SetJustifyH("center");
                    end
                end
            end
        end

        unitFrame.buffsCounter:SetScale(CFG.AurasScale);
        unitFrame.debuffsCounter:SetScale(CFG.AurasScale);
    end

    if nameplates then
        for k,v in pairs(nameplates) do
            if k and v.unitFrame.unit then
                local unitFrame = v.unitFrame;

                work(unitFrame, "helpful");
                work(unitFrame, "harmful");
            end
        end
    end

    if data.nameplate then
        work(data.nameplate, "helpful");
        work(data.nameplate, "harmful");
    end
end

local function updateNameplateScale()
    local function work()
        local nameplates = C_NamePlate.GetNamePlates();

        SetCVar("nameplateGlobalScale", CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].NameplatesScale);

        for k,v in pairs(nameplates) do
            if k then
                v.unitFrame.name:SetIgnoreParentScale(false);
                v.unitFrame.guild:SetIgnoreParentScale(false);

                v.unitFrame.name:SetScale(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].LargeName and 0.95 or 0.75);
                v.unitFrame.guild:SetScale(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].LargeGuildName and 0.95 or 0.75);

                v.unitFrame.name:SetIgnoreParentScale(true);
                v.unitFrame.guild:SetIgnoreParentScale(true);
            end
        end
    end

    if not InCombatLockdown() then
        work();
    else
        if not data.tickers.nameplatesUpdate then
            data.tickers.nameplatesUpdate = C_Timer.NewTicker(1, function()
                if not InCombatLockdown() then
                    work();

                    data.tickers.nameplatesUpdate:Cancel();
                    data.tickers.nameplatesUpdate = nil;
                end
            end)
        end
    end
end

local function updateNameplateDistance()
    local function work()
        SetCVar("nameplateMaxDistance", CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].MaxNameplateDistance);
    end

    if not InCombatLockdown() then
        work();
    else
        if not data.tickers.MaxNameplateDistance then
            data.tickers.MaxNameplateDistance = C_Timer.NewTicker(1, function()
                if not InCombatLockdown() then
                    work();

                    data.tickers.MaxNameplateDistance:Cancel();
                    data.tickers.MaxNameplateDistance = nil;
                end
            end)
        end
    end
end

----------------------------------------
-- Storing functions defined by config names
----------------------------------------
local functionsTable = {
    PersonalNameplate = function() func:ToggleNameplatePersonal(); end,
    Portrait = function()
        updateNameplateVisuals();
        func:ResizeNameplates();
    end,
    ClassIconsFriendly = function() updateNameplateVisuals(); end,
    ClassIconsEnemy = function() updateNameplateVisuals(); end,
    ShowLevel = function()
        updateNameplateVisuals();
        func:ResizeNameplates();
    end,
    ShowGuildName = function()
        updateNameplateVisuals();
        func:ResizeNameplates();
    end,
    Classification = function() updateNameplateVisuals(); end,
    NameplatesScale = function()
        updateNameplateScale();
        func:ResizeNameplates();
    end,
    PersonalNameplatesScale = function() func:PersonalNameplateAdd(); end,
    Powerbar = function()
        updateNameplateVisuals();
        func:ResizeNameplates();
    end,
    HealthBarClassColorsFriendly = function() updateNameplateVisuals(); end,
    HealthBarClassColorsEnemy = function() updateNameplateVisuals(); end,
    NumericValue = function()
        updateNameplateVisuals();
        func:PersonalNameplateAdd();
    end,
    Percentage = function()
        updateNameplateVisuals();
        func:PersonalNameplateAdd();
    end,
    PercentageAsMainValue = function()
        updateNameplateVisuals();
        func:PersonalNameplateAdd();
    end,
    PersonalNameplateTotalHealth = function() func:PersonalNameplateAdd(); end,
    PersonalNameplateTotalPower = function() func:PersonalNameplateAdd(); end,
    LargeMainValue = function()
        updateNameplateVisuals();
        func:PersonalNameplateAdd();
    end,
    HealthFontColor = function()
        updateNameplateVisuals();
        func:PersonalNameplateAdd();
    end,
    ThreatPercentage = function()
        updateNameplateVisuals();
        func:ResizeNameplates();
    end,
    ThreatHighlight = function() updateNameplateVisuals(); end,

    -- Auras
    AurasFilterFriendly = function() updateAuras(); end,
    AurasFilterEnemy = function() updateAuras(); end,
    AurasHidePassive = function() updateAuras(); end,
    AurasCountdown = function() updateAurasVisuals(); end,
    AurasReverseAnimation = function() updateAurasVisuals(); end,
    MarkStealableAuras = function() updateAuras(); end,

    BuffsFriendly = function() updateAuras(); end,
    DebuffsFriendly = function() updateAuras(); end,

    BuffsEnemy = function() updateAuras(); end,
    DebuffsEnemy = function() updateAuras(); end,

    AurasMaxBuffsFriendly = function() updateAuras(); end,
    AurasMaxDebuffsFriendly = function() updateAuras(); end,
    AurasMaxBuffsEnemy = function() updateAuras(); end,
    AurasMaxDebuffsEnemy = function() updateAuras(); end,
    AurasScale = function() updateAurasVisuals(); end,
    AurasOverFlowCounter = function()
        local nameplates = C_NamePlate.GetNamePlates();
        if nameplates then
            for k,v in pairs(nameplates) do
                if k and v.unitFrame.unit then
                    v.unitFrame.buffsCounter:SetShown(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasOverFlowCounter);
                    v.unitFrame.debuffsCounter:SetShown(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasOverFlowCounter);
                end
            end
        end
    end,
    BuffsFilterPersonal = function() func:Update_Auras("player"); end,
    DebuffsFilterPersonal = function() func:Update_Auras("player"); end,

    BuffsPersonal = function() func:Update_Auras("player"); end,
    DebuffsPersonal = function() func:Update_Auras("player"); end,

    AurasPersonalMaxBuffs = function() func:Update_Auras("player"); end,
    AurasPersonalMaxDebuffs = function() func:Update_Auras("player"); end,
    AurasImportantList = function() updateAuras(); end,
    AurasBlacklist = function() updateAuras(); end,
    ThreatWarningColor = function() updateNameplateVisuals(); end,
    ThreatAggroColor = function() updateNameplateVisuals(); end,
    ThreatOtherTankColor = function() updateNameplateVisuals(); end,
    ShowHighlight = function() updateNameplateVisuals(); end,
    FadeUnselected = function() updateNameplateVisuals(); end,
    FadeIntensity = function() updateNameplateVisuals(); end,
    MaxNameplateDistance = function() updateNameplateDistance(); end,
    CastbarShow = function() updateNameplateVisuals(); end;
    CastbarScale = function() updateNameplateVisuals(); end,
    CastbarPositionY = function() updateNameplateVisuals(); end,
    ComboPointsScaleClassless = function() func:Update_ClassPower(); end,
    AurasCountdownPosition = function() updateAurasVisuals(); end,
    NameAndGuildOutline = function()
        updateNameplateVisuals();
    end,
    LargeName = function()
        updateNameplateScale();
        func:ResizeNameplates();
    end,
    LargeGuildName = function()
        updateNameplateScale();
        func:ResizeNameplates();
    end,
    NamesOnly = function() updateNameplateVisuals(); end,
    NamesOnlyExcludeNPCs = function() updateNameplateVisuals(); end,
    NamesOnlyExcludeFriends = function() updateNameplateVisuals(); end,
    NamesOnlyExcludeGuild = function() updateNameplateVisuals(); end,
    NamesOnlyExcludeParty = function() updateNameplateVisuals(); end,
    NamesOnlyExcludeRaid = function() updateNameplateVisuals(); end,
    EnlargeSelected = function() updateCVar() end;
    ScaleWithDistance = function() updateCVar() end;
    FellowshipBadge = function() updateNameplateVisuals(); end,
    FriendlyClassColorNamesAndGuild = function() updateNameplateVisuals(); end,
    EnemyClassColorNamesAndGuild = function() updateNameplateVisuals(); end,
    ShowFaction = function() updateNameplateVisuals(); end,
    QuestMark = function() updateNameplateVisuals(); end,
    PersonalNameplateAlwaysShow = function()
        if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplateAlwaysShow then
            applyCVar("NameplatePersonalShowAlways", 1);
        else
            applyCVar("NameplatePersonalShowAlways", 0);
        end
        func:PersonalNameplateAdd();
    end,
    SpecialPower = function() func:Update_ClassPower(); end,
    SpecialPowerScale = function() func:Update_ClassPower(); end,
    CastbarIconShow = function() updateNameplateVisuals(); end,
}

-- Execute function by passed config name
local function updateSettings(configName)
    if functionsTable[configName] then
        functionsTable[configName]();
    end
end

----------------------------------------
-- Hover scripts
----------------------------------------
local function SetHoverScript(target_frame, highlight_frame, name, tooltip, extra)
    target_frame:SetScript("OnEnter", function(self)
        highlight_frame:SetAlpha(0.1);

        if extra then
            extra:SetVertexColor(1, 0.82, 0);
        end

        if tooltip then
            GameTooltip:SetOwner(highlight_frame, "ANCHOR_TOPLEFT", 262, 0);
            GameTooltip:AddLine(name, 1, 1, 1, false);
            GameTooltip:AddLine(tooltip, nil, nil, nil, false);
            GameTooltip:Show();
        end
    end);
    target_frame:SetScript("OnLeave", function(self)
        highlight_frame:SetAlpha(0);

        if extra then
            extra:SetVertexColor(0.55, 0.55, 0.55);
        end

        if tooltip then
            GameTooltip:Hide();
        end
    end);
end

----------------------------------------
-- Trimming names
----------------------------------------
local function TrimName(nameFrame)
    local maxNameWidth = 180;

    if nameFrame:GetStringWidth() > maxNameWidth then
        local name = nameFrame:GetText();
        local nameLength = strlenutf8(name);
        local trimmedLength = math.floor(maxNameWidth / nameFrame:GetStringWidth() * nameLength);

        name = func:utf8sub(name, 1, trimmedLength);

        nameFrame:SetText(name .. "...");
    end
end

----------------------------------------
-- Generating profile IDs
----------------------------------------
function func:GenerateID()
    local id = string.gsub('xxxxxxxx', '[x]', function()
        return string.format('%x', math.random(0, 0xf));
    end);

    if not CFG_Account_ClassicPlatesPlus.Profiles[id] then
        return id;
    else
        return func:GenerateID();
    end
end

----------------------------------------
-- Checking profile name availability
----------------------------------------
function func:ProfileNameAvailable(input)
    if not input or input == "" then
        return false;
    end

    for k,v in pairs(CFG_Account_ClassicPlatesPlus.Profiles) do
        if k and v.displayName == input then
            return false;
        end
    end

    return true;
end

----------------------------------------
-- Reseting Settings
----------------------------------------
function func:ResetSettings(cfg, value, profileID)
    local frame = _G[value.frame];
    local default = value.default;
    local type = value.type;

    profileID = profileID or CFG_ClassicPlatesPlus.Profile;

    if value.type == "ColorPicker" then
        CFG_Account_ClassicPlatesPlus.Profiles[profileID][cfg] = CFG_Account_ClassicPlatesPlus.Profiles[profileID][cfg] or {};

        CFG_Account_ClassicPlatesPlus.Profiles[profileID][cfg].r = default.r;
        CFG_Account_ClassicPlatesPlus.Profiles[profileID][cfg].g = default.g;
        CFG_Account_ClassicPlatesPlus.Profiles[profileID][cfg].b = default.b;
        CFG_Account_ClassicPlatesPlus.Profiles[profileID][cfg].a = default.a;

        frame:SetVertexColor(
            default.r,
            default.g,
            default.b,
            default.a
        );
    elseif type == "CheckButton" then
        CFG_Account_ClassicPlatesPlus.Profiles[profileID][cfg] = default;

        frame:SetChecked(default);
    elseif type == "Slider" then
        CFG_Account_ClassicPlatesPlus.Profiles[profileID][cfg] = default;

        frame:SetValue(default);
    elseif type == "DropDownMenu" then
        CFG_Account_ClassicPlatesPlus.Profiles[profileID][cfg] = default;

        frame:SetValue(default);
    end
end

----------------------------------------
-- Anchoring Frames
----------------------------------------
function func:AnchorFrames(panel)
    local list  = panel.list;

    for k,v in ipairs(list) do
        if k then
            if k == 1 then
                v:SetPoint("topLeft");
            else
                list[k]:SetPoint("topLeft", list[k - 1], "bottomLeft");
            end
        end
    end
end

----------------------------------------
-- Creating Panel
----------------------------------------
function func:CreatePanel(mainPanelName, name)
    local panel = CreateFrame("frame");
    local nameDivider = "  |  ";

    panel.name = name;
    if mainPanelName then
        panel.parent = mainPanelName;
    else
        nameDivider = "";
        name = "";
    end

    -- Header
    panel.header = CreateFrame("frame", nil, panel);
    panel.header:SetPoint("topLeft");
    panel.header:SetPoint("topRight");
    panel.header:SetHeight(50);

    -- Addon icon
    panel.icon = panel.header:CreateTexture();
    panel.icon:SetPoint("left", 8, -6);
    panel.icon:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\icons\\ClassicPlatesPlus_icon");
    panel.icon:SetSize(20, 20);

    -- Title
    panel.title = panel:CreateFontString(nil, "overlay", "GameFontHighlightHuge");
    panel.title:SetPoint("bottomLeft", panel.icon, "bottomRight", 8, 0);
    panel.title:SetJustifyH("left");
    panel.title:SetText("ClassicPlates Plus" .. nameDivider .. name);

    -- Button: Reset all settings
    panel.resetSettings = CreateFrame("Button", nil, panel.header, "GameMenuButtonTemplate");
    panel.resetSettings:SetPoint("right", -36, -2);
    panel.resetSettings:SetSize(96, 22);
    panel.resetSettings:SetText("Defaults");
    panel.resetSettings:SetNormalFontObject("GameFontNormal");
    panel.resetSettings:SetHighlightFontObject("GameFontHighlight");

    -- Static PopUp
    panel.resetSettings:SetScript("OnClick", function()
        StaticPopup_Show(myAddon .. "_" .. panel.name .. "_" .. "defaults");
    end);

    StaticPopupDialogs[myAddon .. "_" .. panel.name .. "_" .. "defaults"] = {
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        text = "Do you want to reset ClassicPlates Plus settings?",
        button1 = "All Settings",
        button2 = "Cancel",
        button3 = "These Settings",

        -- Reset All Settings
        OnAccept = function()
            for k,v in pairs(data.settings.configs.all) do
                if k then
                    func:ResetSettings(k,v);
                end
            end
        end,

        -- Reset Current Panel Settings
        OnAlt = function()
            for k,v in pairs(data.settings.configs.panels[panel.name]) do
                if k then
                    func:ResetSettings(k,v);
                end
            end
        end
    };

    -- Line Divider
    panel.divider = panel.header:CreateTexture();
    panel.divider:SetPoint("bottomLeft", 16, -1);
    panel.divider:SetPoint("bottomRight", -40, -1);
    panel.divider:SetHeight(1);
    panel.divider:SetAtlas("Options_HorizontalDivider");

    -- Scroll Frame
    panel.scrollFrame = CreateFrame("ScrollFrame", nil, panel, "ScrollFrameTemplate");
    panel.scrollFrame:SetPoint("topLeft", 16, -52);
    panel.scrollFrame:SetPoint("bottomRight", -26, 0);

    -- Scroll Child
    panel.scrollChild = CreateFrame("frame", nil, panel.scrollFrame);
    panel.scrollChild:SetPoint("topLeft");
    panel.scrollChild:SetSize(1,1);

    -- Parent Scroll Child
    panel.scrollFrame:SetScrollChild(panel.scrollChild);

    -- Categories table
    panel.list = {};

    -- Configs table
    data.settings.configs.panels[panel.name] = {};

    -- Adding panel to the list of panels to initialize
    table.insert(data.settings.panels, panel);

    return panel;
end

----------------------------------------
-- Creating Category
----------------------------------------
function func:Create_SubCategory(panel, name)
    local frameName = myAddon .. "_" .. panel.name .. "_Category_" .. name;

    -- Creating parent
    local parent = CreateFrame("frame", frameName, panel.scrollChild);
    parent:SetSize(620, 64);

    local frame_text = parent:CreateFontString(nil, "overlay", "GameFontHighlightLarge");
    frame_text:SetPoint("left");
    frame_text:SetJustifyH("left");
    frame_text:SetText(name);

    frame_text.isTitle = true;
    frame_text.settingsList = {};

    table.insert(panel.list, parent);
end

----------------------------------------
-- Create CheckButton
----------------------------------------
function func:Create_CheckButton(panel, flair, name, tooltip, cfg, default)
    local frameName = myAddon .. "_" .. panel.name .. "_CheckButton_" .. name;

    if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg] == nil then
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg] = default;
    end

    -- Creating parent
    local parent = CreateFrame("frame", nil, panel.scrollChild);
    parent:SetSize(620, 36);

    -- Highlight
    local highlight = parent:CreateTexture(nil, "artwork");
    highlight:SetAllPoints();
    highlight:SetColorTexture(1,1,1);
    highlight:SetAlpha(0);

    -- Creating title
    local frame_title = parent:CreateFontString(nil, "overlay", "GameFontNormal");
    frame_title:SetPoint("left", 32, 0);
    frame_title:SetJustifyH("left");
    frame_title:SetText(name);
    TrimName(frame_title);

    local frame_button = CreateFrame("CheckButton", frameName, parent, "InterfaceOptionsCheckButtonTemplate");
    frame_button:SetPoint("left", parent, "left", 194, 0);
    frame_button:SetScale(1.2);
    frame_button:SetChecked(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg]);

    SetHoverScript(parent, highlight, name, tooltip);
    SetHoverScript(frame_button, highlight, name, tooltip);

    -- Update
    frame_button:SetScript("OnClick", function(self)
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg] = self:GetChecked();
        updateSettings(cfg);
    end);

    -- CFG_ClassicPlatesPlus table
    local config = {type = "CheckButton", frame = frameName, default = default};

    -- Adding config to a complete list of configs
    data.settings.configs.all[cfg] = config;

    -- Adding config to current category configs list
    data.settings.configs.panels[panel.name][cfg] = config;

    -- Adding frame to the settings list
    if data.isClassic and flair.classicEra
    or data.isCata   and flair.cata
    or data.isRetail  and flair.retail
    then
        table.insert(panel.list, parent);
    end
end

----------------------------------------
-- Create DropDown Menu
----------------------------------------
function func:Create_DropDownMenu(panel, flair, name, tooltip, cfg, default, options)
    local frameName = myAddon .. "_" .. panel.name .. "_DropDownMenu_" .. name;

    -- Adding CFG_ClassicPlatesPlus
    if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg] == nil then
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg] = default;
    end

    local selection = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg];

    -- Creating parent
    local parent = CreateFrame("frame", nil, panel.scrollChild);
    parent:SetSize(620, 36);

    -- Highlight
    local highlight = parent:CreateTexture(nil, "background");
    highlight:SetAllPoints();
    highlight:SetColorTexture(1,1,1);
    highlight:SetAlpha(0);

    -- Creating title
    local frame_title = parent:CreateFontString(nil, "overlay", "GameFontNormal");
    frame_title:SetPoint("left", 32, 0);
    frame_title:SetJustifyH("left");
    frame_title:SetText(name);
    TrimName(frame_title);

    -- Creating menu
    local frame_menu = CreateFrame("frame", frameName, parent, "UIDropDownMenuTemplate");
    frame_menu:SetPoint("left", parent, "left", 220, -2);

    function frame_menu:GetVarName(var)
        for k,v in ipairs(options) do
            if k and k == var then
                return v;
            end
        end
    end

    UIDropDownMenu_SetWidth(frame_menu, 210);
    UIDropDownMenu_SetText(frame_menu, frame_menu:GetVarName(selection));

    UIDropDownMenu_Initialize(frame_menu, function(self)
        local info = UIDropDownMenu_CreateInfo();

        info.func = self.SetValue;

        for k,v in ipairs(options) do
            if k then
                info.text, info.arg1, info.checked = v, k, k == selection;
                UIDropDownMenu_AddButton(info);
            end
        end
    end);

    function frame_menu:SetValue(newValue)
        -- Update selection
        selection = newValue;

        -- Set new value
        UIDropDownMenu_SetText(frame_menu, frame_menu:GetVarName(selection));

        -- Close menu
        CloseDropDownMenus();

        -- Update config
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg] = selection;

        -- Update
        updateSettings(cfg);
    end

    SetHoverScript(parent, highlight, name, tooltip);
    SetHoverScript(frame_menu, highlight, name, tooltip);

    -- CFG_ClassicPlatesPlus table
    local config = {type = "DropDownMenu", frame = frameName, default = default};

    -- Adding config to a complete list of configs
    data.settings.configs.all[cfg] = config;

    -- Adding config to current category configs list
    data.settings.configs.panels[panel.name][cfg] = config;

    -- Adding frame to the settings list
    if data.isClassic and flair.classicEra
    or data.isCata   and flair.cata
    or data.isRetail  and flair.retail
    then
        table.insert(panel.list, parent);
    end
end

----------------------------------------
-- Create Slider
----------------------------------------
function func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals)
    local frameName = myAddon .. "_" .. panel.name .. "_Slider_" .. name;
    local format = "%." .. decimals .. "f";

    -- Adding CFG_ClassicPlatesPlus
    if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg] == nil then
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg] = default;
    end

    -- Creating parent
    local parent = CreateFrame("frame", nil, panel.scrollChild);
    parent:SetSize(620, 36);

    -- Highlight
    local highlight = parent:CreateTexture(nil, "background");
    highlight:SetAllPoints();
    highlight:SetColorTexture(1,1,1);
    highlight:SetAlpha(0);

    -- Creating title
    local frame_title = parent:CreateFontString(nil, "overlay", "GameFontNormal");
    frame_title:SetPoint("left", 32, 0);
    frame_title:SetJustifyH("left");
    frame_title:SetText(name);
    TrimName(frame_title);

    local frame_slider = CreateFrame("slider", frameName, parent, "OptionsSliderTemplate");
    frame_slider:SetPoint("left", frame_title, "left", 205, 0);
    frame_slider:SetOrientation("horizontal");
    frame_slider:SetSize(228, 18);
    frame_slider:SetMinMaxValues(minValue, maxValue);
    frame_slider:SetValueStep(step);
    frame_slider:SetObeyStepOnDrag(true);
    frame_slider:SetValue(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg]);

    _G[frame_slider:GetName() .. "Low"]:SetText("");
    _G[frame_slider:GetName() .. "High"]:SetText("");

    local frame_Value = panel.scrollChild:CreateFontString(nil, "overlay", "GameFontNormal");
    frame_Value:SetPoint("left", frame_slider, "right", 8, 0);
    frame_Value:SetJustifyH("left");
    frame_Value:SetText(string.format(format, frame_slider:GetValue()));

    frame_slider:SetScript("OnValueChanged", function(self)
        frame_Value:SetText(string.format(format, self:GetValue()));
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg] = self:GetValue();

        -- Update
        updateSettings(cfg);
    end);

    SetHoverScript(parent, highlight, name, tooltip);
    SetHoverScript(frame_slider, highlight, name, tooltip);

    -- CFG_ClassicPlatesPlus table
    local config = {type = "Slider", frame = frameName, default = default};

    -- Adding config to a complete list of configs
    data.settings.configs.all[cfg] = config;

    -- Adding config to current category configs list
    data.settings.configs.panels[panel.name][cfg] = config;

    -- Adding frame to the settings list
    if data.isClassic and flair.classicEra
    or data.isCata   and flair.cata
    or data.isRetail  and flair.retail
    then
        table.insert(panel.list, parent);
    end
end

----------------------------------------
-- Create Color Picker
----------------------------------------
function func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default)
    local frameName = myAddon .. "_" .. panel.name .. "_ColorPicker_" .. name;

    -- Adding CFG_ClassicPlatesPlus
    if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg] == nil then
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg] = default;
    end

    -- Creating parent
    local parent = CreateFrame("frame", nil, panel.scrollChild);
    parent:SetSize(620, 36);

    -- Highlight
    local highlight = parent:CreateTexture(nil, "background");
    highlight:SetAllPoints();
    highlight:SetColorTexture(1,1,1);
    highlight:SetAlpha(0);

    -- Creating title
    local frame_title = parent:CreateFontString(nil, "overlay", "GameFontNormal");
    frame_title:SetPoint("left", 32, 0);
    frame_title:SetJustifyH("left");
    frame_title:SetText(name);
    TrimName(frame_title);

    -- Button
    local frame_button = CreateFrame("button", nil, parent);
    frame_button:SetPoint("left", frame_title, "left", 204, 0);
    frame_button:SetSize(24, 24);

    -- texture
    local frame_texture = frame_button:CreateTexture(frameName, "artwork", nil, 1);
    frame_texture:SetAllPoints();
    frame_texture:SetSize(30, 30);
    frame_texture:SetColorTexture(1, 1, 1);
    frame_texture:SetVertexColor(
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].r,
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].g,
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].b,
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].a
    );

    -- Mask
    local frame_mask = frame_button:CreateMaskTexture();
    frame_mask:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\masks\\colorPicker", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE");
    frame_texture:AddMaskTexture(frame_mask);

    -- Border
    local frame_border = frame_button:CreateTexture(nil, "artwork", nil, 2);
    frame_border:SetPoint("center", frame_texture, "center");
    frame_border:SetSize(30, 30);
    frame_border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\borders\\colorPicker");
    frame_border:SetVertexColor(0.55, 0.55, 0.55);
    frame_mask:SetAllPoints(frame_border);

    -- Refresh
    local function refresh()
        frame_texture:SetVertexColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].a
        );

        updateSettings(cfg);
    end

    -- Click
    frame_button:SetScript("OnClick", function(self)
        -- Prepping color picker info
        local info = {};
        local r,g,b,a = frame_texture:GetVertexColor();
        local prevColors = { r = r, g = g, b = b, a = a };

        info.r       = r or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].r;
        info.g       = g or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].g;
        info.b       = b or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].b;
        info.opacity = a or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].a;
        info.hasOpacity = false;

        info.swatchFunc = function()
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].r, CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].g, CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].b = ColorPickerFrame:GetColorRGB();
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].a = ColorPickerFrame:GetColorAlpha();

            refresh();
        end

        info.cancelFunc = function()
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].r = prevColors.r;
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].g = prevColors.g;
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].b = prevColors.b;
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].a = prevColors.a;

            refresh();
        end

        ColorPickerFrame:SetupColorPickerAndShow(info);
    end);

    -- Reset button
    local frame_reset = CreateFrame("button", nil, parent, "GameMenuButtonTemplate");
    frame_reset:SetPoint("left", frame_texture, "right", 16, 0);
    frame_reset:SetSize(96, 22);
    frame_reset:SetText("Reset");
    frame_reset:SetNormalFontObject("GameFontNormal");
    frame_reset:SetHighlightFontObject("GameFontHighlight");
    frame_reset:SetScript("Onclick", function()
        -- Update
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].r = default.r;
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].g = default.g;
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].b = default.b;
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].a = default.a;

        frame_texture:SetVertexColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg].a
        );
        updateSettings(cfg);
    end);

    SetHoverScript(parent, highlight, name, tooltip);
    SetHoverScript(frame_button, highlight, name, tooltip, frame_border);
    SetHoverScript(frame_reset, highlight, name, tooltip);

    -- CFG_ClassicPlatesPlus table
    local config = {type = "ColorPicker", frame = frameName, default = default};

    -- Adding config to a complete list of configs
    data.settings.configs.all[cfg] = config;

    -- Adding config to current category configs list
    data.settings.configs.panels[panel.name][cfg] = config;

    -- Adding frame to the settings list
    if data.isClassic and flair.classicEra
    or data.isCata   and flair.cata
    or data.isRetail  and flair.retail
    then
        table.insert(panel.list, parent);
    end
end

----------------------------------------
-- Creating Spacer
----------------------------------------
function func:Create_Spacer(panel)
    -- Creating parent
    local parent = CreateFrame("frame", nil, panel.scrollChild);
    parent:SetSize(620, 24);

    -- Adding frame to the settings list
    table.insert(panel.list, parent);
end

----------------------------------------
-- Auras list
----------------------------------------
function func:Create_AurasList(panel, name, cfg)
    if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg] == nil then
        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg] = {};
    end

    panel.scrollChild.auras = panel.scrollChild.auras or {};

    -- PopUp box
    local backdrop = {
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileEdge = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    }

    local frame_PopUp = CreateFrame("Frame", myAddon .. "PopUp", panel, "BackdropTemplate");
    frame_PopUp:SetPoint("topLeft", 60, -60);
    frame_PopUp:SetPoint("bottomRight", -60, 60);
    frame_PopUp:SetFrameLevel(panel.scrollChild:GetFrameLevel() + 5);
    frame_PopUp:EnableMouse(true);
    frame_PopUp:SetBackdrop(backdrop);
    frame_PopUp:SetBackdropColor(0.1, 0.1, 0.1, 1);
    frame_PopUp:SetBackdropBorderColor(0.62, 0.62, 0.62);
    frame_PopUp:Hide();

    -- Title
    frame_PopUp.title = frame_PopUp:CreateFontString(nil, "overlay", "GameFontNormalLarge");
    frame_PopUp.title:SetPoint("topLeft", frame_PopUp, "topLeft", 16, -16);
    frame_PopUp.title:SetText("Title goes here");

    -- Background
    frame_PopUp.background = CreateFrame("button", nil, frame_PopUp);
    frame_PopUp.background:SetPoint("topLeft", panel, "topLeft", -14, 8);
        frame_PopUp.background:SetSize(680, 610);
    frame_PopUp.background:SetFrameLevel(frame_PopUp:GetFrameLevel() - 1);
    frame_PopUp.background:EnableMouse(true);
    frame_PopUp.background:EnableMouseWheel(true);
    frame_PopUp.background.color = frame_PopUp.background:CreateTexture();
    frame_PopUp.background.color:SetAllPoints();
    frame_PopUp.background.color:SetColorTexture(0.05, 0.05, 0.05, 0.8);
    frame_PopUp.background:SetScript("OnMouseWheel", function() end);
    frame_PopUp.background:SetScript("OnClick", function()
        frame_PopUp:Hide();
        frame_PopUp.input:SetText("");
    end);

    -- Note
    frame_PopUp.note = frame_PopUp:CreateFontString(nil, "overlay", "GameFontHighlightSmall");
    frame_PopUp.note:SetPoint("topLeft", frame_PopUp.title, "bottomLeft", 0, -4);
    frame_PopUp.note:SetText("Lorem ipsum dolor sit amet...");
    frame_PopUp.note:SetAlpha(0.66);

    frame_PopUp.InputBox = CreateFrame("Frame", nil, frame_PopUp, "BackdropTemplate");
    frame_PopUp.InputBox:SetPoint("topLeft", 16, -50);
    frame_PopUp.InputBox:SetPoint("bottomRight", -16, 46);
    frame_PopUp.InputBox:SetBackdrop(backdrop);
    frame_PopUp.InputBox:SetBackdropColor(0, 0, 0, 0.5);
    frame_PopUp.InputBox:SetBackdropBorderColor(0.62, 0.62, 0.62);

    frame_PopUp.ScrollFrame = CreateFrame("ScrollFrame", myAddon .. "_" .. name .. "_PopUpScroll", frame_PopUp.InputBox, "ScrollFrameTemplate");
    frame_PopUp.ScrollFrame:SetPoint("topLeft", 8, -10);
    frame_PopUp.ScrollFrame:SetPoint("bottomRight", -28, 6);

    frame_PopUp.inputButton = CreateFrame("Button", nil, frame_PopUp.ScrollFrame);
    frame_PopUp.inputButton:SetPoint("topLeft");
    frame_PopUp.inputButton:SetPoint("bottomRight");

    frame_PopUp.input = CreateFrame("EditBox", nil, frame_PopUp.ScrollFrame);
    frame_PopUp.ScrollFrame:SetScrollChild(frame_PopUp.input);
    frame_PopUp.input:SetWidth(474);
    frame_PopUp.input:SetFontObject("GameFontHighlight");
    frame_PopUp.input:SetMultiLine(true);
    frame_PopUp.input:SetMovable(false);
    frame_PopUp.input:SetAutoFocus(true);
    frame_PopUp.input:SetMaxLetters(0);

    frame_PopUp.inputButton:SetFrameLevel(frame_PopUp.input:GetFrameLevel() - 1)

    -- Error message
    frame_PopUp.ErrorMsg = frame_PopUp:CreateFontString(nil, "overlay", "GameFontHighlight");
    frame_PopUp.ErrorMsg:SetPoint("bottomLeft", frame_PopUp, "bottomLeft", 20, 21);
    frame_PopUp.ErrorMsg:SetTextColor(1, 0, 0);
    frame_PopUp.ErrorMsg:Hide();

    -- Button Close
    frame_PopUp.ButtonClose = CreateFrame("Button", nil, frame_PopUp, "GameMenuButtonTemplate");
    frame_PopUp.ButtonClose:SetPoint("topRight", frame_PopUp.InputBox, "bottomright", 0, -8);
    frame_PopUp.ButtonClose:SetSize(100, 22);
    frame_PopUp.ButtonClose:SetText("Close");
    frame_PopUp.ButtonClose:SetNormalFontObject("GameFontNormal");
    frame_PopUp.ButtonClose:SetHighlightFontObject("GameFontHighlight");

    frame_PopUp.ButtonClose:SetScript("OnClick", function()
        frame_PopUp:Hide();
        frame_PopUp.input:SetText("");
    end);


    -- Button
    frame_PopUp.Button = CreateFrame("Button", nil, frame_PopUp, "GameMenuButtonTemplate");
    frame_PopUp.Button:SetPoint("right", frame_PopUp.ButtonClose, "left");
    frame_PopUp.Button:SetSize(100, 22);
    frame_PopUp.Button:SetText("Button");
    frame_PopUp.Button:SetNormalFontObject("GameFontNormal");
    frame_PopUp.Button:SetHighlightFontObject("GameFontHighlight");
    frame_PopUp.Button:Hide();

    local function addSpell(list, input)
        local spellName = C_Spell.GetSpellName(input);

        if input ~= "" then
            if spellName then
                if not list[input] then
                    list[input] = 1;
                    return true,  '|cfff563ff[ClassicPlates Plus]: |cff00eb00'..'added: '..spellName;
                elseif list[input] then
                    return false, '|cfff563ff[ClassicPlates Plus]: |cffe3eb00"'..spellName..' is already listed';
                end
            else
                return false, '|cfff563ff[ClassicPlates Plus]: |cffff0000"'..input..'" not found';
            end
        end
    end

    local function updateAurasList()
        local sorted = {};
        local sorter = {};

        local function pairsByKeys(t)
            local a = {};

            for n in pairs(t) do
                table.insert(a, n);
            end

            table.sort(a);

            local i = 0;
            local function iter()
                i = i + 1;

                if a[i] == nil then
                    return nil;
                else
                    return a[i], t[a[i]];
                end
            end

            return iter;
        end

        data.settings[cfg] = {};
        for k in pairs(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg]) do
            if k then
                local spellInfo = C_Spell.GetSpellInfo(k);

                if spellInfo then
                    sorter[spellInfo.name] = { icon = spellInfo.iconID, id = k };
                    data.settings[cfg][spellInfo.name] = 1;
                end
            end
        end

        for k,v in pairsByKeys(sorter) do
            if pairsByKeys then
                local aura = { name = k, icon = v.icon, id = v.id };
                table.insert(sorted, aura);
            end
        end

        local function anchor(index)
            if index == 1 then
                return "topLeft", 280, -24;
            else
                return "topLeft", panel.scrollChild.auras[index - 1], "bottomLeft", 0, -2;
            end
        end

        local alphaEnter = 0.33;
        local alphaLeave = 0.075;

        for k,v in ipairs(sorted) do
            if k then
                if not panel.scrollChild.auras[k] then
                    panel.scrollChild.auras[k] = CreateFrame("frame", nil, panel.scrollChild);
                    panel.scrollChild.auras[k]:SetPoint(anchor(k));
                    panel.scrollChild.auras[k]:SetSize(320, 30);
                    panel.scrollChild.auras[k].icon = panel.scrollChild:CreateTexture();
                    panel.scrollChild.auras[k].icon:SetParent(panel.scrollChild.auras[k]);
                    panel.scrollChild.auras[k].icon:SetPoint("left", 6, 0);
                    panel.scrollChild.auras[k].icon:SetTexture(v.icon);
                    panel.scrollChild.auras[k].icon:SetSize(24, 24);

                    panel.scrollChild.auras[k].name = panel.scrollChild:CreateFontString(nil, "overlay", "GameFontNormal");
                    panel.scrollChild.auras[k].name:SetParent(panel.scrollChild.auras[k]);
                    panel.scrollChild.auras[k].name:SetPoint("left", 40, 0);
                    panel.scrollChild.auras[k].name:SetWidth(233);
                    panel.scrollChild.auras[k].name:SetJustifyH("left");
                    panel.scrollChild.auras[k].name:SetText(v.name);

                    panel.scrollChild.auras[k].remove = CreateFrame("button", nil, panel.scrollChild.auras[k]);
                    panel.scrollChild.auras[k].remove:SetSize(18, 18);
                    panel.scrollChild.auras[k].remove:SetPoint("right");
                    panel.scrollChild.auras[k].remove:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
                    panel.scrollChild.auras[k].remove:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down");
                    panel.scrollChild.auras[k].remove:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight");

                    panel.scrollChild.auras[k].background = panel.scrollChild:CreateTexture();
                    panel.scrollChild.auras[k].background:SetParent(panel.scrollChild.auras[k]);
                    panel.scrollChild.auras[k].background:SetAllPoints();
                    panel.scrollChild.auras[k].background:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\aurasList");
                    panel.scrollChild.auras[k].background:SetVertexColor(1, 0.82, 0);
                    panel.scrollChild.auras[k].background:SetAlpha(alphaLeave);
                    panel.scrollChild.auras[k].background:SetDrawLayer("background", 1);
                else
                    panel.scrollChild.auras[k].icon:SetTexture(v.icon);
                    panel.scrollChild.auras[k].name:SetText(v.name);
                    panel.scrollChild.auras[k]:Show();
                end

                -- Highlight
                panel.scrollChild.auras[k]:SetScript("OnEnter", function(self)
                    self.background:SetAlpha(alphaEnter);
                    self.name:SetFontObject("GameFontHighlight");
                end);
                panel.scrollChild.auras[k]:SetScript("OnLeave", function(self)
                    self.background:SetAlpha(alphaLeave);
                    self.name:SetFontObject("GameFontNormal");
                end);
                panel.scrollChild.auras[k].remove:SetScript("OnEnter", function()
                    panel.scrollChild.auras[k].background:SetAlpha(alphaEnter);
                    panel.scrollChild.auras[k].name:SetFontObject("GameFontHighlight");
                end);
                panel.scrollChild.auras[k].remove:SetScript("OnLeave", function()
                    panel.scrollChild.auras[k].background:SetAlpha(alphaLeave);
                    panel.scrollChild.auras[k].name:SetFontObject("GameFontNormal");
                end);

                -- Remove button
                panel.scrollChild.auras[k].remove:SetScript("OnClick", function()
                    CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg][v.id] = nil;

                    -- Hiding all auras, list update will re-enable esixting one
                    for _, v in pairs(panel.scrollChild.auras) do
                        v:Hide();
                    end

                    updateAurasList();

                    -- Update
                    updateSettings(cfg);
                end);
            end
        end

        if #sorted == 0 then
            if not panel.note then
                panel.note = panel.scrollChild:CreateFontString(nil, "overlay", "GameFontHighlight");
                panel.note:SetPoint("left", 345, -68);
                panel.note:SetWidth(200);
                panel.note:SetJustifyH("center");
                panel.note:SetSpacing(2);
                panel.note:SetAlpha(0.5);
            else
                panel.note:SetParent(panel);
                panel.note:SetPoint("center", 0, 10);
            end

            panel.note:SetText("List of auras will appear here");
            panel.note:Show();
        else
            if panel.note then
                panel.note:Hide();
            end
        end
    end

    -- Creating parent
    local parent = CreateFrame("frame", nil, panel.scrollChild);

    -- EditBox
    local frame_EditBox = CreateFrame("editBox", nil, parent, "InputBoxTemplate");
    frame_EditBox:SetSize(160, 18);
    frame_EditBox:SetMultiLine(false);
    frame_EditBox:SetMovable(false);
    frame_EditBox:SetAutoFocus(false);
    frame_EditBox:SetFontObject("GameFontHighlight");
    frame_EditBox:SetMaxLetters(9);
    frame_EditBox:SetNumeric(true);
    frame_EditBox.title = panel:CreateFontString(nil, "overlay", "GameFontNormal");
    frame_EditBox.title:SetText("Add Aura");
    frame_EditBox:SetPoint("topLeft", frame_EditBox.title, "bottomLeft", 4, -8);
    frame_EditBox.placeholder = frame_EditBox:CreateFontString(nil, "overlay", "GameFontDisableLeft");
    frame_EditBox.placeholder:SetPoint("left", frame_EditBox, "left", 2, 0);
    frame_EditBox.placeholder:SetText("Enter spell ID (number)");
    frame_EditBox.addButton = CreateFrame("Button", nil, frame_EditBox, "GameMenuButtonTemplate");
    frame_EditBox.addButton:SetPoint("left", frame_EditBox, "right", 8, 0);
    frame_EditBox.addButton:SetSize(74, 22);
    frame_EditBox.addButton:SetText("Add");
    frame_EditBox.addButton:SetNormalFontObject("GameFontNormal");
    frame_EditBox.addButton:SetHighlightFontObject("GameFontHighlight");
    frame_EditBox.title:SetPoint("topLeft", 16, -74);

    frame_EditBox:SetScript("OnEditFocusLost", function(self)
        if #self:GetText() == 0 then
            self.placeholder:Show();
        end
    end);

    frame_EditBox:SetScript("OnEditFocusGained", function(self)
        self.placeholder:Hide();
    end);

    frame_EditBox:SetScript("OnHide", function(self)
        self:SetText("");
        self.placeholder:Show();
    end);

    frame_EditBox:SetScript("OnEnterPressed", function(self)
        local added, status = addSpell(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg], self:GetText());

        if added then
            self:SetText("");
            self:ClearFocus();
            updateAurasList();

            -- Update
            updateSettings(cfg);

            if status then
                print(status);
            end
        else
            if status then
                print(status);
            end
        end
    end);

    -- EditBox, button pressed
    frame_EditBox.addButton:SetScript("OnClick", function()
        local added, status = addSpell(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg], frame_EditBox:GetText());

        if added then
            frame_EditBox:SetText("");
            frame_EditBox:ClearFocus();
            updateAurasList();

            -- Update
            updateSettings(cfg);

            if status then
                print(status);
            end
        else
            if status then
                print(status);
            end
        end
    end);

    -- Import Button
    local frame_ImportButton = CreateFrame("Button", nil, panel, "GameMenuButtonTemplate");
    frame_ImportButton:SetPoint("topLeft", frame_EditBox, "bottomLeft", -6, -32);
    frame_ImportButton:SetSize(120, 22);
    frame_ImportButton:SetText("Import Auras");
    frame_ImportButton:SetNormalFontObject("GameFontNormal");
    frame_ImportButton:SetHighlightFontObject("GameFontHighlight");

    frame_ImportButton:SetScript("OnClick", function()
        frame_PopUp.title:SetText("Import " .. name);
        frame_PopUp.note:SetText("Spell IDs separated by commas");
        frame_PopUp.input:SetText("");
        frame_PopUp.Button:SetText("Import");
        frame_PopUp.Button:Show();
        frame_PopUp.Button:SetScript("OnClick", function()
            local import = frame_PopUp.input:GetText();
            local t = {};
            local hash = {};
            local result = {};
            local resultPrint = {
                success = {},
                error = {}
            };
            local confirm;

            for aura in string.gmatch(import, "([^,]*)") do
                local trimmedAura = aura:match("^%s*(.-)%s*$");

                if aura ~= "" then
                    table.insert(t, trimmedAura)
                end

                for _, v in ipairs(t) do
                    if (not hash[v]) then
                        result[#result+1] = v;
                        hash[v] = true;
                    end
                end
            end

            for k,v in ipairs(result) do
                if k then
                    local added, status = addSpell(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg], v);

                    if not confirm and added then
                        confirm = added;
                    end

                    if added then
                        if not confirm then
                            confirm = added;
                        end

                        table.insert(resultPrint.success, status);
                    else
                        table.insert(resultPrint.error, status);
                    end
                end
            end

            if #resultPrint.success > 0 then
                print("|cfff563ff[ClassicPlates Plus]: |cff00eb00" .. "Successfully added " .. #resultPrint.success .. " auras");
            end
            if #resultPrint.error > 0 then
                for k,v in ipairs(resultPrint.error) do
                    print(v);
                end
            end

            updateAurasList();

            -- Update
            updateSettings(cfg);

            if confirm then
                frame_PopUp:Hide();
            end
        end);

        frame_PopUp:Show();
        frame_PopUp.input:SetFocus();
    end);

    -- Export Button
    local frame_ExportButton = CreateFrame("Button", nil, panel, "GameMenuButtonTemplate");
    frame_ExportButton:SetPoint("left", frame_ImportButton, "right", 8, 0);
    frame_ExportButton:SetSize(120, 22);
    frame_ExportButton:SetText("Export Auras");
    frame_ExportButton:SetNormalFontObject("GameFontNormal");
    frame_ExportButton:SetHighlightFontObject("GameFontHighlight");

    frame_ExportButton:SetScript("OnClick", function()
        frame_PopUp.title:SetText("Export " .. name);
        frame_PopUp.note:SetText("Enter spell IDs separated by commas");
        frame_PopUp.input:SetText("");
        frame_PopUp.Button:SetText("Select all");
        frame_PopUp.Button:Show();

        local export;

        for k,v in pairs(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg]) do
            if k then
                if not export then
                    export = tostring(k);
                else
                    export = export .. ", " .. k;
                end
            end
        end

        if export then
            frame_PopUp.input:SetText(export);

            frame_PopUp.Button:SetScript("OnClick", function()
                if export then
                    frame_PopUp.input:HighlightText();
                    frame_PopUp.input:SetFocus();
                end
            end);

            frame_PopUp:Show();
            frame_PopUp.input:HighlightText();
            frame_PopUp.input:SetFocus();
        end
    end);

    -- Remove All Button
    local frame_RemoveAllButton = CreateFrame("Button", nil, panel, "GameMenuButtonTemplate");
    frame_RemoveAllButton:SetPoint("topLeft", frame_ImportButton, "bottomLeft", 0, -32);
    frame_RemoveAllButton:SetSize(248, 22);
    frame_RemoveAllButton:SetText("Remove All Auras");
    frame_RemoveAllButton:SetNormalFontObject("GameFontNormal");
    frame_RemoveAllButton:SetHighlightFontObject("GameFontHighlight");

    local dialogName_removeAll = myAddon .. "_" .. name .. "_Confirm_RemoveAllButton";
    StaticPopupDialogs[dialogName_removeAll] = {
        text = "Do you want to remove all auras?",
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        button1 = "Remove All",
        button2 = "Cancel",
        OnAccept = function()
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile][cfg] = {};

            for k,v in pairs(panel.scrollChild.auras) do
                if k then
                    v:Hide();
                end
            end

            -- Update
            updateAurasList();

            -- Update
            updateSettings(cfg);
        end,
    };

    frame_RemoveAllButton:SetScript("OnClick", function()
        StaticPopup_Show(dialogName_removeAll);
    end);

    -- Update
    updateAurasList();

    -- Adding frame to the settings list
    table.insert(panel.list, parent);
end

----------------------------------------
-- Profiles
----------------------------------------
function func:Create_Profiles(panel, name, cfg, default)

    -- Remove all profiles
    local function removeAllProfiles()
        for k, v in pairs(CFG_Account_ClassicPlatesPlus.Profiles) do
            CFG_Account_ClassicPlatesPlus.Profiles[k] = nil;
        end
    end
    --removeAllProfiles();

    -- Wipe all
    local function wipeAll()
        for k, v in pairs(CFG_Account_ClassicPlatesPlus) do
            if k then
                CFG_Account_ClassicPlatesPlus[k] = nil;
            end
        end
    end

    local function CloseAllStaticPopups()
        --[[for index = 1, STATICPOPUP_NUMDIALOGS do
            local dialog = _G["StaticPopup" .. index]
            if dialog and dialog:IsShown() then
                StaticPopup_Hide(dialog.which)
            end
        end]]

        local dialogsToClose = {
            "RENAME_PROFILE_DIALOG",
            "CREATE_NEW_PROFILE_DIALOG",
            "DELETE_PROFILE_DIALOG",
            "COPY_PROFILE_DIALOG",
        };

        for index = 1, STATICPOPUP_NUMDIALOGS do
            local dialog = _G["StaticPopup" .. index];

            if dialog and dialog:IsShown() and tContains(dialogsToClose, dialog.which) then
                StaticPopup_Hide(dialog.which);
            end
        end
    end

    local function serializeTable(configsTable)
        local serialized = "{"

        for key, value in pairs(configsTable) do
            local valueType = type(value)

            if valueType == "string" then
                value = "\"" .. value .. "\""
            elseif valueType == "boolean" then
                value = tostring(value)
            elseif valueType == "table" then
                value = serializeTable(value)
            end

            serialized = serialized .. key .. "=" .. value .. ","
        end

        if serialized:sub(-1) == "," then
            serialized = serialized:sub(1, -2)
        end

        serialized = serialized .. "}"

        return serialized
    end

    local function deserializeTable(serialized)
        local function parseValue(value)
            if value:sub(1, 1) == "{" and value:sub(-1) == "}" then
                return deserializeTable(value:sub(2, -2))
            elseif value == "true" or value == "false" then
                return value == "true"
            elseif tonumber(value) then
                return tonumber(value)
            elseif value:sub(1, 1) == "\"" and value:sub(-1) == "\"" then
                return value:sub(2, -2)
            else
                return value
            end
        end

        local configsTable = {}
        serialized = serialized:sub(2, -2)

        local currentKey = nil
        local nestedLevel = 0
        local buffer = ""
        local inQuotes = false

        for char in serialized:gmatch(".") do
            if char == "\"" then
                inQuotes = not inQuotes
                buffer = buffer .. char
            elseif char == "{" and not inQuotes then
                nestedLevel = nestedLevel + 1
                buffer = buffer .. char
            elseif char == "}" and not inQuotes then
                nestedLevel = nestedLevel - 1
                buffer = buffer .. char
                if nestedLevel == 0 then
                    if currentKey then
                        configsTable[currentKey] = parseValue(buffer)
                    end
                    currentKey, buffer = nil, ""
                end
            elseif char == "," and nestedLevel == 0 and not inQuotes then
                if currentKey then
                    configsTable[currentKey] = parseValue(buffer)
                    currentKey, buffer = nil, ""
                end
            elseif char == "=" and nestedLevel == 0 and not inQuotes then
                currentKey = buffer
                buffer = ""
            else
                buffer = buffer .. char
            end
        end

        if currentKey then
            configsTable[currentKey] = parseValue(buffer)
        end

        return configsTable
    end

    local function PopUp(f, type)
        f:ClearAllPoints();
        f.frame1:ClearAllPoints();
        f.frame2:ClearAllPoints();
        f.frame2.Wrapper:ClearAllPoints();

        local buttonsWidth = 0;
        local count = 0;
        for i = 1,3 do
            if f["Button" .. i]:GetText() ~= nil and f["Button" .. i]:GetText() ~= "" then
                f["Button" .. i]:SetSize(f["Button" .. i]:GetFontString():GetStringWidth() + 48, 22);
                f["Button" .. i]:Show();

                buttonsWidth = buttonsWidth + f["Button" .. i]:GetWidth();
                count = count + 1;
            else
                f["Button" .. i]:Hide();
            end
        end

        if type == 1 then
            f:SetPoint("topLeft", 120, -200);
            f:SetPoint("bottomRight", -120, 280);
        elseif type == 2 then
            f:SetPoint("topLeft", 120, -200);
            f:SetPoint("bottomRight", -120, 320);
        elseif type == 3 then
            f:SetPoint("topLeft", 60, -60);
            f:SetPoint("bottomRight", -60, 60);
        end

        f.frame1:SetPoint("topLeft", 16, -42);
        f.frame1:SetPoint("bottomRight", -16, 46);

        f.frame2:SetPoint("topLeft", 16, -42);
        f.frame2:SetPoint("bottomRight", -16, 46);

        local totalGapsWidth = count * 8;
        local totalWidth = (buttonsWidth + f.Cancel:GetWidth()) + totalGapsWidth;
        local offset = totalWidth / 2;

        f.frame2.Wrapper:SetAllPoints();

        f.Cancel:ClearAllPoints();
        f.Cancel:SetPoint("bottomRight", f, "bottom", offset, 14);

        f.frame1:SetShown(type == 1);
        f.frame2:SetShown(type == 3);

        f.inputSingle:SetShown(type == 1);
        f.inputMulti:SetShown(type == 3);
        f.scrollFrame:SetShown(type == 3);

        if type == 1 or type == 3 then
            local editBox = type == 1 and "inputSingle" or (type == 3) and "inputMulti";
            f[editBox]:HighlightText();
        end

        f:Show();
    end

    local selectedProfile = CFG_ClassicPlatesPlus.Profile;

    panel.scrollFrame:Hide();
    local newPanel = CreateFrame("Frame", nil, panel, nil);
    newPanel:SetAllPoints();

    -- Creating a parent
    local parent = CreateFrame("frame", nil, newPanel.scrollChild);

    -- Line Divider
    newPanel.divider = newPanel:CreateTexture();
    newPanel.divider:SetPoint("topLeft", 370, -106);
    newPanel.divider:SetPoint("topRight", -40, -106);
    newPanel.divider:SetAlpha(0.5);
    newPanel.divider:SetHeight(1);
    newPanel.divider:SetAtlas("Options_HorizontalDivider");

    -- Scroll Frame
    newPanel.scrollFrame = CreateFrame("ScrollFrame", nil, newPanel, "ScrollFrameTemplate");
    newPanel.scrollFrame:SetPoint("topLeft", 370, -108);
    newPanel.scrollFrame:SetPoint("bottomRight", -26, 0);

    -- Scroll Child
    newPanel.scrollFrame.scrollChild = CreateFrame("frame", nil, newPanel.scrollFrame);
    newPanel.scrollFrame.scrollChild:SetPoint("topLeft");
    newPanel.scrollFrame.scrollChild:SetSize(1, 1);

    -- Parent Scroll Child
    newPanel.scrollFrame:SetScrollChild(newPanel.scrollFrame.scrollChild);

    local backdrop = {
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileEdge = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    };

    -- frame_PopUp
    local frame_PopUp = CreateFrame("Frame", myAddon .. "PopUp", newPanel, "BackdropTemplate");
    frame_PopUp:SetPoint("topLeft", 60, -60);
    frame_PopUp:SetPoint("bottomRight", -60, 60);
    frame_PopUp:SetFrameLevel(newPanel.scrollFrame.scrollChild:GetFrameLevel() + 5);
    frame_PopUp:EnableMouse(true);
    frame_PopUp:SetBackdrop(backdrop);
    frame_PopUp:SetBackdropColor(0.1, 0.1, 0.1, 1);
    frame_PopUp:SetBackdropBorderColor(0.62, 0.62, 0.62);
    frame_PopUp:Hide();

    -- Title
    frame_PopUp.title = frame_PopUp:CreateFontString(nil, "overlay", "GameFontNormalLarge");
    frame_PopUp.title:SetPoint("top", frame_PopUp, "top", 0, -16);

    -- Background
    frame_PopUp.background = CreateFrame("button", nil, frame_PopUp);
    frame_PopUp.background:SetPoint("topLeft", newPanel, "topLeft", -14, 8);
    frame_PopUp.background:SetSize(680, 610);
    frame_PopUp.background:SetFrameLevel(frame_PopUp:GetFrameLevel() - 1);
    frame_PopUp.background:EnableMouse(true);
    frame_PopUp.background:EnableMouseWheel(true);
    frame_PopUp.background.color = frame_PopUp.background:CreateTexture();
    frame_PopUp.background.color:SetAllPoints();
    frame_PopUp.background.color:SetColorTexture(0.05, 0.05, 0.05, 0.8);
    frame_PopUp.background:SetScript("OnMouseWheel", function() end);
    frame_PopUp.background:SetScript("OnClick", function()
        frame_PopUp:Hide();
    end);

    frame_PopUp.frame1 = CreateFrame("Frame", nil, frame_PopUp, "BackdropTemplate");
    frame_PopUp.frame1:SetPoint("topLeft", 16, -62);
    frame_PopUp.frame1:SetPoint("bottomRight", -16, 380);
    frame_PopUp.frame1:SetBackdrop(backdrop);
    frame_PopUp.frame1:SetBackdropColor(0, 0, 0, 0.5);
    frame_PopUp.frame1:SetBackdropBorderColor(0.62, 0.62, 0.62);
    frame_PopUp.frame1:EnableMouse(false);

    frame_PopUp.frame2 = CreateFrame("Frame", nil, frame_PopUp, "BackdropTemplate");
    frame_PopUp.frame2:SetPoint("topLeft", 16, -42);
    frame_PopUp.frame2:SetPoint("bottomRight", -16, 46);
    frame_PopUp.frame2:SetBackdrop(backdrop);
    frame_PopUp.frame2:SetBackdropColor(0, 0, 0, 0.5);
    frame_PopUp.frame2:SetBackdropBorderColor(0.62, 0.62, 0.62);
    frame_PopUp.frame2:EnableMouse(false);

    frame_PopUp.frame2.Wrapper = CreateFrame("button", nil, frame_PopUp.frame2);
    frame_PopUp.frame2.Wrapper:SetAllPoints();
    frame_PopUp.frame2.Wrapper:SetScript("OnClick", function()
        frame_PopUp.inputMulti:SetFocus();
    end);

    frame_PopUp.scrollFrame = CreateFrame("ScrollFrame", myAddon .. "_" .. name .. "_PopUpScroll", frame_PopUp.frame2, "ScrollFrameTemplate");
    frame_PopUp.scrollFrame:SetPoint("topLeft", 8, -10);
    frame_PopUp.scrollFrame:SetPoint("bottomRight", -28, 6);

    frame_PopUp.inputMulti = CreateFrame("EditBox", nil, frame_PopUp.scrollFrame);
    frame_PopUp.inputMulti:SetWidth(474);
    frame_PopUp.scrollFrame:SetScrollChild(frame_PopUp.inputMulti);
    frame_PopUp.inputMulti:SetFontObject("GameFontHighlight");
    frame_PopUp.inputMulti:SetTextInsets(6, 6, 0, 0);
    frame_PopUp.inputMulti:SetMultiLine(true);
    frame_PopUp.inputMulti:SetMovable(false);
    frame_PopUp.inputMulti:SetAutoFocus(false);
    frame_PopUp.inputMulti:SetMaxLetters(0);
    frame_PopUp.inputMulti:SetScript("OnHide", function(self)
        self:SetText("");
    end)

    frame_PopUp.inputSingle = CreateFrame("EditBox", nil, frame_PopUp.frame1);
    frame_PopUp.inputSingle:SetPoint("topLeft", 12, 0);
    frame_PopUp.inputSingle:SetPoint("bottomRight", -12, 0);
    frame_PopUp.inputSingle:SetFontObject("GameFontHighlight");
    frame_PopUp.inputSingle:SetMultiLine(false);
    frame_PopUp.inputSingle:SetMovable(false);
    frame_PopUp.inputSingle:SetAutoFocus(false);
    frame_PopUp.inputSingle:SetMaxLetters(0);
    frame_PopUp.inputSingle:SetScript("OnHide", function(self)
        self:SetText("");
    end)

    -- Error message
    frame_PopUp.ErrorMsg = frame_PopUp:CreateFontString(nil, "overlay", "GameFontHighlight");
    frame_PopUp.ErrorMsg:SetPoint("bottomLeft", frame_PopUp, "bottomLeft", 20, 21);
    frame_PopUp.ErrorMsg:SetTextColor(1, 0, 0);
    frame_PopUp.ErrorMsg:Hide();

    -- Button Cancel
    frame_PopUp.Cancel = CreateFrame("Button", nil, frame_PopUp, "GameMenuButtonTemplate");
    frame_PopUp.Cancel:SetNormalFontObject("GameFontNormal");
    frame_PopUp.Cancel:SetHighlightFontObject("GameFontHighlight");
    frame_PopUp.Cancel:SetText("Cancel");
    frame_PopUp.Cancel:SetSize(frame_PopUp.Cancel:GetFontString():GetStringWidth() + 48, 22);
    frame_PopUp.Cancel:SetScript("OnClick", function()
        frame_PopUp:Hide();
    end);

    -- Button 1
    frame_PopUp.Button1 = CreateFrame("Button", nil, frame_PopUp, "GameMenuButtonTemplate");
    frame_PopUp.Button1:SetPoint("right", frame_PopUp.Cancel, "left", -8,0);
    frame_PopUp.Button1:SetNormalFontObject("GameFontNormal");
    frame_PopUp.Button1:SetHighlightFontObject("GameFontHighlight");
    frame_PopUp.Button1:Hide();

    -- Button 2
    frame_PopUp.Button2 = CreateFrame("Button", nil, frame_PopUp, "GameMenuButtonTemplate");
    frame_PopUp.Button2:SetPoint("right", frame_PopUp.Button1, "left", -8,0);
    frame_PopUp.Button2:SetNormalFontObject("GameFontNormal");
    frame_PopUp.Button2:SetHighlightFontObject("GameFontHighlight");
    frame_PopUp.Button2:Hide();

    -- Button 3
    frame_PopUp.Button3 = CreateFrame("Button", nil, frame_PopUp, "GameMenuButtonTemplate");
    frame_PopUp.Button3:SetPoint("right", frame_PopUp.Button2, "left", -8,0);
    frame_PopUp.Button3:SetNormalFontObject("GameFontNormal");
    frame_PopUp.Button3:SetHighlightFontObject("GameFontHighlight");
    frame_PopUp.Button3:Hide();

    frame_PopUp:SetScript("OnHide", function(self)
        for i = 1,3 do
            self["Button" .. i]:Hide();
            self["Button" .. i]:SetText("");
        end
        self.inputSingle:SetText("");
        self.inputMulti:SetText("");
        self:Hide();
    end);

    -- Profile name
    local frame_ProfileName = newPanel:CreateFontString(nil, "overlay", "GameFontNormalLarge");
    frame_ProfileName:SetPoint("topLeft", 38, -70);
    frame_ProfileName:SetWidth(300);
    frame_ProfileName:SetJustifyH("left");

    -- Rename profile - Button
    local frame_RenameButton = CreateFrame("Button", nil, newPanel, "GameMenuButtonTemplate");
    frame_RenameButton:SetPoint("topRight", frame_ProfileName, "topLeft", -6, 4);
    frame_RenameButton:SetSize(22, 22);
    frame_RenameButton:SetNormalFontObject("GameFontNormal");
    frame_RenameButton:SetHighlightFontObject("GameFontHighlight");
    frame_RenameButton.icon = frame_RenameButton:CreateTexture(nil, "overlay");
    frame_RenameButton.icon:SetSize(14, 14);
    frame_RenameButton.icon:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\icons\\edit");
    frame_RenameButton.icon:SetVertexColor(1, 0.82, 0);
    frame_RenameButton.icon:SetPoint("center", frame_RenameButton, 0, 0);
    frame_RenameButton:HookScript("OnMouseDown", function(self)
        self.icon:SetPoint("center", self, 0.5, -0.5);
    end);
    frame_RenameButton:HookScript("OnMouseUp", function(self)
        self.icon:SetPoint("center", self, 0, 0);
    end);

    -- Activate Button
    local frame_ActivateButton = CreateFrame("Button", nil, newPanel, "GameMenuButtonTemplate");
    frame_ActivateButton:SetPoint("topLeft", frame_ProfileName, "bottomLeft", -28, -22);
    frame_ActivateButton:SetSize(246, 22);
    frame_ActivateButton:SetText("Activate profile");
    frame_ActivateButton:SetNormalFontObject("GameFontNormal");
    frame_ActivateButton:SetHighlightFontObject("GameFontHighlight");

    -- Create a copy Button
    local frame_CopyButton = CreateFrame("Button", nil, newPanel, "GameMenuButtonTemplate");
    frame_CopyButton:SetPoint("topLeft", frame_ActivateButton, "bottomLeft", 0, -32);
    frame_CopyButton:SetSize(120, 22);
    frame_CopyButton:SetText("Create a Copy");
    frame_CopyButton:SetNormalFontObject("GameFontNormal");
    frame_CopyButton:SetHighlightFontObject("GameFontHighlight");

    -- Export Button
    local frame_ExportButton = CreateFrame("Button", nil, newPanel, "GameMenuButtonTemplate");
    frame_ExportButton:SetPoint("left", frame_CopyButton, "right", 8, 0);
    frame_ExportButton:SetSize(120, 22);
    frame_ExportButton:SetText("Export");
    frame_ExportButton:SetNormalFontObject("GameFontNormal");
    frame_ExportButton:SetHighlightFontObject("GameFontHighlight");

    -- Reset Button
    local frame_ResetButton = CreateFrame("Button", nil, newPanel, "GameMenuButtonTemplate");
    frame_ResetButton:SetPoint("topLeft", frame_CopyButton, "bottomLeft", 0, -32);
    frame_ResetButton:SetSize(120, 22);
    frame_ResetButton:SetText("Reset");
    frame_ResetButton:SetNormalFontObject("GameFontNormal");
    frame_ResetButton:SetHighlightFontObject("GameFontHighlight");

    -- Delete Button
    local frame_DeleteButton = CreateFrame("Button", nil, newPanel, "GameMenuButtonTemplate");
    frame_DeleteButton:SetPoint("left", frame_ResetButton, "right", 8, 0);
    frame_DeleteButton:SetSize(120, 22);
    frame_DeleteButton:SetText("Delete");
    frame_DeleteButton:SetNormalFontObject("GameFontNormal");
    frame_DeleteButton:SetHighlightFontObject("GameFontHighlight");

    if selectedProfile == CFG_ClassicPlatesPlus.Profile then
        frame_ActivateButton:Disable();
        frame_ActivateButton:SetText("Profile Activated");
        frame_DeleteButton:Disable();
    else
        frame_ActivateButton:Enable();
        frame_ActivateButton:SetText("Activate Profile");
        frame_DeleteButton:Enable();
    end

    -- List of Profiles - Title
    local frame_ProfilesTitle = newPanel:CreateFontString(nil, "overlay", "GameFontNormal");
    frame_ProfilesTitle:SetPoint("topLeft", 360, -75);
    frame_ProfilesTitle:SetText("");

    -- Import Profile - Button
    local frame_ImportButton = CreateFrame("Button", nil, newPanel, "GameMenuButtonTemplate");
    frame_ImportButton:SetPoint("topRight", -36, -70);
    frame_ImportButton:SetSize(96, 22);
    frame_ImportButton:SetText("Import");
    frame_ImportButton:SetNormalFontObject("GameFontNormal");
    frame_ImportButton:SetHighlightFontObject("GameFontHighlight");

    -- Create New Profile - Button
    local frame_CreateButton = CreateFrame("Button", nil, newPanel, "GameMenuButtonTemplate");
    frame_CreateButton:SetPoint("right", frame_ImportButton, "left", -10, 0);
    frame_CreateButton:SetSize(96, 22);
    frame_CreateButton:SetText("Create New");
    frame_CreateButton:SetNormalFontObject("GameFontNormal");
    frame_CreateButton:SetHighlightFontObject("GameFontHighlight");

    -- Profiles list
    local function updateProfilesList()
        -- Inserting profiles in a sorter table
        local sorted = {};

        for k,v in pairs(CFG_Account_ClassicPlatesPlus.Profiles) do
            if k and v.displayName then
                v.id = k;
                table.insert(sorted, v);
            end
        end

        -- Sorting a table values alphabetically while sorting aplhabetically
        table.sort(sorted, function(a, b)
            if a.displayName and b.displayName then
                return a.displayName < b.displayName;
            else
                return false;
            end
        end);

        --[[table.sort(sorted, function(a, b)
            if a.id == CFG_ClassicPlatesPlus.Profile then
                return true
            elseif b.id == CFG_ClassicPlatesPlus.Profile then
                return false
            else
                return a.displayName < b.displayName
            end
        end)]]

        local alphaLeave = 0.1;
        local alphaHover = 0.15;
        local alphaEnter = 0.3;

        local function anchor(list, index)
            if index == 1 then
                return "TOPLEFT";
            else
                return "TOPLEFT", list[index - 1], "BOTTOMLEFT", 0, -2;
            end
        end

        -- List of profiles
        newPanel.ProflesList = newPanel.ProflesList or {};

        for i = 1, #newPanel.ProflesList do
            if newPanel.ProflesList[i] then
                newPanel.ProflesList[i]:ClearAllPoints();
                newPanel.ProflesList[i]:Hide();
            end
        end

        for k,v in ipairs(sorted) do
            if k then
                local list = newPanel.ProflesList;
                local active = v.id == CFG_ClassicPlatesPlus.Profile;

                if not list[k] then
                    list[k] = CreateFrame("button", nil, newPanel.scrollFrame.scrollChild);
                    list[k]:SetPoint(anchor(list, k));

                    list[k].name = newPanel.scrollFrame.scrollChild:CreateFontString(nil, "overlay", "GameFontNormal");
                    list[k].name:SetParent(list[k]);
                    list[k].name:SetPoint("left", 10, 0);
                    list[k].name:SetWidth(233);
                    list[k].name:SetJustifyH("left");
                    list[k].name:SetText(v.displayName);

                    list[k]:SetSize(260, list[k].name:GetHeight() + 16);

                    list[k].background = newPanel.scrollFrame.scrollChild:CreateTexture();
                    list[k].background:SetParent(list[k]);
                    list[k].background:SetAllPoints();
                    list[k].background:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\aurasList");
                    list[k].background:SetDrawLayer("background", 1);
                else
                    list[k]:SetPoint(anchor(list, k));
                    list[k].name:SetText(v.displayName);
                    list[k]:SetSize(260, list[k].name:GetHeight() + 16);
                    list[k]:Show();
                end

                -- Highlight
                if (selectedProfile == v.id) then
                    list[k].name:SetFontObject("GameFontHighlight");
                    list[k].background:SetAlpha(alphaEnter);
                else
                    list[k].name:SetFontObject("GameFontNormal");
                    list[k].background:SetAlpha(alphaLeave);
                end

                -- color
                if active then
                    list[k].background:SetVertexColor(0.3, 1, 0);
                elseif (selectedProfile == v.id) then
                    list[k].background:SetVertexColor(1, 0.82, 0);
                else
                    list[k].background:SetVertexColor(0.65, 0.65, 0.65);
                end

                -- Clicks
                list[k]:HookScript("OnMouseDown", function(self)
                    self.name:SetPoint("left", 11, -1);
                end);
                list[k]:HookScript("OnMouseUp", function(self)
                    self.name:SetPoint("left", 10, 0);
                end);
                list[k]:SetScript("OnClick", function(self)
                    selectedProfile = v.id;

                    if selectedProfile == CFG_ClassicPlatesPlus.Profile then
                        frame_ActivateButton:Disable();
                        frame_ActivateButton:SetText("Profile Activated");
                        frame_DeleteButton:Disable();
                    else
                        frame_ActivateButton:Enable();
                        frame_ActivateButton:SetText("Activate Profile");
                        frame_DeleteButton:Enable();
                    end

                    updateProfilesList();
                end);

                -- Highlight
                list[k]:SetScript("OnEnter", function(self)
                    self.name:SetFontObject("GameFontHighlight");

                    if (selectedProfile == v.id) then
                        self.background:SetAlpha(alphaEnter);
                    else
                        self.background:SetAlpha(alphaHover);
                    end

                    if active then
                        self.background:SetVertexColor(0.3, 1, 0);
                    else
                        self.background:SetVertexColor(1, 0.82, 0);
                    end
                end);
                list[k]:SetScript("OnLeave", function(self)
                    if (selectedProfile == v.id) then
                        self.name:SetFontObject("GameFontHighlight");
                        self.background:SetAlpha(alphaEnter);

                        if active then
                            self.background:SetVertexColor(0.3, 1, 0);
                        else
                            self.background:SetVertexColor(1, 0.82, 0);
                        end
                    else
                        self.name:SetFontObject("GameFontNormal");
                        self.background:SetAlpha(alphaLeave);

                        if active then
                            self.background:SetVertexColor(0.3, 1, 0);
                        else
                            self.background:SetVertexColor(0.65, 0.65, 0.65);
                        end
                    end
                end);
            end
        end

        if selectedProfile == CFG_ClassicPlatesPlus.Profile then
            frame_ActivateButton:Disable();
            frame_ActivateButton:SetText("Profile Activated");
            frame_DeleteButton:Disable();
        else
            frame_ActivateButton:Enable();
            frame_ActivateButton:SetText("Activate Profile");
            frame_DeleteButton:Enable();
        end

        frame_ProfileName:SetText(CFG_Account_ClassicPlatesPlus.Profiles[selectedProfile].displayName);
        --frame_ProfileName:SetText(func:TrimText(250, frame_ProfileName));
    end

    -- CLICKS
    frame_RenameButton:SetScript("OnClick", function()
        frame_PopUp.title:SetText("Rename profile");
        frame_PopUp.inputSingle:SetText(CFG_Account_ClassicPlatesPlus.Profiles[selectedProfile].displayName);
        frame_PopUp.Button1:SetText("Rename");
        frame_PopUp.Button1:SetScript("OnClick", function()
            local input = func:TrimEmptySpaces(frame_PopUp.inputSingle:GetText());
            local filteredText = input:gsub("[^%w%s%-_]", "");

            if not func:ProfileNameAvailable(input) then
                print('|cfff563ff[ClassicPlates Plus]: |cffFF5600' .. 'Profile with the name "' .. input .. '" already exists');
            else
                if input == filteredText then
                    CFG_Account_ClassicPlatesPlus.Profiles[selectedProfile].displayName = input;
                    updateProfilesList();
                    frame_PopUp:Hide();
                else
                    print('|cfff563ff[ClassicPlates Plus]: |cffFF5600' .. 'Invalid characters. Use letters, numbers, hyphens, and underscores only.');
                end
            end
        end);

        PopUp(frame_PopUp, 1);
        frame_PopUp.inputSingle:SetFocus();
    end);

    frame_ActivateButton:SetScript("OnClick", function()
        CFG_ClassicPlatesPlus.Profile = selectedProfile;
        if selectedProfile == CFG_ClassicPlatesPlus.Profile then
            frame_ActivateButton:Disable();
            frame_ActivateButton:SetText("Profile Activated");
            frame_DeleteButton:Disable();
        else
            frame_ActivateButton:Enable();
            frame_ActivateButton:SetText("Activate Profile");
            frame_DeleteButton:Enable();
        end

        updateProfilesList();
        updateEverything();
    end);

    frame_DeleteButton:SetScript("OnClick", function()
        frame_PopUp.title:SetText("Are you sure you want to delete this profile?");
        frame_PopUp.Button1:SetText("Delete");
        frame_PopUp.Button1:SetScript("OnClick", function()
            if selectedProfile ~= CFG_ClassicPlatesPlus.Profile then
                CFG_Account_ClassicPlatesPlus.Profiles[selectedProfile] = nil;
                selectedProfile = CFG_ClassicPlatesPlus.Profile;

                updateProfilesList();
            else
                print('|cfff563ff[ClassicPlates Plus]: |cffFF5600' .. "Can't delete an active profile");
            end

            frame_PopUp:Hide();
        end);

        PopUp(frame_PopUp, 2);
    end);

    frame_ResetButton:SetScript("OnClick", function()
        frame_PopUp.title:SetText("Are you sure you want to reset this profile?");
        frame_PopUp.Button1:SetText("Reset");
        frame_PopUp.Button1:SetScript("OnClick", function()
            for k,v in pairs(data.settings.configs.all) do
                if k and k ~= "displayName" then
                    func:ResetSettings(k,v, selectedProfile);
                end
            end

            if selectedProfile == CFG_ClassicPlatesPlus.Profile then
                updateEverything();
            end

            frame_PopUp:Hide();
        end);

        PopUp(frame_PopUp, 2);
    end);

    frame_CreateButton:SetScript("OnClick", function()
        local playerName = UnitName("player");
        local playerRealm = GetRealmName("player");
        local profileName = playerName .. " - " .. playerRealm;

        frame_PopUp.title:SetText("Create a new profile");
        frame_PopUp.inputSingle:SetText(profileName);
        frame_PopUp.Button1:SetText("Create");
        frame_PopUp.Button1:SetScript("OnClick", function()
            local input = func:TrimEmptySpaces(frame_PopUp.inputSingle:GetText());
            local filteredText = input:gsub("[^%w%s%-_]", "");
            local profileID = func:GenerateID();

            if not func:ProfileNameAvailable(input) then
                print('|cfff563ff[ClassicPlates Plus]: |cffFF5600' .. 'Profile with the name "' .. input .. '" already exists');
            else
                if input == filteredText then
                    CFG_Account_ClassicPlatesPlus.Profiles[profileID] = { displayName = input };

                    updateProfilesList();

                    -- Populating Settings Table
                    for k,v in pairs(data.settings.configs.all) do
                        if k then
                            func:ResetSettings(k,v, profileID);
                        end
                    end

                    frame_PopUp:Hide();
                else
                    print('|cfff563ff[ClassicPlates Plus]: |cffFF5600' .. 'Invalid characters. Use letters, numbers, hyphens, and underscores only.');
                end
            end
        end);

        PopUp(frame_PopUp, 1);
        frame_PopUp.inputSingle:SetFocus();
    end);

    frame_CopyButton:SetScript("OnClick", function()
        frame_PopUp.title:SetText("Copy profile");
        frame_PopUp.inputSingle:SetText(CFG_Account_ClassicPlatesPlus.Profiles[selectedProfile].displayName .. " - Copy");
        frame_PopUp.Button1:SetText("Copy");
        frame_PopUp.Button1:SetScript("OnClick", function()
            local input = func:TrimEmptySpaces(frame_PopUp.inputSingle:GetText());
            local filteredText = input:gsub("[^%w%s%-_]", "");
            local profileID = func:GenerateID();

            if not func:ProfileNameAvailable(input) then
                print('|cfff563ff[ClassicPlates Plus]: |cffFF5600' .. 'Profile with the name "' .. input .. '" already exists');
            else
                if input == filteredText then
                    CFG_Account_ClassicPlatesPlus.Profiles[profileID] = {};

                    for k,v in pairs(CFG_Account_ClassicPlatesPlus.Profiles[selectedProfile]) do
                        if k and k ~= "displayName" then
                            CFG_Account_ClassicPlatesPlus.Profiles[profileID][k] = v;
                        end
                    end

                    CFG_Account_ClassicPlatesPlus.Profiles[profileID].displayName = input;

                    updateProfilesList();

                    frame_PopUp:Hide();
                else
                    print('|cfff563ff[ClassicPlates Plus]: |cffFF5600' .. 'Invalid characters. Use letters, numbers, hyphens, and underscores only.');
                end
            end
        end);

        PopUp(frame_PopUp, 1);
        frame_PopUp.inputSingle:SetFocus();
    end);

    frame_ExportButton:SetScript("OnClick", function()
        frame_PopUp.title:SetText("Export profile");
        frame_PopUp.Button1:SetText("Select all");

        local export = serializeTable(CFG_Account_ClassicPlatesPlus.Profiles[selectedProfile]);
        if export then
            frame_PopUp.inputMulti:SetText(export);
            frame_PopUp.inputMulti:SetScript("OnTextChanged", function(self)
                self:SetText(export);
                self:HighlightText();
                self:SetFocus();
            end);
        end

        frame_PopUp.Button1:SetScript("OnClick", function()
            frame_PopUp.inputMulti:HighlightText();
            frame_PopUp.inputMulti:SetFocus();
        end);

        PopUp(frame_PopUp, 3);
        frame_PopUp.inputMulti:SetFocus();
    end);

    frame_ImportButton:SetScript("OnClick", function()
        frame_PopUp.title:SetText("Import profile");
        frame_PopUp.Button1:SetText("Import");
        frame_PopUp.inputMulti:SetScript("OnTextChanged", nil);

        frame_PopUp.Button1:SetScript("OnClick", function()
            local import = deserializeTable(frame_PopUp.inputMulti:GetText());

            local function generateName(name)
                if name then
                    if not func:ProfileNameAvailable(name) then
                        name = name .. " - Export";
                        return generateName(name);
                    else
                        return name;
                    end
                else
                    return generateName("Unknown");
                end
            end

            local function validateConfig(imp, def)
                if imp and type(imp) == "table" then
                    local result = {};

                    for k,v in pairs(def) do
                        if type(v) == "table" then
                            if imp[k] ~= nil then
                                if type(v.default) == "table" and type(imp[k]) == "table" then
                                    result[k] = validateConfig(imp[k], v.default);
                                elseif type(imp[k]) == type(v.default) then
                                    result[k] = imp[k];
                                else
                                    result[k] = v.default;
                                end
                            else
                                result[k] = v.default;
                            end
                        else
                            result[k] = v;
                        end
                    end

                    if imp.displayName then
                        result.displayName = imp.displayName;
                    else
                        result.displayName = "Unknown";
                    end

                    return result
                else
                    return false;
                end
            end

            local configs = validateConfig(import, data.settings.configs.all);

            if configs then
                local profileID = func:GenerateID();
                local newDisplayName = generateName(configs.displayName);

                CFG_Account_ClassicPlatesPlus.Profiles[profileID] = configs;
                CFG_Account_ClassicPlatesPlus.Profiles[profileID].displayName = newDisplayName;

                updateProfilesList();
                frame_PopUp:Hide();
            else
                print(addonName..red.."Import failed, invalid configs");
            end
        end);

        PopUp(frame_PopUp, 3);
        frame_PopUp.inputMulti:SetFocus();
    end);

    newPanel:SetScript("OnHide", function(self)
        CloseAllStaticPopups();
    end);

    -- Initiating profiles list
    updateProfilesList();

    -- Adding frame to the settings list
    table.insert(newPanel, parent);
end