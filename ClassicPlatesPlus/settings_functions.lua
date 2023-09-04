----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- Update
----------------------------------------
-- Update everything as if nameplate was just added
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

-- Update Nameplate Visuals
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

-- Updating Auras
local function updateAuras()
    local nameplates = C_NamePlate.GetNamePlates();

    if nameplates then
        for k,v in pairs(nameplates) do
            if k and v.unitFrame.unit then
                func:Update_Auras(v.unitFrame.unit);
            end
        end
    end
end

-- Updatig Auras Visuals Only
local function updateAurasVisuals()
    local nameplates = C_NamePlate.GetNamePlates();

    local function work(unitFrame, auraType)
        local scaleOffset = unitFrame.unit == "player" and 0.15 or 0.15;
        local scale = Config.AurasScale - scaleOffset;
        if scale <= 0 then scale = 0.1 end

        for i = 1, 40 do
            if unitFrame[auraType]["auras"][i] then
                unitFrame[auraType]["auras"][i]:SetScale(scale);
                unitFrame[auraType]["auras"][i].cooldown:SetReverse(Config.AurasReverseAnimation);
                unitFrame[auraType]["auras"][i].countdown:SetShown(Config.AurasCountdown);
                unitFrame[auraType]["auras"][i].countdown:ClearAllPoints();
                if Config.AurasCountdownPosition == 1 then
                    unitFrame[auraType]["auras"][i].countdown:SetPoint("right", unitFrame[auraType]["auras"][i].second, "topRight", 5, -2.5);
                    unitFrame[auraType]["auras"][i].countdown:SetJustifyH("right");
                elseif Config.AurasCountdownPosition == 2 then
                    unitFrame[auraType]["auras"][i].countdown:SetPoint("center", unitFrame[auraType]["auras"][i].second, "center");
                    unitFrame[auraType]["auras"][i].countdown:SetJustifyH("center");
                end
            end
        end

        unitFrame.buffsCounter:SetScale(Config.AurasScale);
        unitFrame.debuffsCounter:SetScale(Config.AurasScale);
    end

    if nameplates then
        for k,v in pairs(nameplates) do
            if k and v.unitFrame.unit then
                local unitFrame = v.unitFrame;

                work(unitFrame, "buffs");
                work(unitFrame, "debuffs");
            end
        end
    end

    if data.nameplate then
        work(data.nameplate, "buffs");
        work(data.nameplate, "debuffs");
    end
end

local function updateNameplateScale()
    local function work()
        local nameplates = C_NamePlate.GetNamePlates();

        SetCVar("nameplateGlobalScale", Config.NameplatesScale);

        for k,v in pairs(nameplates) do
            if k then
                v.unitFrame.name:SetIgnoreParentScale(false);
                v.unitFrame.guild:SetIgnoreParentScale(false);

                v.unitFrame.name:SetScale(Config.LargeName and 0.95 or 0.75);
                v.unitFrame.guild:SetScale(Config.LargeGuildName and 0.95 or 0.75);

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
        SetCVar("nameplateMaxDistance", Config.MaxNameplateDistance);
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

-- Storing functions defined by config names
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
    AurasShow = function() updateAuras(); end,
    HidePassiveAuras = function() updateAuras(); end,
    AurasCountdown = function() updateAurasVisuals(); end,
    AurasReverseAnimation = function() updateAurasVisuals(); end,
    BuffsFriendly = function() updateAuras(); end,
    BuffsEnemy = function() updateAuras(); end,
    DebuffsEnemy = function() updateAuras(); end,
    DebuffsFriendly = function() updateAuras(); end,
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
                    v.unitFrame.buffsCounter:SetShown(Config.AurasOverFlowCounter);
                    v.unitFrame.debuffsCounter:SetShown(Config.AurasOverFlowCounter);
                end
            end
        end
    end,
    AurasSourcePersonal = function() func:Update_Auras("player"); end,
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
    CastbarScale = function() updateNameplateVisuals(); end,
    CastbarPositionY = function() updateNameplateVisuals(); end,
    ClassPowerScale = function() updateNameplateVisuals(); end,
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

    local function resetSettings(cfg, value)
        local frame = _G[value.frame];
        local default = value.default;
        local type = value.type;

        if value.type == "ColorPicker" then
            Config[cfg].r = default.r;
            Config[cfg].g = default.g;
            Config[cfg].b = default.b;
            Config[cfg].a = default.a;

            frame:SetVertexColor(
                default.r,
                default.g,
                default.b,
                default.a
            );
        elseif type == "CheckButton" then
            Config[cfg] = default;

            frame:SetChecked(default);
        elseif type == "Slider" then
            Config[cfg] = default;

            frame:SetValue(default);
        elseif type == "DropDownMenu" then
            Config[cfg] = default;

            frame:SetValue(default);
        end
    end

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
                    resetSettings(k,v);
                end
            end
        end,

        -- Reset Current Panel Settings
        OnAlt = function()
            for k,v in pairs(data.settings.configs.panels[panel.name]) do
                if k then
                    resetSettings(k,v);
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
function func:Create_CheckButton(panel, name, tooltip, cfg, default)
    local frameName = myAddon .. "_" .. panel.name .. "_CheckButton_" .. name;

    -- Adding Config
    if Config[cfg] == nil then
        Config[cfg] = default;
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
    frame_button:SetChecked(Config[cfg]);

    SetHoverScript(parent, highlight, name, tooltip);
    SetHoverScript(frame_button, highlight, name, tooltip);

    -- Update
    frame_button:SetScript("OnClick", function(self)
        Config[cfg] = self:GetChecked();
        updateSettings(cfg);
    end);

    -- Config table
    local config = {type = "CheckButton", frame = frameName, default = default};

    -- Adding config to a complete list of configs
    data.settings.configs.all[cfg] = config;

    -- Adding config to current category configs list
    data.settings.configs.panels[panel.name][cfg] = config;

    -- Adding frame to the settings list
    table.insert(panel.list, parent);
end

----------------------------------------
-- Create DropDown Menu
----------------------------------------
function func:Create_DropDownMenu(panel, name, tooltip, cfg, default, options)
    local frameName = myAddon .. "_" .. panel.name .. "_DropDownMenu_" .. name;

    -- Adding Config
    if Config[cfg] == nil then
        Config[cfg] = default;
    end

    local selection = Config[cfg];

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
        Config[cfg] = selection;

        -- Update
        updateSettings(cfg);
    end

    SetHoverScript(parent, highlight, name, tooltip);
    SetHoverScript(frame_menu, highlight, name, tooltip);

    -- Config table
    local config = {type = "DropDownMenu", frame = frameName, default = default};

    -- Adding config to a complete list of configs
    data.settings.configs.all[cfg] = config;

    -- Adding config to current category configs list
    data.settings.configs.panels[panel.name][cfg] = config;

    -- Adding frame to the settings list
    table.insert(panel.list, parent);
end

----------------------------------------
-- Create Slider
----------------------------------------
function func:Create_Slider(panel, name, tooltip, cfg, default, step, minValue, maxValue, decimals)
    local frameName = myAddon .. "_" .. panel.name .. "_Slider_" .. name;
    local format = "%." .. decimals .. "f";

    -- Adding Config
    if Config[cfg] == nil then
        Config[cfg] = default;
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
    frame_slider:SetValue(Config[cfg]);

    _G[frame_slider:GetName() .. "Low"]:SetText("");
    _G[frame_slider:GetName() .. "High"]:SetText("");

    local frame_Value = panel.scrollChild:CreateFontString(nil, "overlay", "GameFontNormal");
    frame_Value:SetPoint("left", frame_slider, "right", 8, 0);
    frame_Value:SetJustifyH("left");
    frame_Value:SetText(string.format(format, frame_slider:GetValue()));

    frame_slider:SetScript("OnValueChanged", function(self)
        frame_Value:SetText(string.format(format, self:GetValue()));
        Config[cfg] = self:GetValue();

        -- Update
        updateSettings(cfg);
    end);

    SetHoverScript(parent, highlight, name, tooltip);
    SetHoverScript(frame_slider, highlight, name, tooltip);

    -- Config table
    local config = {type = "Slider", frame = frameName, default = default};

    -- Adding config to a complete list of configs
    data.settings.configs.all[cfg] = config;

    -- Adding config to current category configs list
    data.settings.configs.panels[panel.name][cfg] = config;

    -- Adding frame to the settings list
    table.insert(panel.list, parent);
end

----------------------------------------
-- Create Color Picker
----------------------------------------
function func:Create_ColorPicker(panel, name, tooltip, cfg, default)
    local frameName = myAddon .. "_" .. panel.name .. "_ColorPicker_" .. name;

    -- Adding Config
    if Config[cfg] == nil then
        Config[cfg] = default;
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
        Config[cfg].r,
        Config[cfg].g,
        Config[cfg].b,
        Config[cfg].a
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

    -- Sasving new values
    local function saveColors(r,g,b,a)
        Config[cfg].r = r;
        Config[cfg].g = g;
        Config[cfg].b = b;
        Config[cfg].a = a;
    end

    local function showColorPicker(r,g,b,a,callback)
        ColorPickerFrame:Hide();
        ColorPickerFrame.hasOpacity = false;
        ColorPickerFrame.previousValues = {r,g,b,a};
        ColorPickerFrame.func, ColorPickerFrame.cancelFunc = callback, callback;
        ColorPickerFrame:SetColorRGB(r,g,b);
        ColorPickerFrame:Show();
    end

    frame_button.recolorTexture = function(color)
        local r,g,b,a;

        if color then
            r,g,b,a = color[1], color[2], color[3], color[4];
        else
            r,g,b = ColorPickerFrame:GetColorRGB();
            a = OpacitySliderFrame:GetValue();
        end

        -- Update
        frame_texture:SetVertexColor(r,g,b,a);
        saveColors(r,g,b,a);
        updateSettings(cfg);
    end

    frame_button:SetScript("OnClick", function(self)
        local r,g,b,a = frame_texture:GetVertexColor();

        showColorPicker(r,g,b,a, self.recolorTexture);
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
        saveColors(default.r, default.g, default.b, default.a);
        frame_texture:SetVertexColor(
            Config[cfg].r,
            Config[cfg].g,
            Config[cfg].b,
            Config[cfg].a
        );
        updateSettings(cfg);
    end);

    SetHoverScript(parent, highlight, name, tooltip);
    SetHoverScript(frame_button, highlight, name, tooltip, frame_border);
    SetHoverScript(frame_reset, highlight, name, tooltip);

    -- Config table
    local config = {type = "ColorPicker", frame = frameName, default = default};

    -- Adding config to a complete list of configs
    data.settings.configs.all[cfg] = config;

    -- Adding config to current category configs list
    data.settings.configs.panels[panel.name][cfg] = config;

    -- Adding frame to the settings list
    table.insert(panel.list, parent);
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
    -- Adding Config
    if Config[cfg] == nil then
        Config[cfg] = {};
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
        local spellName = GetSpellInfo(input);

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
        for k in pairs(Config[cfg]) do
            if k then
                local spellName, _, icon = GetSpellInfo(k);

                if spellName then
                    sorter[spellName] = { icon = icon, id = k };
                    data.settings[cfg][spellName] = 1;
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
                    Config[cfg][v.id] = nil;

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
        local added, status = addSpell(Config[cfg], self:GetText());

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
        local added, status = addSpell(Config[cfg], frame_EditBox:GetText());

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
                    local added, status = addSpell(Config[cfg], v);

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

        for k,v in pairs(Config[cfg]) do
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
            Config[cfg] = {};

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