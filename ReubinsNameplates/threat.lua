----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- Threat icon
----------------------------------------
function func:Update_ThreatIcon(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;
            local frame = unitFrame.threat.icon;
            local toggle;

            if ReubinsNameplates_settings.ThreatIcon == "Always" then
                toggle = true;
            elseif ReubinsNameplates_settings.ThreatIcon == "Party & raid" then
                if IsInRaid() or IsInGroup() then
                    toggle = true;
                else
                    toggle = false;
                end
            elseif ReubinsNameplates_settings.ThreatIcon == "Never" then
                toggle = false;
            end

            if toggle then
                local notPlayerOrPet = not UnitIsPlayer(unit) and not UnitIsOtherPlayersPet(unit);
                local icon = unitFrame.threat.icon.texture;
                local animation = unitFrame.threat.animation;

                -- Prepping for a color switch check
                unitFrame.threat.color = unitFrame.threat.color or nil;
                unitFrame.threat.colorPrev = unitFrame.threat.color;

                if UnitCanAttack("player", unit) and notPlayerOrPet then

                    -- Tank mode Activated
                    if ReubinsNameplates_settings.TankMode then
                        local iAmTanking = UnitDetailedThreatSituation("player", unit);

                        local function otherTank()
                            for k in pairs(data.tanks) do
                                if k then
                                    local isTanking = UnitDetailedThreatSituation(k, unit);
                                    if isTanking then
                                        return true;
                                    end
                                end
                            end
                        end

                        -- Swapping icon
                        icon:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\icons\\tank");

                        if iAmTanking then
                            icon:SetVertexColor(data.colors.green.r, data.colors.green.g, data.colors.green.b);
                            unitFrame.threat.color = "green";
                            frame:SetShown(toggle);
                        elseif otherTank() then
                            icon:SetVertexColor(data.colors.blue.r, data.colors.blue.g, data.colors.blue.b);
                            unitFrame.threat.color = "blue";
                            frame:SetShown(toggle);
                        elseif UnitAffectingCombat(unit) then
                            icon:SetVertexColor(data.colors.red.r, data.colors.red.g, data.colors.red.b);
                            unitFrame.threat.color = "red";
                            frame:SetShown(toggle);
                        else
                            frame:Hide();
                        end

                    -- Tank mode Deactivated
                    else
                        local treatPercentage = UnitThreatPercentageOfLead("player",unit)

                        -- Swapping icon
                        icon:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\icons\\aggro");

                        if treatPercentage then
                            if treatPercentage >= 100 then
                                icon:SetVertexColor(data.colors.red.r, data.colors.red.g, data.colors.red.b);
                                unitFrame.threat.color = "red";
                                frame:SetShown(toggle);
                            elseif treatPercentage > 75 then
                                icon:SetVertexColor(data.colors.orange.r, data.colors.orange.g, data.colors.orange.b);
                                unitFrame.threat.color = "orange";
                                frame:SetShown(toggle);
                            elseif treatPercentage > 50 then
                                icon:SetVertexColor(data.colors.yellow.r, data.colors.yellow.g, data.colors.yellow.b);
                                unitFrame.threat.color = "yellow";
                                frame:SetShown(toggle);
                            else
                                frame:Hide();
                            end
                        else
                            frame:Hide();
                        end
                    end
                else
                    frame:Hide();
                end

                -- Play icon's animation on color change
                if unitFrame.threat.colorPrev ~= unitFrame.threat.color then
                    if animation:IsPlaying() then
                        animation:Restart();
                    else
                        animation:Play();
                    end
                end
            else
                frame:Hide();
            end
        end
    end
end

----------------------------------------
-- Threat percentage
----------------------------------------
function func:Update_ThreatPercentage(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;

            if ReubinsNameplates_settings.ThreatPercentage then
                local percentage = unitFrame.threat.percentage;
                local text = unitFrame.threat.percentage.text;
                local background = unitFrame.threat.percentage.background;
                local treatPercentage = UnitThreatPercentageOfLead("player",unit)

                if treatPercentage and treatPercentage > 0 then
                    if treatPercentage >= 999 then
                        text:SetText("999%");
                    else
                        text:SetText(math.floor(treatPercentage) .. "%");
                    end

                    if ReubinsNameplates_settings.TankMode then
                        if treatPercentage >= 200 then
                            background:SetVertexColor(0, 1, 0); -- 1 Green
                        elseif treatPercentage < 100 then
                            background:SetVertexColor(1, 0, 0); -- 12 Red
                        elseif treatPercentage < 110 then
                            background:SetVertexColor(1, 0.23, 0); -- 11
                        elseif treatPercentage < 120 then
                            background:SetVertexColor(1, 0.34, 0); -- 10
                        elseif treatPercentage < 130 then
                            background:SetVertexColor(1, 0.44, 0); -- 9
                        elseif treatPercentage < 140 then
                            background:SetVertexColor(1, 0.55, 0); -- 8
                        elseif treatPercentage < 150 then
                            background:SetVertexColor(1, 0.69, 0); -- 7
                        elseif treatPercentage < 160 then
                            background:SetVertexColor(1, 0.83, 0); -- 6
                        elseif treatPercentage < 170 then
                            background:SetVertexColor(1, 0.95, 0); -- 5
                        elseif treatPercentage < 180 then
                            background:SetVertexColor(0.94, 1, 0); -- 4
                        elseif treatPercentage < 190 then
                            background:SetVertexColor(0.79, 1, 0); -- 3
                        elseif treatPercentage < 200 then
                            background:SetVertexColor(0.56, 1, 0); -- 2
                        end
                    else
                        if treatPercentage >= 100 then
                            background:SetVertexColor(1, 0, 0); -- 10 Red
                        elseif treatPercentage >= 90 then
                            background:SetVertexColor(1, 0.27, 0); -- 9
                        elseif treatPercentage >= 80 then
                            background:SetVertexColor(1, 0.39, 0); -- 8
                        elseif treatPercentage >= 70 then
                            background:SetVertexColor(1, 0.53, 0); -- 7
                        elseif treatPercentage >= 60 then
                            background:SetVertexColor(1, 0.67, 0); -- 6
                        elseif treatPercentage >= 50 then
                            background:SetVertexColor(1, 0.84, 0); -- 5
                        elseif treatPercentage >= 40 then
                            background:SetVertexColor(1, 0.98, 0); -- 4
                        elseif treatPercentage >= 30 then
                            background:SetVertexColor(0.88, 1, 0); -- 3
                        elseif treatPercentage >= 20 then
                            background:SetVertexColor(0.63, 1, 0); -- 2
                        elseif treatPercentage >= 10 then
                            background:SetVertexColor(0, 1, 0); -- 1
                        elseif treatPercentage >= 0 then
                            background:SetVertexColor(0, 1, 0); -- 0 Green
                        end
                    end

                    -- Shifting unit's name Up because treat is shown.
                    unitFrame.name:ClearAllPoints();
                    if ReubinsNameplates_settings.Portrait then
                        unitFrame.name:SetPoint("bottom", nameplate.unitFrame.healthbar, "top", -1, 18);
                    else
                        unitFrame.name:SetPoint("bottom", nameplate.unitFrame.healthbar, "top", 8, 18);
                    end

                    percentage:Show();
                else
                    percentage:Hide();

                    -- Shifting unit's name Down because treat is hidden.
                    unitFrame.name:ClearAllPoints();
                    if ReubinsNameplates_settings.Portrait then
                        unitFrame.name:SetPoint("bottom", nameplate.unitFrame.healthbar, "top", -1, 12);
                    else
                        unitFrame.name:SetPoint("bottom", nameplate.unitFrame.healthbar, "top", 8, 8);
                    end
                end
            else
                unitFrame.threat.percentage:Hide();
            end
        end
    end
end