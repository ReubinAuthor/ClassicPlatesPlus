----------------------------------------
-- Core
----------------------------------------
local _, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- Adding nameplate
----------------------------------------
function func:Nameplate_Added(unit, visuals)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit, false);

        if nameplate then
            if UnitIsUnit(unit, "target") then
                func:PositionAuras(nameplate.unitFrame);
            end

            if UnitIsUnit(unit, "player") then
                func:PersonalNameplateAdd();
            else
                local unitFrame = nameplate.unitFrame;

                -- Level
                unitFrame.level.background:SetColorTexture(
                    data.colors.border.r - 0.35,
                    data.colors.border.g - 0.35,
                    data.colors.border.b - 0.35
                );
                unitFrame.level:SetShown(Config.ShowLevel);

                -- Name and Guild
                unitFrame.name:SetScale(Config.NameplatesScale - func:GetPercent(Config.NameplatesScale, 10));
                unitFrame.guild:SetScale(Config.NameplatesScale - func:GetPercent(Config.NameplatesScale, 20));

                -- Threat percentage
                unitFrame.threatPercentage:ClearAllPoints();

                -- Classification
                unitFrame.classification:ClearAllPoints();

                -- Faction
                unitFrame.pvp_flag:ClearAllPoints();

                -- Health values: Main
                unitFrame.healthMain:SetTextColor(
                    Config.HealthFontColor.r,
                    Config.HealthFontColor.g,
                    Config.HealthFontColor.b,
                    Config.HealthFontColor.a
                );
                if Config.LargeMainValue then
                    unitFrame.healthMain:SetFontObject("GameFontNormalLargeOutline");
                    unitFrame.healthMain:SetScale(0.85);
                else
                    unitFrame.healthMain:SetFontObject("GameFontNormalOutline");
                    unitFrame.healthMain:SetScale(0.8);
                end
                unitFrame.healthMain:ClearAllPoints();
                unitFrame.healthSecondary:ClearAllPoints();

                -- Health values: Left side
                unitFrame.healthSecondary:SetTextColor(
                    Config.HealthFontColor.r,
                    Config.HealthFontColor.g,
                    Config.HealthFontColor.b,
                    Config.HealthFontColor.a
                );

                -- Castbar
                unitFrame.castbar:ClearAllPoints();

                -- Raid target
                unitFrame.raidTarget.icon:ClearAllPoints();

                unitFrame.buffsCounter:SetScale(Config.AurasScale);
                unitFrame.debuffsCounter:SetScale(Config.AurasScale);

                -- Name
                unitFrame.name:SetPoint("top", nameplate.UnitFrame.name, "top"); -- Anchor frame

                -- Quest
                unitFrame.quest:ClearAllPoints();

                -- Class Bar
                unitFrame.ClassBarDummy:SetHeight(data.classBarHeight);

                -- Health Value Secondary
                unitFrame.healthSecondary:SetJustifyH("left");

                -- Classification
                unitFrame.classification:SetTexCoord(0, 1, 0, 1) -- Undo Fliping horizontally

                -- These frames depend on whether portraits and level are enabled or not!
                if Config.Portrait then
                    unitFrame.classification:SetParent(unitFrame.portrait);
                    unitFrame.classification:SetSize(48,48);
                    unitFrame.pvp_flag:SetSize(27,27);
                    unitFrame.pvp_flag:SetParent(unitFrame.portrait);
                    unitFrame.pvp_flag:SetPoint("center", unitFrame.portrait.texture, "center", -7, -1.4);
                    unitFrame.pvp_flag:SetScale(1);
                    unitFrame.raidTarget.icon:SetPoint("right", unitFrame.portrait.texture, "left", -6, 0);

                    if Config.ShowLevel then
                        unitFrame.threatPercentage:SetPoint("bottom", unitFrame.healthbar, "top", 0, -1.5);
                        unitFrame.castbar:SetPoint("top", unitFrame.healthbar.border, "bottom", 0, 8);
                        unitFrame.powerbar.statusbar:SetPoint("top", unitFrame.healthbar, "bottom", 0, -1);
                        unitFrame.healthMain:SetPoint("center", unitFrame.healthbar, "center");
                        unitFrame.healthSecondary:SetPoint("left", unitFrame.healthbar, "left", 4, 0);
                        unitFrame.classification:SetPoint("center", unitFrame.portrait.texture, "center", -5, -2);
                        unitFrame.quest:SetPoint("left", unitFrame.level, "right", -14, 1);
                    else
                        unitFrame.threatPercentage:SetPoint("bottom", unitFrame.healthbar, "top", 0, -1.5);
                        unitFrame.castbar:SetPoint("top", unitFrame.healthbar.border, "bottom", -9.5, 8);
                        unitFrame.powerbar.statusbar:SetPoint("top", unitFrame.healthbar, "bottom", -6.33, -1); --<
                        unitFrame.healthMain:SetPoint("center", unitFrame.healthbar, "center", -9.5, 0); --<
                        unitFrame.healthSecondary:SetPoint("right", unitFrame.healthbar, "right", -4, 0);
                        unitFrame.healthSecondary:SetJustifyH("right");
                        unitFrame.classification:SetPoint("center", unitFrame.portrait.texture, "center", -5, -2);
                        unitFrame.quest:SetPoint("left", unitFrame.healthbar, "right", -6, 1);
                    end
                else
                    unitFrame.classification:SetParent(unitFrame);
                    unitFrame.classification:SetSize(32,32);
                    unitFrame.pvp_flag:SetSize(30,30);
                    unitFrame.pvp_flag:SetParent(unitFrame);
                    unitFrame.pvp_flag:SetPoint("right", unitFrame.name, "left", 10, -5);
                    unitFrame.pvp_flag:SetScale(0.7);
                    unitFrame.raidTarget.icon:SetPoint("right", unitFrame.healthbar, "left", -6, 0);

                    if Config.ShowLevel then
                        unitFrame.threatPercentage:SetPoint("bottom", unitFrame.healthbar, "top", 9.5, -1.5);
                        unitFrame.castbar:SetPoint("top", unitFrame.healthbar.border, "bottom", 9.5, 8);
                        unitFrame.powerbar.statusbar:SetPoint("top", unitFrame.healthbar, "bottom", 7.12, -1); --<
                        unitFrame.healthMain:SetPoint("center", unitFrame.healthbar, "center", 9.5, 0); --<
                        unitFrame.healthSecondary:SetPoint("left", unitFrame.healthbar, "left", 4, 0);
                        unitFrame.classification:SetPoint("center", unitFrame.level.border, "center", 7, 0);
                        unitFrame.quest:SetPoint("left", unitFrame.level, "right", -14, 1);
                    else
                        unitFrame.threatPercentage:SetPoint("bottom", unitFrame.healthbar, "top", 0, -1.5);
                        unitFrame.castbar:SetPoint("top", unitFrame.healthbar.border, "bottom", 0, 8);
                        unitFrame.powerbar.statusbar:SetPoint("top", unitFrame.healthbar, "bottom", 0, -1);
                        unitFrame.healthMain:SetPoint("center", unitFrame.healthbar, "center", 0, 0);
                        unitFrame.healthSecondary:SetPoint("left", unitFrame.healthbar, "left", 4, 0);
                        unitFrame.classification:SetPoint("left", unitFrame.healthbar, "left", -14, 0);
                        unitFrame.classification:SetTexCoord(1, 0, 0, 1) -- Fliping horizontally
                        unitFrame.quest:SetPoint("left", unitFrame.healthbar, "right", -6, 1);
                    end
                end

                -- Interract icon
                local interactIcon = nameplate.UnitFrame.SoftTargetFrame.Icon;
                if interactIcon then
                    interactIcon:SetParent(unitFrame);
                    interactIcon:ClearAllPoints();
                    interactIcon:SetPoint("left", unitFrame.name, "right", 2, 0);
                    interactIcon:SetScale(0.33);
                end

                -- Widget Container
                local toggle = true;
                if data.isRetail then
                    local widgetOnly = UnitNameplateShowsWidgetsOnly(unit);
                    local widget = nameplate.UnitFrame.WidgetContainer;

                    if widget then
                        if widgetOnly then
                            widget:SetParent(nameplate);
                            widget:ClearAllPoints();
                            widget:SetPoint("center");
                            toggle = UnitExists("target")
                        else
                            widget:SetParent(unitFrame);
                            widget:ClearAllPoints();
                            widget:SetPoint("top", unitFrame.healthbar, "bottom", 0, -12);
                        end

                        unitFrame.castbar:SetScript("OnShow", function()
                            if widget then
                                widget:ClearAllPoints();
                                widget:SetPoint("top", unitFrame.castbar, "bottom", 0, 16);
                            end
                        end);
                        unitFrame.castbar:SetScript("OnHide", function()
                            if widget then
                                widget:ClearAllPoints();
                                widget:SetPoint("top", unitFrame.healthbar, "bottom", 0, -12);
                            end
                        end);
                    end
                end

                -- Toggling frames
                unitFrame.portrait:SetShown(Config.Portrait);
                unitFrame.powerbar:SetShown(Config.Powerbar);
                unitFrame.castbar:Hide();

                -- Assigning unit
                unitFrame.unit = unit;
                if not data.isClassic then
                    unitFrame.inVehicle = UnitInVehicle(unit);
                end

                -- Updating everything
                func:Update_Name(unit);
                func:Update_Guild(unit);
                func:Update_Classification(unit);
                func:Update_Portrait(unit);
                func:Update_PVP_Flag(unit);
                func:Update_Level(unit);
                func:Update_Health(unit);
                func:Update_healthbar(unit);
                func:Update_Power(unit);
                func:Update_ComboPoints(unit);
                func:Update_Threat(unit);
                if not visuals then
                    func:Update_Auras(unit);
                end
                func:Update_Colors(unit);
                func:Castbar_Start(nil, unit);
                func:RaidTargetIndex();
                func:PredictHeal(unit);
                if data.isRetail then
                    func:Update_quests(unit);
                end

                -- Scripts
                --[[local timeElapsed = 0;
                unitFrame:SetScript("OnUpdate", function(self, elapsed)
                    timeElapsed = timeElapsed + elapsed;
                    if timeElapsed > 0.1 then
                        timeElapsed = 0;
                        func:Update_Threat(unit); -- Updating threat
                    end
                end);]]

                -- Showing nameplate
                unitFrame:SetShown(toggle and not UnitIsGameObject(unit));
            end

            -- Hiding default nameplates
            nameplate.UnitFrame:SetScript("OnShow", function(self)
                self:Hide();
            end);
        end
    end
end