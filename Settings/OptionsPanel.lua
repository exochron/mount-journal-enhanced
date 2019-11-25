local ADDON_NAME, ADDON = ...

-- WARNING: Also look into ResetUISettings() on new elements

local AceGUI = LibStub("AceGUI-3.0")

local function BuildCheckBox(parent, text)
    local button = AceGUI:Create("CheckBox")
    button:SetLabel(text)
    button:SetFullWidth(true)
    parent:AddChild(button)

    return button
end
local function BuildHeading(parent, text)
    local head = AceGUI:Create("Heading")
    head:SetText(text)
    head:SetFullWidth(true)
    parent:AddChild(head)

    return head
end

local function BuildFrame(uiLabels, behaviourLabels)
    local title = GetAddOnMetadata(ADDON_NAME, "Title")
    local frame = AceGUI:Create("BlizOptionsGroup")
    frame:SetName(title)
    frame:SetTitle(title)
    frame:SetLayout("List")
    frame.checks = {}

    BuildHeading(frame, UIOPTIONS_MENU)

    for setting, label in pairs(uiLabels) do
        if (ADDON.settings.ui[setting] ~= nil) then
            frame.checks[setting] = BuildCheckBox(frame, label)
        end
    end

    BuildHeading(frame, ADDON.L.SETTING_HEAD_SETTING_BEHAVIOUR)

    for setting, label in pairs(behaviourLabels) do
        if (ADDON.settings[setting] ~= nil) then
            frame.checks[setting] = BuildCheckBox(frame, label)
        end
    end

    return frame
end

ADDON:RegisterLoginCallback(function()
    local uiLabels, behaviourLabels = ADDON:GetSettingLabels()

    local group = BuildFrame(uiLabels, behaviourLabels)
    group:SetCallback("refresh", function(frame)
        for setting, _ in pairs(uiLabels) do
            if (frame.checks[setting]) then
                frame.checks[setting]:SetValue(ADDON.settings.ui[setting])
            end
        end
        for setting, _ in pairs(behaviourLabels) do
            if (frame.checks[setting]) then
                frame.checks[setting]:SetValue(ADDON.settings[setting])
            end
        end
    end)
    group:SetCallback("okay", function(frame)
        for setting, _ in pairs(uiLabels) do
            if (frame.checks[setting]) then
                ADDON:ApplySetting(setting, frame.checks[setting]:GetValue())
            end
        end
        for setting, _ in pairs(behaviourLabels) do
            if (frame.checks[setting]) then
                ADDON:ApplySetting(setting, frame.checks[setting]:GetValue())
            end
        end
    end)
    group:SetCallback("default", ADDON.ResetSettings)
    InterfaceOptions_AddCategory(group.frame)
end)