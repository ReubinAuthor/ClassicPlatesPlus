----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

-- Colors
local yellow = "|cff" .. "ffd100";
local white  = "|cff" .. "ffffff";
local green  = "|cff" .. "7CFC00";

-- Panels table
data.settings = {
    panels = {}, -- Table that will store panels for initialization
    configs = {
        all = {}, -- Table that will contain complete list of configs
        panels = {} -- Table for panels settings
    }
};

-- Creating Config table if it doesn't exist
Config = Config or {};

----------------------------------------
-- Loading Settings
----------------------------------------
function func:Load_Settings()
    -- MAIN PANEL
    -- Fist panel has to be accessable to other panels, putting it outside of the code block.
    local panelMain = func:CreatePanel(nil, myAddon);

    do
        -- Renaming the main panel so that we can easily copy/paste elements between panels
        local panel = panelMain;

        -- Sub-Category
        func:Create_SubCategory(panel, "General");

        -- CheckButton
        do
            local name = "Personal Nameplate";
            local tooltip = not data.isRetail and "To move the personal nameplate, hold " .. green .. "CTRL" .. yellow .. " and drag it with " .. green .. "Left Mouse Button" or "";
            local cfg = "PersonalNameplate";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = false };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Portrait";
            local tooltip = "";
            local cfg = "Portrait";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Friendly Players Class Icons";
            local tooltip = "";
            local cfg = "ClassIconsFriendly";
            local default = false;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Enemy Players Class Icons";
            local tooltip = "";
            local cfg = "ClassIconsEnemy";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Level";
            local tooltip = "";
            local cfg = "ShowLevel";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Guild Name";
            local tooltip = "";
            local cfg = "ShowGuildName";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Name & Guild Outline";
            local tooltip = "";
            local cfg = "NameAndGuildOutline";
            local default = false;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Large Name";
            local tooltip = "";
            local cfg = "LargeName";
            local default = false;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Large Guild Name";
            local tooltip = "";
            local cfg = "LargeGuildName";
            local default = false;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Classification";
            local tooltip = "Creature class: " .. white .. "Elite, Rare, Rare Elite, World Boss";
            local cfg = "Classification";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Fade Unselected Targets";
            local tooltip = "";
            local cfg = "FadeUnselected";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Slider
        do
            local name = "Fade Intensity";
            local tooltip = "";
            local cfg = "FadeIntensity";
            local default = 0.5;
            local step = 0.01;
            local minValue = 0.0;
            local maxValue = 1.0;
            local decimals = 2;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Nameplates Scale";
            local tooltip = "Must be out of combat for the effect to take place";
            local cfg = "NameplatesScale";
            local default = 1.00;
            local step = 0.01;
            local minValue = 0.75;
            local maxValue = 1.25;
            local decimals = 2;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Personal Nameplates Scale";
            local tooltip = "";
            local cfg = "PersonalNameplatesScale";
            local default = 1.00;
            local step = 0.01;
            local minValue = 0.75;
            local maxValue = 1.25;
            local decimals = 2;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Max Nameplate Distance";
            local tooltip = "Must be out of combat for the effect to take place";
            local cfg = "MaxNameplateDistance";
            local default = 60;
            local step = 1;
            local minValue = 10;
            local maxValue = 60;
            local decimals = 0;
            local flair = { classicEra = false, wrath = false, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Castbar Scale";
            local tooltip = "";
            local cfg = "CastbarScale";
            local default = 1;
            local step = 0.01;
            local minValue = 0.75;
            local maxValue = 1.25;
            local decimals = 2;
            local flair = { classicEra = false, wrath = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Castbar Position";
            local tooltip = "";
            local cfg = "CastbarPositionY";
            local default = 0;
            local step = 1;
            local minValue = 0;
            local maxValue = 50;
            local decimals = 0;
            local flair = { classicEra = false, wrath = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Class Power Scale";
            local tooltip = "Class power: " .. white .. "Combo Points, Runes, Totems";
            local cfg = "ClassPowerScale";
            local default = 1;
            local step = 0.01;
            local minValue = 0.50;
            local maxValue = 1.50;
            local decimals = 2;
            local flair = { classicEra = true, wrath = true, retail = false };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Health & Power");

        -- CheckButton
        do
            local name = "Power Bar";
            local tooltip = "";
            local cfg = "Powerbar";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Frienly Healthbar Class Colors";
            local tooltip = "";
            local cfg = "HealthBarClassColorsFriendly";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Enemy Healthbar Class Colors";
            local tooltip = "";
            local cfg = "HealthBarClassColorsEnemy";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Numeric Value";
            local tooltip = "Dispaly health and power numeric values";
            local cfg = "NumericValue";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Percentage Value";
            local tooltip = "Dispaly Health and Power percentage values";
            local cfg = "Percentage";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Switch Values Positions";
            local tooltip = "Swap positions of numeric and percentage values";
            local cfg = "PercentageAsMainValue";
            local default = false;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Total Health";
            local tooltip = "Display Total amount of your health\n(Displayed on personal nameplate only)";
            local cfg = "PersonalNameplateTotalHealth";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Total Power";
            local tooltip = "Display Total amount of your power\n" .. white .. "Example: " .. yellow .. "Mana, Rage, Energy, etc...\n(Displayed on personal nameplate only)";
            local cfg = "PersonalNameplateTotalPower";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Large Main Health Value";
            local tooltip = "";
            local cfg = "LargeMainValue";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Font Color";
            local tooltip = "";
            local cfg = "HealthFontColor";
            local default = {r = 1, g = 0.82, b = 0, a = 1};
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Threat");

        -- CheckButton
        do
            local name = "Threat Percentage";
            local tooltip = "Display the amount of threat generated";
            local cfg = "ThreatPercentage";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Highlight";
            local tooltip = "Highlight nameplates depending on threat situation";
            local cfg = "ThreatHighlight";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Slider
        do
            local name = "Threat Warning Threshold";
            local tooltip = "";
            local cfg = "ThreatWarningThreshold";
            local default = 75;
            local step = 1;
            local minValue = 1;
            local maxValue = 100;
            local decimals = 0;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- ColorPicker
        do
            local name = "Warning Color";
            local tooltip = "";
            local cfg = "ThreatWarningColor";
            local default = {r = 1, g = 0.6, b = 0, a = 1};
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Aggro Color";
            local tooltip = "";
            local cfg = "ThreatAggroColor";
            local default = {r = 1, g = 0, b = 1, a = 1};
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Other Tank Color";
            local tooltip = "Color for when another tank is tanking";
            local cfg = "ThreatOtherTankColor";
            local default = {r = 0, g = 0.58, b = 1, a = 1};
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- Spacer
        func:Create_Spacer(panel);

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- CATEGORY: Buffs & Debuffs
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "Buffs & Debuffs");

        -- Sub-Category
        func:Create_SubCategory(panel, "General");

        -- DropDownMenu
        do
            local name = "Auras Source";
            local tooltip = white .. "You: " .. yellow .. "Show auras applied by you\n".. white .. "All: " .. yellow .. "Show all auras";
            local cfg = "AurasShow";
            local default = 1;
            local options = {
                [1] = "You",
                [2] = "All"
            }
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_DropDownMenu(panel, flair, name, tooltip, cfg, default, options);
        end

        -- CheckButton
        do
            local name = "Hide Passive Auras";
            local tooltip = "Hide auras without expiration time";
            local cfg = "HidePassiveAuras";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Show Countdown";
            local tooltip = "";
            local cfg = "AurasCountdown";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- DropDownMenu
        do
            local name = "Countdown position";
            local tooltip = "";
            local cfg = "AurasCountdownPosition";
            local default = 1;
            local options = {
                [1] = "Top Right",
                [2] = "Center"
            }
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_DropDownMenu(panel, flair, name, tooltip, cfg, default, options);
        end

        -- CheckButton
        do
            local name = "Reverse Cooldown Swipe Animation";
            local tooltip = "";
            local cfg = "AurasReverseAnimation";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Show Buffs on Friendlies";
            local tooltip = "";
            local cfg = "BuffsFriendly";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Show Debuffs on Friendlies";
            local tooltip = "";
            local cfg = "BuffsEnemy";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Show Buffs on Enemies";
            local tooltip = "";
            local cfg = "DebuffsEnemy";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Show Debuffs on Enemies";
            local tooltip = "";
            local cfg = "DebuffsFriendly";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Slider
        do
            local name = "Max Buffs on Friendlies";
            local tooltip = "";
            local cfg = "AurasMaxBuffsFriendly";
            local default = 4;
            local step = 1;
            local minValue = 1;
            local maxValue = 16;
            local decimals = 0;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Max Debuffs on Friendlies";
            local tooltip = "";
            local cfg = "AurasMaxDebuffsFriendly";
            local default = 2;
            local step = 1;
            local minValue = 1;
            local maxValue = 16;
            local decimals = 0;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Max Buffs on Enemies";
            local tooltip = "";
            local cfg = "AurasMaxBuffsEnemy";
            local default = 2;
            local step = 1;
            local minValue = 1;
            local maxValue = 16;
            local decimals = 0;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Max Debuffs on Enemies";
            local tooltip = "";
            local cfg = "AurasMaxDebuffsEnemy";
            local default = 4;
            local step = 1;
            local minValue = 1;
            local maxValue = 16;
            local decimals = 0;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Auras Scale";
            local tooltip = "";
            local cfg = "AurasScale";
            local default = 1.00
            local step = 0.01;
            local minValue = 0.75;
            local maxValue = 1.25;
            local decimals = 2;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- CheckButton
        do
            local name = "Auras Overflow Counter";
            local tooltip = "";
            local cfg = "AurasOverFlowCounter";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Personal Auras");

        -- DropDownMenu
        do
            local name = "Buffs Source";
            local tooltip = white .. "You: " .. yellow .. "Show buffs applied by you\n".. white .. "All: " .. yellow .. "Show buffs applied by anyone";
            local cfg = "AurasSourcePersonal";
            local default = 1;
            local options = {
                [1] = "You",
                [2] = "All"
            }
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_DropDownMenu(panel, flair, name, tooltip, cfg, default, options);
        end

        -- CheckButton
        do
            local name = "Show Buffs";
            local tooltip = "";
            local cfg = "BuffsPersonal";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Show Debuffs";
            local tooltip = "";
            local cfg = "DebuffsPersonal";
            local default = true;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Slider
        do
            local name = "Max Buffs";
            local tooltip = "";
            local cfg = "AurasPersonalMaxBuffs";
            local default = 6;
            local step = 1;
            local minValue = 1;
            local maxValue = 16;
            local decimals = 0;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Max Debuffs";
            local tooltip = "";
            local cfg = "AurasPersonalMaxDebuffs";
            local default = 6;
            local step = 1;
            local minValue = 1;
            local maxValue = 16;
            local decimals = 0;
            local flair = { classicEra = true, wrath = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Spacer
        func:Create_Spacer(panel);

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- CATEGORY: Important Auras
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "Important Auras");

        -- Spacer
        func:Create_Spacer(panel);

        -- Auras List
        do
            local name = "Important Auras";
            local cfg = "AurasImportantList";

            func:Create_AurasList(panel, name, cfg);
        end

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- CATEGORY: Blacklisted Auras
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "Blacklisted Auras");

        -- Spacer
        func:Create_Spacer(panel);

        -- Auras List
        do
            local name = "Blacklisted Auras";
            local cfg = "AurasBlacklist";

            func:Create_AurasList(panel, name, cfg);
        end

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- Adding panels
    for k,v in ipairs(data.settings.panels) do
        if k then
            InterfaceOptions_AddCategory(v);
        end
    end
end