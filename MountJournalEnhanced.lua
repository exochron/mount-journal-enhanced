local ADDON_NAME, ADDON = ...

ADDON.hooks = {}
local indexMap -- initialize with nil, so we know if it's not ready yet and not just empty

--region C_MountJournal Hooks

local function MapIndexToMountId(index)
    -- index=0 => SummonRandomButton
    if index == 0 then
        return 0
    end

    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    return indexMap[index][1]
end

local function MapIndex(index)
    -- index=0 => SummonRandomButton
    if index == 0 then
        return index
    end

    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    return indexMap[index][2]
end

local function C_MountJournal_GetNumDisplayedMounts()
    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    return #indexMap
end

local function C_MountJournal_GetDisplayedMountInfo(index)
    local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h
    local mappedMountId = MapIndexToMountId(index)
    if mappedMountId > 0 then
        creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h = C_MountJournal.GetMountInfoByID(mappedMountId)
    else
        creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h = ADDON.hooks["GetDisplayedMountInfo"](index)
    end

    isUsable = isUsable and IsUsableSpell(spellId)

    return creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h
end

local function Hook(obj, name, func)
    ADDON.hooks[name] = obj[name]
    obj[name] = func
end

local function HookWithMountId(originalFuncName, mappedFuncName)
    Hook(C_MountJournal, originalFuncName, function(index, arg1, arg2)
        local mountId = MapIndexToMountId(index)
        if mountId > 0 then
            return C_MountJournal[mappedFuncName](mountId, arg1, arg2)
        end
    end)
end
local function HookWithMappedIndex(functionName)
    Hook(C_MountJournal, functionName, function(index, arg1, arg2)
        index = MapIndex(index)
        if index > 0 then
            return ADDON.hooks[functionName](index, arg1, arg2)
        end
    end)
end

local function RegisterMountJournalHooks()
    Hook(C_MountJournal, "GetNumDisplayedMounts", C_MountJournal_GetNumDisplayedMounts)
    Hook(C_MountJournal, "GetDisplayedMountInfo", C_MountJournal_GetDisplayedMountInfo)
    HookWithMountId("GetDisplayedMountInfoExtra", "GetMountInfoExtraByID")
    HookWithMountId("GetDisplayedMountAllCreatureDisplayInfo", "GetMountAllCreatureDisplayInfoByID")
    HookWithMappedIndex("Pickup")
    HookWithMappedIndex("GetIsFavorite")
    HookWithMappedIndex("SetIsFavorite")
    hooksecurefunc(C_MountJournal, "SetIsFavorite", function()
        ADDON:UpdateIndex() -- dont forward parameters
    end)
end

--endregion Hooks

--region callbacks
local loginCallbacks, loadUICallbacks = {}, {}
function ADDON:RegisterLoginCallback(func)
    table.insert(loginCallbacks, func)
end
function ADDON:RegisterLoadUICallback(func)
    table.insert(loadUICallbacks, func)
end
local function FireCallbacks(callbacks)
    for _, callback in pairs(callbacks) do
        callback()
    end
end
--endregion

local function LoadUI()
    RegisterMountJournalHooks()

    ADDON:UpdateIndex()
    MountJournal_UpdateMountList()

    local frame = CreateFrame("frame");
    frame:RegisterEvent("ZONE_CHANGED")
    frame:RegisterEvent("ZONE_CHANGED_INDOORS")
    frame:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
    frame:RegisterEvent("MOUNT_JOURNAL_SEARCH_UPDATED")
    frame:SetScript("OnEvent", function(sender, ...)
        if CollectionsJournal:IsShown() then
            ADDON:UpdateIndex(true)
            MountJournal_UpdateMountList()
        end
    end);

    MountJournal.searchBox:SetScript("OnTextChanged", function()
        SearchBoxTemplate_OnTextChanged(MountJournal.searchBox)
        ADDON:UpdateIndex(true)
        MountJournal_UpdateMountList()
    end)

    FireCallbacks(loadUICallbacks)
end

function ADDON:UpdateIndex(calledFromEvent)
    local map = {}

    local searchString = MountJournal.searchBox:GetText() or ""
    if searchString ~= "" then
        searchString = searchString:lower()
    end

    for i = 1, ADDON.hooks["GetNumDisplayedMounts"]() do
        local mountId = select(12, ADDON.hooks["GetDisplayedMountInfo"](i))
        if ADDON:FilterMount(mountId, searchString) then
            map[#map + 1] = {mountId, i}
        end
    end

    if calledFromEvent and nil ~= indexMap and #map == #indexMap then
        return
    end

    indexMap = ADDON:SortMounts(map)
end

local function ResetIngameFilter()
    -- reset default filter settings
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_COLLECTED, true)
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED, true)
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE, true)
    C_MountJournal.SetAllSourceFilters(true)
    C_MountJournal.SetSearch("")
end
ResetIngameFilter()

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, arg1)
    local doInit = false
    if event == "PLAYER_LOGIN" then
        ResetIngameFilter()
        FireCallbacks(loginCallbacks)
        if MountJournal then
            doInit = true
        end
    elseif event == "ADDON_LOADED" and arg1 == "Blizzard_Collections" then
        if not ADDON.initialized and ADDON.settings then
            doInit = true
        end
    end

    if doInit then
        frame:UnregisterEvent("ADDON_LOADED")
        LoadUI()
        ADDON.initialized = true
    end
end)