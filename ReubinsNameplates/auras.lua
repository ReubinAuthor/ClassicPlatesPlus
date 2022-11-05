----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- Auras
----------------------------------------
function func:Update_Auras(unit)
    if unit and string.match(unit, "nameplate") then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);
        local auraSizeX, auraSizeY = 28, 24;
        local auraWidth = auraSizeX + 6;

        -- Formating seconds
        local function getCountdown(seconds)
            if seconds > 0 then
                if seconds >= 3600 then
                    return math.floor(seconds / 3600 + 0.5) .. "h";
                elseif seconds > 60 then
                    return math.floor(seconds / 60 + 0.5) .. "m";
                else
                    return math.floor(seconds + 0.9999999);
                end
            else
                return "";
            end
        end

        if nameplate then
            local unitFrame = nameplate.unitFrame;
            unitFrame.auras.sorted = {};

            for i = 1, 40 do

                -- Setting up a filter for buffs and debuffs
                local auraType;
                if UnitCanAttack("player", unit) then
                    auraType = "harmful";
                else
                    auraType = "helpful";
                end

                local UnitAura = _G.UnitAura;

                if data.isClassic then
                    local LibClassicDurations = LibStub("LibClassicDurations", true)

                    if LibClassicDurations then
                        LibClassicDurations:Register(myAddon);
                        UnitAura = LibClassicDurations.UnitAuraWrapper;
                    end
                end

                -- Grabbing auras
                local name, icon, stacks, _, duration, expirationTime, _, _, _, spellID, _, _, _, _, timeMod = UnitAura(unit, i, "PLAYER|" .. auraType);
                local toggle;

                if auraType == "helpful" then
                    if ReubinsNameplates_settings.AurasBuffs then
                        toggle = true;
                    else
                        toggle = false;
                    end
                elseif auraType == "harmful" then
                    if ReubinsNameplates_settings.AurasDebuffs then
                        toggle = true;
                    else
                        toggle = false;
                    end
                end

                -- Aura found
                if name and toggle then
                    if not ReubinsNameplates_settings.AurasBlacklist[spellID] then
                        if not unitFrame.auras[i] then
                            -- Auras frame
                            unitFrame.auras[i] = CreateFrame("frame");
                            unitFrame.auras[i]:SetParent(unitFrame);
                            unitFrame.auras[i]:SetSize(auraWidth, auraSizeY);
                            unitFrame.auras[i]:SetFrameLevel(1);
                            unitFrame.auras[i]:SetScale(ReubinsNameplates_settings.AurasScale);

                            -- Auras main
                            unitFrame.auras[i].main = CreateFrame("button");
                            unitFrame.auras[i].main:SetParent(unitFrame.auras[i]);
                            unitFrame.auras[i].main:SetPoint("center", unitFrame.auras[i], "center");
                            unitFrame.auras[i].main:SetSize(auraSizeX, auraSizeY);
                            unitFrame.auras[i].main:SetFrameLevel(1);
                            unitFrame.auras[i].main:EnableMouse(false);

                            -- Fonts strata
                            unitFrame.auras[i].strata = CreateFrame('frame');
                            unitFrame.auras[i].strata:SetParent(unitFrame.auras[i].main);
                            unitFrame.auras[i].strata:SetFrameLevel(3);

                            -- Auras border
                            unitFrame.auras[i].border = unitFrame.auras[i].main:CreateTexture();
                            unitFrame.auras[i].border:SetParent(unitFrame.auras[i].main);
                            unitFrame.auras[i].border:SetPoint("center", unitFrame.auras[i].main, "center");
                            unitFrame.auras[i].border:SetDrawLayer("border", 1);
                            unitFrame.auras[i].border:SetVertexColor(0.85, 0.85, 0.85);
                            unitFrame.auras[i].border:SetSize(64, 64);

                            -- Mask
                            unitFrame.auras[i].mask = unitFrame.auras[i].main:CreateMaskTexture();
                            unitFrame.auras[i].mask:SetParent(unitFrame.auras[i].main);
                            unitFrame.auras[i].mask:SetAllPoints();
                            unitFrame.auras[i].mask:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\auras\\aurasMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE");

                            -- Auras icon
                            unitFrame.auras[i].icon = unitFrame.auras[i].main:CreateTexture();
                            unitFrame.auras[i].icon:SetSize(32, 32);
                            unitFrame.auras[i].icon:SetParent(unitFrame.auras[i].main);
                            unitFrame.auras[i].icon:SetPoint("center", unitFrame.auras[i].main, "center");
                            unitFrame.auras[i].icon:SetDrawLayer("background", 1);
                            unitFrame.auras[i].icon:SetTexture(icon);
                            unitFrame.auras[i].icon:AddMaskTexture(unitFrame.auras[i].mask);

                            -- Auras countdown
                            unitFrame.auras[i].countdown = unitFrame.auras[i].main:CreateFontString();
                            unitFrame.auras[i].countdown:SetParent(unitFrame.auras[i].strata);
                            unitFrame.auras[i].countdown:SetPoint("center", unitFrame.auras[i].main, "center");
                            unitFrame.auras[i].countdown:SetFont("Fonts\\FRIZQT__.TTF", 12, "outline");
                            unitFrame.auras[i].countdown:SetShadowColor(0, 0, 0);
                            unitFrame.auras[i].countdown:SetShadowOffset(1, -1);
                            unitFrame.auras[i].countdown:SetTextColor(1, 0.82, 0);
                            unitFrame.auras[i].countdown:SetText(getCountdown(expirationTime - GetTime()));
                            unitFrame.auras[i].countdown:SetShown(ReubinsNameplates_settings.AurasCountdown);

                            -- Auras cooldown
                            unitFrame.auras[i].cooldown = CreateFrame("Cooldown", nil, nil, "CooldownFrameTemplate");
                            unitFrame.auras[i].cooldown:SetParent(unitFrame.auras[i].main);
                            unitFrame.auras[i].cooldown:SetAllPoints();
                            unitFrame.auras[i].cooldown:SetCooldown(GetTime() - (duration - (expirationTime - GetTime())), duration, timeMod);
                            unitFrame.auras[i].cooldown:SetDrawEdge(true);
                            unitFrame.auras[i].cooldown:SetDrawBling(false);
                            unitFrame.auras[i].cooldown:SetSwipeColor(0, 0, 0, 0.6);
                            unitFrame.auras[i].cooldown:SetHideCountdownNumbers(true);
                            unitFrame.auras[i].cooldown:SetReverse(ReubinsNameplates_settings.AurasReverseAnimation);
                            unitFrame.auras[i].cooldown:SetFrameLevel(2);

                            -- Auras stacks
                            unitFrame.auras[i].stacks = unitFrame.auras[i].main:CreateFontString();
                            unitFrame.auras[i].stacks:SetParent(unitFrame.auras[i].strata);
                            unitFrame.auras[i].stacks:SetPoint("center", unitFrame.auras[i].main, "bottomRight", -2, 0);
                            unitFrame.auras[i].stacks:SetFont("Fonts\\FRIZQT__.TTF", 10, "thickOutline");
                            unitFrame.auras[i].stacks:SetTextColor(1, 0.82, 0);
                            unitFrame.auras[i].stacks:SetText("x" .. stacks);
                            unitFrame.auras[i].stacks:SetDrawLayer("background", 3);
                            unitFrame.auras[i].stacks:SetShown(stacks > 0);
                        else
                            -- Auras frame
                            unitFrame.auras[i]:SetParent(unitFrame);
                            unitFrame.auras[i]:SetScale(ReubinsNameplates_settings.AurasScale);

                            -- Auras main
                            unitFrame.auras[i].main:SetParent(unitFrame.auras[i]);
                            unitFrame.auras[i].main:SetPoint("center", unitFrame.auras[i], "center");

                            -- Fonts strata
                            unitFrame.auras[i].strata:SetParent(unitFrame.auras[i].main);

                            -- Auras border
                            unitFrame.auras[i].border:SetParent(unitFrame.auras[i].main);
                            unitFrame.auras[i].border:SetPoint("center", unitFrame.auras[i].main, "center");

                            -- Mask
                            unitFrame.auras[i].mask:SetParent(unitFrame.auras[i].main);
                            unitFrame.auras[i].mask:SetAllPoints();

                            -- Auras icon
                            unitFrame.auras[i].icon:SetParent(unitFrame.auras[i].main);
                            unitFrame.auras[i].icon:SetPoint("center", unitFrame.auras[i].main, "center");
                            unitFrame.auras[i].icon:SetTexture(icon);
                            unitFrame.auras[i].icon:AddMaskTexture(unitFrame.auras[i].mask);

                            -- Auras countdown
                            unitFrame.auras[i].countdown:SetParent(unitFrame.auras[i].strata);
                            unitFrame.auras[i].countdown:SetPoint("center", unitFrame.auras[i].main, "center");
                            unitFrame.auras[i].countdown:SetText(getCountdown(expirationTime - GetTime()));
                            unitFrame.auras[i].countdown:SetShown(ReubinsNameplates_settings.AurasCountdown);

                            -- Auras cooldown
                            unitFrame.auras[i].cooldown:SetParent(unitFrame.auras[i].main);
                            unitFrame.auras[i].cooldown:SetAllPoints();
                            unitFrame.auras[i].cooldown:SetCooldown(GetTime() - (duration - (expirationTime - GetTime())), duration, timeMod);
                            unitFrame.auras[i].cooldown:SetReverse(ReubinsNameplates_settings.AurasReverseAnimation);

                            -- Auras stacks
                            unitFrame.auras[i].stacks:SetParent(unitFrame.auras[i].strata);
                            unitFrame.auras[i].stacks:SetPoint("center", unitFrame.auras[i].main, "bottomRight", -2, 0);
                            unitFrame.auras[i].stacks:SetText("x" .. stacks);
                            unitFrame.auras[i].stacks:SetShown(stacks > 0);
                        end

                        -- Swapping border texture for stacks
                        if stacks > 0 then
                            unitFrame.auras[i].border:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\auras\\aurasBorderStacks");
                        else
                            unitFrame.auras[i].border:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\auras\\aurasBorder");
                        end

                        local sorted = unitFrame.auras.sorted;
                        table.insert(sorted, i);
                        for k in ipairs(sorted) do
                            unitFrame.auras[sorted[k]]:SetPoint("bottomLeft", unitFrame.name, "top", (k - 1) * auraWidth - auraWidth * #sorted / 2, 8);
                        end

                        -- Scripts
                        local timeElapsed = 0;
                        unitFrame.auras[i].main:SetScript("OnUpdate", function(self, elapsed)
                            timeElapsed = timeElapsed + elapsed;

                            if timeElapsed > 0.1 then
                                timeElapsed = 0;
                                unitFrame.auras[i].countdown:SetText(getCountdown(expirationTime - GetTime()));
                            end
                        end);

                        unitFrame.auras[i].main:SetScript("OnClick", function(self, button)
                            local name, rank, icon, _, _, _, spellID = GetSpellInfo(spellID);

                            if name then
                                ReubinsNameplates_settings.AurasBlacklist[spellID] = {name = name, rank = rank, icon = icon, spellID = spellID};
                                print("|cfff563ff[Reubin's Nameplates]", '|cffffffffBlacklisted "' .. name .. '"');

                                local nameplates = C_NamePlate.GetNamePlates();
                                if nameplates then
                                    for k,v in pairs(nameplates) do
                                        if k then
                                            func:Update_Auras(v.unitFrame.unit);
                                        end
                                    end
                                end

                                func:BlacklistedAuras();
                            end
                        end);

                        -- Showing aura
                        unitFrame.auras[i]:Show();
                    elseif unitFrame.auras[i] then
                        unitFrame.auras[i]:Hide();
                    end
                -- Auras not found, hiding previously use frames.
                elseif unitFrame.auras[i] then
                    unitFrame.auras[i]:Hide();
                else
                    break
                end
            end
        end
    end
end