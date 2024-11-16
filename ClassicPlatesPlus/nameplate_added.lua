----------------------------------------
-- Core
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- Adding nameplate
----------------------------------------
function func:Nameplate_Added(unit, visuals)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit, false);

        if nameplate then
            nameplate.UnitFrame:Hide();
            nameplate.UnitFrame:UnregisterAllEvents();

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
                unitFrame.level:SetShown(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].ShowLevel);

                -- Name and Guild
                unitFrame.name:SetFontObject(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].NameAndGuildOutline and "GameFontNormalOutline" or "GameFontNormal");
                unitFrame.guild:SetFontObject(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].NameAndGuildOutline and "GameFontNormalOutline" or "GameFontNormal");
                unitFrame.name:SetScale(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].LargeName and 0.95 or 0.75);
                unitFrame.guild:SetScale(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].LargeGuildName and 0.95 or 0.75);

                -- Threat percentage
                unitFrame.threatPercentage:ClearAllPoints();

                -- Classification
                unitFrame.classification:ClearAllPoints();

                -- Faction
                unitFrame.fellowshipBadge:ClearAllPoints();

                -- Health values: Main
                unitFrame.healthMain:SetTextColor(
                    CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
                    CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
                    CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
                    CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
                );
                if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].LargeMainValue then
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
                    CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
                    CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
                    CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
                    CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
                );

                -- Castbar
                unitFrame.castbar:SetScale(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].CastbarScale);
                unitFrame.castbar:ClearAllPoints();

                -- Raid target
                unitFrame.raidTarget.icon:ClearAllPoints();

                -- Auras counters
                unitFrame.buffsCounter:SetScale(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasScale);
                unitFrame.debuffsCounter:SetScale(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasScale);

                -- powerbar
                unitFrame.powerbar:ClearAllPoints();
                local powerbarToggle = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].Powerbar and UnitPower(unit) and UnitPowerMax(unit) > 0;

                -- Name
                unitFrame.name:ClearAllPoints();
                unitFrame.name:SetPoint("top", nameplate.UnitFrame.name, "top"); -- Anchor frame

                -- Quest
                unitFrame.quest:ClearAllPoints();

                -- Class power
                unitFrame.classPower:SetHeight(data.classBarHeight);
                unitFrame.classPower:SetScale(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].SpecialPowerScale);

                -- Health Value Secondary
                unitFrame.healthSecondary:SetJustifyH("left");

                -- Classification
                unitFrame.classification:SetTexCoord(0, 1, 0, 1) -- Undo Fliping horizontally

                -- These frames depend on whether portraits and level are enabled or not!
                if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].Portrait then
                    unitFrame.classification:SetParent(unitFrame.portrait);
                    unitFrame.classification:SetSize(48,48);

                    if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].ShowLevel then
                        unitFrame.threatPercentage:SetPoint("bottom", unitFrame.healthbar, "top", 0, -1.5);
                        unitFrame.powerbar:SetPoint("top", unitFrame.healthbar, "bottom", 0, -1);
                        unitFrame.healthMain:SetPoint("center", unitFrame.healthbar, "center");
                        unitFrame.healthSecondary:SetPoint("left", unitFrame.healthbar, "left", 4, 0);
                        unitFrame.classification:SetPoint("center", unitFrame.portrait.texture, "center", -5, -2);
                        unitFrame.quest:SetPoint("left", unitFrame.level, "right", -14, 1);
                    else
                        unitFrame.threatPercentage:SetPoint("bottom", unitFrame.healthbar, "top", -9, -1.5);
                        unitFrame.powerbar:SetPoint("top", unitFrame.healthbar, "bottom", -6.33, -1);
                        unitFrame.healthMain:SetPoint("center", unitFrame.healthbar, "center", -9, 0);
                        unitFrame.healthSecondary:SetPoint("right", unitFrame.healthbar, "right", -4, 0);
                        unitFrame.healthSecondary:SetJustifyH("right");
                        unitFrame.classification:SetPoint("center", unitFrame.portrait.texture, "center", -5, -2);
                        unitFrame.quest:SetPoint("left", unitFrame.healthbar, "right", -6, 1);
                    end
                else
                    unitFrame.classification:SetParent(unitFrame.parent);
                    unitFrame.classification:SetSize(32,32);

                    if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].ShowLevel then
                        unitFrame.threatPercentage:SetPoint("bottom", unitFrame.healthbar, "top", 9, -1.5);
                        unitFrame.powerbar:SetPoint("top", unitFrame.healthbar, "bottom", 6.33, -1);
                        unitFrame.healthMain:SetPoint("center", unitFrame.healthbar, "center", 9, 0);
                        unitFrame.healthSecondary:SetPoint("left", unitFrame.healthbar, "left", 4, 0);
                        unitFrame.classification:SetPoint("center", unitFrame.level.border, "center", 7, 0);
                        unitFrame.quest:SetPoint("left", unitFrame.level, "right", -14, 1);
                    else
                        unitFrame.threatPercentage:SetPoint("bottom", unitFrame.healthbar, "top", 0, -1.5);
                        unitFrame.powerbar:SetPoint("top", unitFrame.healthbar, "bottom", 0, -1);
                        unitFrame.healthMain:SetPoint("center", unitFrame.healthbar, "center", 0, 0);
                        unitFrame.healthSecondary:SetPoint("left", unitFrame.healthbar, "left", 4, 0);
                        unitFrame.classification:SetPoint("left", unitFrame.healthbar, "left", -14, 0);
                        unitFrame.classification:SetTexCoord(1, 0, 0, 1) -- Fliping horizontally
                        unitFrame.quest:SetPoint("left", unitFrame.healthbar, "right", -6, 1);
                    end
                end

                local widgetToggle = true;
                if data.isRetail then
                    local widgetOnly = UnitNameplateShowsWidgetsOnly(unit);
                    local widget = nameplate.UnitFrame.WidgetContainer;

                    if widget then
                        if widgetOnly then
                            widget:SetParent(nameplate);
                            widget:ClearAllPoints();
                            widget:SetPoint("center");
                            widgetToggle = UnitExists("target")
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
                unitFrame.portrait:SetShown(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].Portrait);
                unitFrame.powerbar:SetShown(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].Powerbar);
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
                func:Update_FellowshipBadge(unit);
                func:Update_PVP_Flag(unit);
                func:Update_Level(unit);
                func:Update_Health(unit);
                func:Update_healthbar(unit);
                func:Update_Power(unit);
                if not data.isRetail then
                    func:Update_ClassPower(unit);
                end
                func:Update_Threat(unit);
                if not visuals then
                    func:Update_Auras(unit);
                end
                func:Update_Colors(unit);
                func:Castbar_Start(nil, unit);
                func:RaidTargetIndex();
                func:PredictHeal(unit);
                func:Update_quests(unit);

                if not nameplate.UnitFrame.name[myAddon .. "_anchored"] then
                    local isAnchoringName = false;

                    hooksecurefunc(nameplate.UnitFrame.name,"SetPoint", function(self)
                        if not self:IsProtected() then
                            self[myAddon .. "_anchored"] = true;

                            if isAnchoringName then
                                return;
                            end

                            isAnchoringName = true;

                            if self:GetParent() then
                                local nameplate = self:GetParent():GetParent();

                                if nameplate then
                                    func:Update_NameAndGuildPositions(nameplate, true);
                                end
                            end

                            isAnchoringName = false;
                        end
                    end);
                end

                -- Names Only
                local canAttack = UnitCanAttack("player", unit);
                local isTarget = UnitIsUnit("target", unit);

                local showParent =
                       isTarget
                    or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].NamesOnly == 1
                    or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].NamesOnly == 2 and canAttack
                    or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].NamesOnly == 3 and not canAttack
                    or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].NamesOnly == 4 and false

                local UnitIsPlayerOrPlayersPet = UnitIsPlayer(unit) or UnitIsOtherPlayersPet(unit);
                local exclude =
                       CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].NamesOnlyExcludeNPCs == 2 and not UnitIsPlayerOrPlayersPet
                    or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].NamesOnlyExcludeNPCs == 3 and canAttack and not UnitIsPlayerOrPlayersPet
                    or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].NamesOnlyExcludeFriends and func:isFriend(unit)
                    or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].NamesOnlyExcludeGuild and IsGuildMember(unit)
                    or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].NamesOnlyExcludeParty and func:UnitInYourParty(unit)
                    or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].NamesOnlyExcludeRaid and UnitPlayerOrPetInRaid(unit)

                if not showParent and not exclude then
                    unitFrame.raidTarget.icon:SetPoint("right", unitFrame.name, "left", unitFrame.fellowshipBadge:IsShown() and -20 or -6, 0);
                    unitFrame.raidTarget.icon:SetScale(0.7);
                    unitFrame.castbar:SetPoint("top", unitFrame.guild:IsShown() and unitFrame.guild or unitFrame.name, "bottom", 0, -2 - CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].CastbarPositionY);
                else
                    unitFrame.raidTarget.icon:SetScale(1);

                    if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].Portrait then
                        unitFrame.raidTarget.icon:SetPoint("right", unitFrame.portrait.texture, "left", -6, 0);

                        if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].ShowLevel then
                            unitFrame.castbar:SetPoint("top", powerbarToggle and unitFrame.powerbar or unitFrame.healthbar.border, "bottom", 0, (powerbarToggle and 4 or -3) - CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].CastbarPositionY);
                        else
                            unitFrame.castbar:SetPoint("top", powerbarToggle and unitFrame.powerbar or unitFrame.healthbar.border, "bottom", powerbarToggle and -2 or -9, (powerbarToggle and 4 or -3) - CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].CastbarPositionY);
                        end
                    else
                        unitFrame.raidTarget.icon:SetPoint("right", unitFrame.healthbar, "left", -6, 0);

                        if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].ShowLevel then
                            unitFrame.castbar:SetPoint("top", powerbarToggle and unitFrame.powerbar or unitFrame.healthbar.border, "bottom", powerbarToggle and 2.67 or 9, (powerbarToggle and 4 or 0) - CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].CastbarPositionY);
                        else
                            unitFrame.castbar:SetPoint("top", powerbarToggle and unitFrame.powerbar or unitFrame.healthbar.border, "bottom", 0, (powerbarToggle and 4 or 0) - CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].CastbarPositionY);
                        end
                    end
                end

                -- Felloship Badge
                if not showParent and not exclude or not CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].Portrait then
                    unitFrame.fellowshipBadge:SetPoint("right", unitFrame.name, "left", 1, 1);
                    unitFrame.fellowshipBadge:SetScale(0.75);
                    unitFrame.fellowshipBadge:SetIgnoreParentScale(true);
                else
                    unitFrame.fellowshipBadge:SetPoint("center", unitFrame.portrait.texture, "center", -12, 4);
                    unitFrame.fellowshipBadge:SetScale(1);
                    unitFrame.fellowshipBadge:SetIgnoreParentScale(false);
                end

                -- Interact Icon
                func:InteractIcon(nameplate);

                -- Toggling Parent
                unitFrame.parent:SetShown(showParent or exclude);

                -- Toggling nameplate
                unitFrame:SetShown(widgetToggle and not UnitIsGameObject(unit) and (data.isRetail and not UnitNameplateShowsWidgetsOnly(unit) or not data.isRetail));
            end

            -- Hiding default nameplates
            nameplate.UnitFrame:SetScript("OnShow", function(self)
                self:Hide();
            end);
        end
    end
end