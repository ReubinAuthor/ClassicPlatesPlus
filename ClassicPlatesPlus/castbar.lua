----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- Castbar start
----------------------------------------
function func:Castbar_Start(event, unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local castbar = nameplate.unitFrame.castbar;
            local text, icon, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, minValue, maxValue, progressReverser;
            local r,g,b;
            local test = false;
            local showIcon = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].CastbarIconShow;

            castbar.animation:Stop();

            if not showIcon then
                castbar.statusbar:SetPoint("center", castbar.border, "center", 0, 0);
                castbar.border:SetSize(128, 16);
                castbar.icon:Hide();
            else
                castbar.statusbar:SetPoint("center", castbar.border, "center", 9, 0);
                castbar.border:SetSize(256, 64);
                castbar.icon:Show();
            end

            if test then
                text = "This is a test castbar with a very long name";
                icon = 135807;
                startTimeMS = GetTime() * 1000;
                endTimeMS = GetTime() * 1000 + 30;
                isTradeSkill = false;
                notInterruptible = false;
                progressReverser = -1;
                minValue = -(endTimeMS - startTimeMS) / 1000;
                maxValue = 0;
                if notInterruptible then
                    r,g,b = data.colors.gray.r, data.colors.gray.g, data.colors.gray.b;
                else
                    r,g,b = data.colors.orange.r, data.colors.orange.g, data.colors.orange.b;
                end
            elseif event then
                if event == "UNIT_SPELLCAST_START" then
                    text, icon, startTimeMS, endTimeMS, isTradeSkill, _, notInterruptible = select(2, UnitCastingInfo(unit));

                    if text then
                        minValue = -(endTimeMS - startTimeMS) / 1000;
                        maxValue = 0;
                        progressReverser = -1;
                        if notInterruptible then
                            r,g,b = data.colors.gray.r, data.colors.gray.g, data.colors.gray.b;
                        else
                            r,g,b = data.colors.orange.r, data.colors.orange.g, data.colors.orange.b;
                        end
                    end
                elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
                    text, icon, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = select(2, UnitChannelInfo(unit));

                    if text then
                        minValue = 0;
                        maxValue = (endTimeMS - startTimeMS) / 1000;
                        progressReverser = 1;
                        if notInterruptible then
                            r,g,b = data.colors.gray.r, data.colors.gray.g, data.colors.gray.b;
                        else
                            r,g,b = data.colors.purple.r, data.colors.purple.g, data.colors.purple.b;
                        end
                    end
                end
            else
                text, icon, startTimeMS, endTimeMS, isTradeSkill, _, notInterruptible = select(2, UnitCastingInfo(unit));

                if text then
                    minValue = -(endTimeMS - startTimeMS) / 1000;
                    maxValue = 0;
                    if notInterruptible then
                        r,g,b = data.colors.gray.r, data.colors.gray.g, data.colors.gray.b;
                    else
                        r,g,b = data.colors.orange.r, data.colors.orange.g, data.colors.orange.b;
                    end
                    progressReverser = -1;
                else
                    text, icon, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = select(2, UnitChannelInfo(unit));

                    if text then
                        minValue = 0;
                        maxValue = (endTimeMS - startTimeMS) / 1000;
                        if notInterruptible then
                            r,g,b = data.colors.gray.r, data.colors.gray.g, data.colors.gray.b;
                        else
                            r,g,b = data.colors.purple.r, data.colors.purple.g, data.colors.purple.b;
                        end
                        progressReverser = 1;
                    end
                end
            end

            if text then
                castbar.name:SetText(text);

                -- Trimming spell name
                local maxNameWidth = 135

                if castbar.name:GetStringWidth() > maxNameWidth then
                    local spellName = castbar.name:GetText();

                    if castbar.name:GetStringWidth(spellName) > maxNameWidth then
                        local spellNameLength = strlenutf8(string.sub(spellName, 2, #spellName - 1));
                        local trimmedLength = math.floor(maxNameWidth / castbar.name:GetStringWidth(spellName) * spellNameLength);

                        spellName = func:utf8sub(spellName, 1, trimmedLength);
                        castbar.name:SetText(spellName .. "...");
                    end
                end

                castbar.name:SetTextColor(1,1,1);
                castbar.icon:SetTexture(icon);
                castbar.statusbar:SetMinMaxValues(minValue, maxValue);
                castbar.statusbar:SetStatusBarColor(r,g,b);
                castbar.border:SetTexture(
                    (not showIcon) and "Interface\\addons\\ClassicPlatesPlus\\media\\borders\\healthbar"
                    or notInterruptible and "Interface\\addons\\ClassicPlatesPlus\\media\\castbar\\castbarUI2"
                    or "Interface\\addons\\ClassicPlatesPlus\\media\\castbar\\castbar"
                );
                castbar.border:SetVertexColor(0.75, 0.75, 0.75);
                if not showIcon then
                    castbar:SetSize(128, 16);
                else
                    castbar:SetSize(140, notInterruptible and 28 or 22);
                end
                castbar:SetSize((not showIcon) and 128 or 140, (not showIcon) and 16 or notInterruptible and 28 or 22);

                local timeElapsed = 0;
                castbar:SetScript("OnUpdate", function(self, elapsed)
                    timeElapsed = timeElapsed + elapsed;
                    if not castbar.animation:IsPlaying() then
                        castbar.statusbar:SetValue(progressReverser * ((endTimeMS / 1000) - GetTime()));
                    end

                    if timeElapsed > 0.1 then
                        local value = (endTimeMS / 1000) - GetTime();
                        timeElapsed = 0;
                        castbar.countdown:SetText(func:formatTime(value));
                    end
                end);

                castbar.countdown:Show();
                castbar:SetShown(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].CastbarShow and not isTradeSkill);
            end
        end
    end
end

----------------------------------------
-- Castbar end
----------------------------------------
function func:Castbar_End(event, unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local castbar = nameplate.unitFrame.castbar;
            local channelName = UnitChannelInfo(unit);

            if event == "UNIT_SPELLCAST_FAILED"
            or event == "UNIT_SPELLCAST_FAILED_QUIET"
            or event == "UNIT_SPELLCAST_INTERRUPTED" then
                castbar.statusbar:SetStatusBarColor(data.colors.red.r, data.colors.red.g, data.colors.red.b);
                castbar.border:SetVertexColor(data.colors.red.r, data.colors.red.g, data.colors.red.b);
                castbar.name:SetTextColor(data.colors.orange.r, data.colors.orange.g, data.colors.orange.b);
            end

            if event == "UNIT_SPELLCAST_SUCCEEDED" and not channelName then
                castbar.statusbar:SetStatusBarColor(data.colors.green.r, data.colors.green.g, data.colors.green.b);
                castbar.border:SetVertexColor(data.colors.green.r, data.colors.green.g, data.colors.green.b);
                castbar.name:SetTextColor(data.colors.yellow.r, data.colors.yellow.g, data.colors.yellow.b);
            end

            if event == "UNIT_SPELLCAST_STOP"
            or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
                castbar.animation:Stop();
                castbar.animation:Play();
                castbar.countdown:Hide();
            end

            castbar.statusbar:SetValue(0);
        end
    end
end