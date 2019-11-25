local ADDON_NAME, ADDON = ...
local L = ADDON.L

--region setting handler
local callbacks, defaults, uiLabels, behaviorLabels = {}, {}, {}, {}
function ADDON:RegisterUISetting(key, default, label, func)
    callbacks[key] = function(flag)
        ADDON.settings.ui[key] = flag
        if func then
            func(flag)
        end
    end
    defaults[key] = default
    uiLabels[key] = label
end
function ADDON:RegisterBehaviorSetting(key, default, label, func)
    callbacks[key] = function(flag)
        ADDON.settings[key] = flag
        MJEPersonalSettings[key] = flag
        func(flag)
    end
    defaults[key] = default
    behaviorLabels[key] = label
end
function ADDON:ApplySetting(key, value)
    if callbacks[key] then
        callbacks[key](value)
    end
end
function ADDON:ResetSettings()
    for setting, default in pairs(defaults) do
        ADDON:ApplySetting(setting, default)
    end
end
function ADDON:GetSettingLabels()
    return uiLabels, behaviorLabels
end
--endregion

--region setup some behavior settings
ADDON:RegisterBehaviorSetting('personalUi', false, L.SETTING_PERSONAL_UI, function(flag)
    if flag == true then
        ADDON.settings.ui = MJEPersonalSettings.ui
    else
        ADDON.settings.ui = MJEGlobalSettings.ui
    end
end)

ADDON:RegisterBehaviorSetting('personalHiddenMounts', false, L.SETTING_PERSONAL_HIDDEN_MOUNTS, function(flag)
    if flag == true then
        ADDON.settings.hiddenMounts = MJEPersonalSettings.hiddenMounts
    else
        ADDON.settings.hiddenMounts = MJEGlobalSettings.hiddenMounts
    end

    if ADDON.initialized then
        ADDON:UpdateIndexMap()
    end
end)

ADDON:RegisterBehaviorSetting('personalFilter', false, L.SETTING_PERSONAL_FILTER, function(flag)
    if flag == true then
        ADDON.settings.filter = MJEPersonalSettings.filter
    else
        ADDON.settings.filter = MJEGlobalSettings.filter
    end

    if ADDON.initialized then
        ADDON:UpdateIndexMap()
    end
end)
--endregion