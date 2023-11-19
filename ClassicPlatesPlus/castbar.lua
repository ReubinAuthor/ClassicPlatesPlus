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

            castbar.animation:Stop();

            if test then
                text = "This is a test castbar with a very long name";
                icon = 135807;
                startTimeMS = GetTime() * 1000;
                endTimeMS = GetTime() * 1000 + 30;
                isTradeSkill = false;
                notInterruptible = true;
                progressReverser = -1;
                minValue = -(endTimeMS - startTimeMS) / 1000;
                maxValue = 0;
                r,g,b = data.colors.orange.r, data.colors.orange.g, data.colors.orange.b;
            elseif event then
                if event == "UNIT_SPELLCAST_START" then
                    text, icon, startTimeMS, endTimeMS, isTradeSkill, _, notInterruptible = select(2, UnitCastingInfo(unit));

                    minValue = -(endTimeMS - startTimeMS) / 1000;
                    maxValue = 0;
                    progressReverser = -1;
                    r,g,b = data.colors.orange.r, data.colors.orange.g, data.colors.orange.b;
                elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
                    text, icon, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = select(2, UnitChannelInfo(unit));

                    minValue = 0;
                    maxValue = (endTimeMS - startTimeMS) / 1000;
                    progressReverser = 1;
                    r,g,b = data.colors.purple.r, data.colors.purple.g, data.colors.purple.b;
                end
            else
                text, icon, startTimeMS, endTimeMS, isTradeSkill, _, notInterruptible = select(2, UnitCastingInfo(unit));

                if text then
                    minValue = -(endTimeMS - startTimeMS) / 1000;
                    maxValue = 0;
                    r,g,b = data.colors.orange.r, data.colors.orange.g, data.colors.orange.b;
                    progressReverser = -1;
                else
                    text, icon, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = select(2, UnitChannelInfo(unit));

                    if text then
                        minValue = 0;
                        maxValue = (endTimeMS - startTimeMS) / 1000;
                        r,g,b = data.colors.purple.r, data.colors.purple.g, data.colors.purple.b;
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
                castbar.border:SetTexture(notInterruptible and "Interface\\addons\\ClassicPlatesPlus\\media\\castbar\\castbarUI2" or "Interface\\addons\\ClassicPlatesPlus\\media\\castbar\\castbar");
                castbar.border:SetVertexColor(0.75, 0.75, 0.75);
                castbar:SetSize(140, notInterruptible and 28 or 22);

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
                castbar:SetShown(Config.CastbarShow and not isTradeSkill);
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

        -- Spell Cost
        if UnitIsUnit(unit, "player") then
            local name = UnitCastingInfo("player");

            if not name then
                data.nameplate.powerbarCost:Hide();
                data.nameplate.powerbarCostSpark:Hide();
            end
        end
    end
end