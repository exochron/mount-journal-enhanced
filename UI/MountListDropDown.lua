local ADDON_NAME, ADDON = ...

local menuMountId

local function InitializeMountOptionsMenu(sender, level)

    if not menuMountId then
        return
    end

    local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountId = ADDON.Api.GetMountInfoByID(menuMountId)

    local info = { notCheckable = true }

    local needsFanfare = C_MountJournal.NeedsFanfare(mountId)

    if needsFanfare then
        info.text = UNWRAP
    elseif (active) then
        info.text = BINDING_NAME_DISMOUNT
    else
        info.text = MOUNT
        info.disabled = not isUsable
    end

    info.func = function()
        if needsFanfare then
            ADDON:SetSelected(menuMountId)
        end
        MountJournalMountButton_UseMount(mountId)
    end

    UIDropDownMenu_AddButton(info, level)

    if not needsFanfare and isCollected then
        local isFavorite, canFavorite = ADDON.Api.GetIsFavoriteByID(menuMountId)
        info = {notCheckable = true, disabled = not canFavorite }

        if isFavorite then
            info.text = BATTLE_PET_UNFAVORITE
            info.func = function()
                ADDON.Api.SetIsFavoriteByID(menuMountId, false)
                ADDON:UpdateMountList()
            end
        else
            info.text = BATTLE_PET_FAVORITE
            info.func = function()
                ADDON.Api.SetIsFavoriteByID(menuMountId, true)
                ADDON:UpdateMountList()
            end
        end

        UIDropDownMenu_AddButton(info, level)
    end

    if spellId then
        if ADDON.settings.hiddenMounts[spellId] then
            info = {
                notCheckable = true,
                text = SHOW,
                func = function()
                    ADDON.settings.hiddenMounts[spellId] = nil
                    ADDON:UpdateIndex()
                    ADDON:UpdateMountList()
                end
            }
        else
            info = {
                notCheckable = true,
                text = HIDE,
                func = function()
                    ADDON.settings.hiddenMounts[spellId] = true
                    ADDON:UpdateIndex()
                    ADDON:UpdateMountList()
                end,
            }
        end
        UIDropDownMenu_AddButton(info, level)
    end

    UIDropDownMenu_AddButton({text = CANCEL, notCheckable = true,}, level)
end

local function OnClick(sender, anchor, button)
    if button ~= "LeftButton" then
        menuMountId = sender.mountID;
        ToggleDropDownMenu(1, nil, _G[ADDON_NAME .. "MountOptionsMenu"], anchor, 0, 0)
    end
end

ADDON:RegisterLoadUICallback(function()
    local menu = CreateFrame("Frame", ADDON_NAME .. "MountOptionsMenu", MountJournal, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(menu, InitializeMountOptionsMenu, "MENU")

    for _, button in pairs(MountJournal.MJE_ListScrollFrame.buttons) do
        button:HookScript("OnClick", function(sender, mouseButton)
            OnClick(sender, sender, mouseButton)
        end)
        button.DragButton:HookScript("OnClick", function(sender, mouseButton)
            OnClick(sender:GetParent(), sender, mouseButton)
        end)
    end
end)