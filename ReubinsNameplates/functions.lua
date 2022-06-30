----------------------------------------
-- NAMESPACES
----------------------------------------
local myAddon, core = ...
core.func = {};
core.frames = { nameplates = {}, strata = {}, threat = {}, health = {}, auras = {}, tanks = {}, members = {}, combat = UnitAffectingCombat("player") };
local func = core.func;
local frames = core.frames;
local aura_size = 32;

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
-- THREAT VISIBILITY TOGGLE
----------------------------------------
function func:Threat_Toggle()
    if frames.combat then
        if ReubinsNameplates_settings.Threat_Visibility == "Always" then
            return true;
        elseif ReubinsNameplates_settings.Threat_Visibility == "Solo" and not IsInGroup() then
            return true;
        elseif ReubinsNameplates_settings.Threat_Visibility == "Party & Raid" and IsInGroup() then
            return true;
        elseif ReubinsNameplates_settings.Threat_Visibility == "Never" then
            return false;
        else
            return false
        end
    else
        return false;
    end
end

----------------------------------------
-- THREAT ICON TOGGLE
----------------------------------------
function func:Threat_Icon_Toggle()
    if not ReubinsNameplates_settings.Tank then
        return "Interface\\addons\\ReubinsNameplates\\media\\aggro";
    else
        return "Interface\\addons\\ReubinsNameplates\\media\\tanking";
    end
end

----------------------------------------
-- ASSIGN TANKS
----------------------------------------
function func:Roster_Update()
    if IsInGroup() then
        frames.tanks = {}; -- Reseting table
        for i = 1, GetNumGroupMembers() do
            frames.members["raid"..i] = UnitName("raid"..i);

            if GetPartyAssignment("MainTank" ,"raid"..i, true) then
                if not UnitIsUnit("raid"..i, "player") then
                    local unit = UnitName("raid"..i);
                    frames.tanks[unit] = UnitName(unit);
                end
            end
        end
    end
end

----------------------------------------
-- FIND AURAS
----------------------------------------
function func:Find_Auras(unit)
    for i = 1, 40 do
        local name, icon, count, debuffType, duration, expirationTime, source, _, _, spellId, _, _, _, _, timeMod = UnitAura(unit, i, "HARMFUL");

        if source then
            if UnitIsUnit(source, "player") then
                frames.found_auras[i] = { name = name, icon = icon, count = count, debuffType = debuffType, duration = duration, expirationTime = expirationTime, spellId = spellId, timeMod = timeMod };
            end
        else
            break
        end
    end
end

----------------------------------------
-- COUNT STACKS
----------------------------------------
function func:Count_Stacks(count)
    if count then
        if count > 0 then
            return "x"..count
        else
            return ""
        end
    end
end

----------------------------------------
-- CONVEWRT SECONDS TO TIME
----------------------------------------
function func:Time(seconds)
    if seconds >= 3600 then
        return math.floor(seconds / 3600 + 0.5) .. "h"
    elseif seconds >= 60 then
        return math.floor(seconds / 60 + 0.5) .. "m"
    elseif seconds < 60 and seconds > 5 then
        return math.floor(seconds)
    else
        return string.format("%.1f", seconds)
    end
end


----------------------------------------
-- POSITION AURAS
----------------------------------------
function func:Position_Aura(unit, i)
    local ui = unit.."_"..i;
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit);
    local calc = -(i - 1) * aura_size / 2;

    if i == 1 then
        frames.auras[ui]["parent"]:SetPoint("BOTTOM", nameplate, "TOP", 0, 2);
    elseif i > 1 and i <= 5 then
        frames.auras[unit.."_"..1]["parent"]:SetPoint("BOTTOM", nameplate, "TOP", calc, 2);
        frames.auras[ui]["parent"]:SetPoint("LEFT", frames.auras[unit.."_"..(i - 1)]["parent"], "RIGHT", 0, 0);
    elseif i == 6 then
        frames.auras[ui]["parent"]:SetPoint("BOTTOM", nameplate, "TOP", 0, 24);
    elseif i > 6 and i <= 10 then
        frames.auras[unit.."_"..6]["parent"]:SetPoint("BOTTOM", nameplate, "TOP", calc, 24);
        frames.auras[ui]["parent"]:SetPoint("LEFT", frames.auras[unit.."_"..(i - 1)]["parent"], "RIGHT", 0, 24);
    elseif i == 11 then
        frames.auras[ui]["parent"]:SetPoint("BOTTOM", nameplate, "TOP", 0, 48);
    elseif i > 11 and i <= 15 then
        frames.auras[unit.."_"..11]["parent"]:SetPoint("BOTTOM", nameplate, "TOP", calc, 48);
        frames.auras[ui]["parent"]:SetPoint("LEFT", frames.auras[unit.."_"..(i - 1)]["parent"], "RIGHT", 0, 48);
    end
end

----------------------------------------
-- HIDING BLIZZARD'S NAMEPLATES
----------------------------------------
--[[
function func:Hide_Blizzard()
    local f = CreateFrame("Frame");

    NamePlateDriverFrame:UnregisterAllEvents();
    NamePlateDriverFrame:Hide();
    NamePlateDriverFrame.UpdateNamePlateOptions = f.UpdateNamePlateOptions;
end
]]

----------------------------------------
-- CREATING NAMEPLATE
----------------------------------------
--[[
function func:Create_Nameplate(nameplate)
    -- Do stuff
end
]]

----------------------------------------
-- ADDING NAMEPLATES
----------------------------------------
function func:Add_Nameplate(unit)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

    if not UnitIsPlayer(unit) and not UnitIsOtherPlayersPet(unit) then
        local f = CreateFrame("Frame", nil, UIParent);

        -- Health bar
        -- local unitFrame = CreateFrame("Button", nameplate:GetName().."UnitFrame", nameplate);

        -- Strata
        if not frames.strata[unit] then
            f.Strata = CreateFrame("Frame", nil, nameplate);
            f.Strata:SetFrameStrata("DIALOG");
            frames.strata[unit] = f.Strata;
        else
            frames.strata[unit]:SetParent(nameplate);
            frames.strata[unit]:Show();
        end

        -- Threat icon
        if not frames.threat[unit] then
            f.Threat = f:CreateTexture(nil, "ARTWORK");
            f.Threat:SetParent(nameplate);
            f.Threat:SetPoint("LEFT", nameplate, "RIGHT", -1, -7);
            f.Threat:SetTexture(func:Threat_Icon_Toggle());
            f.Threat:SetSize(22, 22);
            f.Threat:SetShown(func:Threat_Toggle());
            frames.threat[unit] = f.Threat;
            func:Update_Threat(unit); -- Checking threat
        else
            frames.threat[unit]:SetParent(nameplate);
            frames.threat[unit]:SetPoint("LEFT", nameplate, "RIGHT", -1, -7);
            frames.threat[unit]:SetTexture(func:Threat_Icon_Toggle());
            frames.threat[unit]:SetShown(func:Threat_Toggle());
            func:Update_Threat(unit); -- Checking threat
        end

        -- Health numbers
        if not frames.health[unit] then
            f.Health = f:CreateFontString(nil, "OVERLAY");
            f.Health:SetPoint("CENTER", nameplate, "CENTER", 0, -7);
            f.Health:SetParent(frames.strata[unit]);
            f.Health:SetFont("Fonts\\FRIZQT__.TTF", ReubinsNameplates_settings.FontSize, "OUTLINE");
            f.Health:SetTextColor(1, 0.99, 0.32);
            f.Health:SetShadowColor(0, 0, 0, 1);
            f.Health:SetShadowOffset(1, -1);
            f.Health:SetText(format_number(UnitHealth(unit)));
            f.Health:SetShown(ReubinsNameplates_settings.Show_Health);
            frames.health[unit] = f.Health;
        else
            frames.health[unit]:SetPoint("CENTER", nameplate, "CENTER", 0, -7);
            frames.health[unit]:SetParent(frames.strata[unit]);
            frames.health[unit]:SetText(format_number(UnitHealth(unit)));
            frames.health[unit]:SetShown(ReubinsNameplates_settings.Show_Health);
        end
    end

    -- Auras
    func:Update_Auras(unit)
end

----------------------------------------
-- HIDDING NAMEPLATES
----------------------------------------
function func:Remove_Nameplate(unit)

    -- Strata
    if frames.strata[unit] then
        frames.strata[unit]:Hide();
        frames.strata[unit]:ClearAllPoints();
    end

    -- Threat icons
    if frames.threat[unit] then
        frames.threat[unit]:Hide();
        frames.threat[unit]:ClearAllPoints();
        frames.threat[unit]:SetVertexColor(0, 0, 0, 0);
    end

    -- Health numbers
    if frames.health[unit] then
        frames.health[unit]:Hide();
        frames.health[unit]:ClearAllPoints();
    end

    -- Auras
    for key, ui in pairs(frames.auras) do
        if string.match(key, unit) then
            if ui.parent:IsShown() then
                ui.parent:Hide();
                ui.parent:ClearAllPoints();
            end
        end
    end
end

----------------------------------------
-- UPDATING DATA
----------------------------------------

-- Health
function func:Update_Health(unit)
    if frames.health[unit] then
        frames.health[unit]:SetText(format_number(UnitHealth(unit)));
        frames.health[unit]:Show();
    end
end

-- Threat
function func:Update_Threat(unit)
    if frames.threat[unit] then
        local tank, status, threat = UnitDetailedThreatSituation("player", unit);

        if not ReubinsNameplates_settings.Tank then
            if not tank then
                if threat then
                    if threat < 50 then
                        frames.threat[unit]:SetVertexColor(0, 0, 0, 0); -- Transparent
                    end
                    if threat >= 50 then
                        frames.threat[unit]:SetVertexColor(1.0, 0.94, 0.0, 1); -- Yellow
                    end
                    if threat >= 75 then
                        frames.threat[unit]:SetVertexColor(0.96, 0.58, 0.11, 1); -- Orange
                    end
                else
                    frames.threat[unit]:SetVertexColor(0, 0, 0, 0); -- Transparent
                end
            else
                frames.threat[unit]:SetVertexColor(1, 0, 0, 1); -- Red
            end
        else
            if not UnitExists(unit.."target") then
                frames.threat[unit]:SetVertexColor(0, 0, 0, 0); -- Transparent
            else
                if not tank then
                    if IsInGroup() then
                        if frames.tanks[UnitName(unit.."target")] then
                            frames.threat[unit]:SetVertexColor(0.08, 0.66, 0.98, 1); -- Blue    
                        else
                            if UnitPlayerOrPetInParty(unit.."target") or UnitInParty(unit.."target") then
                                frames.threat[unit]:SetVertexColor(1, 0, 0, 1); -- Red
                            else
                                frames.threat[unit]:SetVertexColor(0, 0, 0, 0); -- Transparent
                            end
                        end
                    else
                        frames.threat[unit]:SetVertexColor(1, 0, 0, 1); -- Red
                    end
                else
                    if status == 2 then -- Tanking but not highest
                        frames.threat[unit]:SetVertexColor(0.96, 0.58, 0.11, 1); -- Orange
                    elseif status == 3 then -- Tanking securly
                        frames.threat[unit]:SetVertexColor(0, 1, 0, 1); -- Green
                    else
                        frames.threat[unit]:SetVertexColor(0, 0, 0, 0); -- Transparent
                    end
                end
            end
        end
    end
end

-- Auras
function func:Update_Auras(unit)
    -- Hiding countdowns
    for _, ui in pairs(frames.auras) do
        if ui.cooldown:GetCooldownDuration() == 0 then
            ui.parent:Hide();
            ui.parent:ClearAllPoints();
        end
    end

    if frames.strata[unit] then
        if frames.strata[unit]:IsShown() then
            local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

            for i = 1, 40 do
                local name, icon, count, debuffType, duration, expirationTime, source, _, _, spellId, _, _, _, _, timeMod = UnitAura(unit, i, "PLAYER|HARMFUL");

                if name then
                    local ui = unit.."_"..i;

                    if not frames.auras[ui] then
                        frames.auras[ui] = {};

                        -- Aura
                        local f = CreateFrame("Frame", nil, nameplate);
                        f:SetSize(aura_size, aura_size);
                        f:SetScale(ReubinsNameplates_settings.auras_scale);
                        f:SetShown(ReubinsNameplates_settings.Auras_Visibility);
                        frames.auras[ui]["parent"] = f;

                        -- Mask
                        f.mask = f:CreateMaskTexture();
                        f.mask:SetAllPoints(f);
                        f.mask:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\aura_mask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE");

                        -- Icon
                        f.icon = f:CreateTexture(nil, "ARTWORK");
                        f.icon:SetParent(f);
                        f.icon:SetAllPoints();
                        f.icon:SetTexture(icon);
                        f.icon:AddMaskTexture(f.mask);
                        f.icon:Show();
                        frames.auras[ui]["icon"] = f.icon;

                        -- Border
                        f.border = f:CreateTexture(nil, "OVERLAY");
                        f.border:SetParent(f);
                        f.border:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\aura_border");
                        f.border:SetVertexColor(0.85, 0.85, 0.15, 1);
                        f.border:SetAllPoints();
                        f.border:Show();
                        frames.auras[ui]["border"] = f.border;

                        -- Fonts strata
                        f.Fonts_Strata = CreateFrame("Frame", nil, f);
                        f.Fonts_Strata:SetFrameStrata("HIGH");
                        frames.auras[ui]["fonts_strata"] = f.Fonts_Strata;

                        -- Stacks
                        f.Stacks = f:CreateFontString(nil, "OVERLAY");
                        f.Stacks:SetParent(f.Fonts_Strata);
                        f.Stacks:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -4, 6);
                        f.Stacks:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE");
                        f.Stacks:SetTextColor(1, 0.99, 0.32);
                        f.Stacks:SetShadowColor(0, 0, 0, 1);
                        f.Stacks:SetShadowOffset(1, -1);
                        f.Stacks:SetText(func:Count_Stacks(count));
                        f.Stacks:Show();
                        frames.auras[ui]["stacks"] = f.Stacks;

                        -- Countdown
                        f.Countdown = f:CreateFontString(nil, "OVERLAY");
                        f.Countdown:SetParent(f.Fonts_Strata);
                        f.Countdown:SetPoint("CENTER", f, "CENTER");
                        f.Countdown:SetFont("Fonts\\FRIZQT__.TTF", ReubinsNameplates_settings.auras_scale * 12, "OUTLINE");
                        f.Countdown:SetTextColor(1, 0.99, 0.32);
                        f.Countdown:SetShadowColor(0, 0, 0, 1);
                        f.Countdown:SetShadowOffset(1, -1);
                        f.Countdown:SetShown(ReubinsNameplates_settings.Auras_Countdown);
                        frames.auras[ui]["countdown"] = f.Countdown;

                        -- Cooldown
                        f.Cooldown = CreateFrame("Cooldown", nil, f, "CooldownFrameTemplate");
                        f.Cooldown:SetAllPoints();
                        f.Cooldown:SetCooldown(GetTime() - (duration - (expirationTime - GetTime())), duration, timeMod);
                        f.Cooldown:SetDrawEdge(false);
                        f.Cooldown:SetDrawBling(false);
                        f.Cooldown:SetSwipeTexture("Interface\\addons\\ReubinsNameplates\\media\\aura_mask");
                        f.Cooldown:SetSwipeColor(0, 0, 0, 0.60);
                        f.Cooldown:SetHideCountdownNumbers(true);
                        f.Cooldown:Show();
                        frames.auras[ui]["cooldown"] = f.Cooldown;

                        -- Position auras
                        func:Position_Aura(unit, i);
                    else
                        local parent = frames.auras[ui]["parent"];
                        local aura_icon = frames.auras[ui]["icon"];
                        local stacks = frames.auras[ui]["stacks"];
                        local fonts_strata = frames.auras[ui]["fonts_strata"];
                        local countdown = frames.auras[ui]["countdown"];
                        local border = frames.auras[ui]["border"];
                        local cooldown = frames.auras[ui]["cooldown"];

                        -- Aura
                        parent:SetParent(nameplate);
                        parent:SetScale(ReubinsNameplates_settings.Auras_Scale);
                        parent:SetShown(ReubinsNameplates_settings.Auras_Visibility);

                        -- Icon
                        aura_icon:SetParent(parent);
                        aura_icon:SetAllPoints();
                        aura_icon:SetTexture(icon);
                        aura_icon:Show();

                        -- Fonts strata
                        fonts_strata:SetParent(parent);

                        -- Stacks
                        stacks:SetParent(frames.auras[ui]["fonts_strata"]);
                        stacks:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -4, 6);
                        stacks:SetText(func:Count_Stacks(count));
                        stacks:Show();

                        -- Countdown
                        countdown:SetText(expirationTime - GetTime());
                        countdown:SetPoint("CENTER", parent, "CENTER");
                        countdown:SetText(func:Time(expirationTime - GetTime()));
                        countdown:SetShown(ReubinsNameplates_settings.Auras_Countdown);

                        -- Border
                        border:SetParent(parent);
                        border:SetAllPoints();
                        border:Show();

                        -- Cooldown
                        cooldown:SetParent(parent);
                        cooldown:SetAllPoints();
                        cooldown:SetCooldown(GetTime() - (duration - (expirationTime - GetTime())), duration, timeMod);
                        cooldown:Show();

                        -- Position auras
                        func:Position_Aura(unit, i);
                    end

                    -- Scripts
                    local timeElapsed = 0;

                    frames.auras[unit.."_"..i]["parent"]:SetScript("OnUpdate", function(self, elapsed)
                        timeElapsed = timeElapsed + elapsed;

                        if timeElapsed > 0.1 then
                            timeElapsed = 0;
                            frames.auras[unit.."_"..i]["countdown"]:SetText(func:Time(expirationTime - GetTime()));
                        end
                    end);

                elseif frames.auras[unit.."_"..i] then
                    frames.auras[unit.."_"..i]["parent"]:Hide();
                    frames.auras[unit.."_"..i]["parent"]:ClearAllPoints();
                else
                    break
                end
            end
        end
    end
end