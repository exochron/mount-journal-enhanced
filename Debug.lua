local ADDON_NAME, ADDON = ...

local function print(...)
    _G.print("[MJE]", ...)
end

ADDON.Debug = {}

local lastProfileTimes = {}
local lastProfileCounts = {}
--- to actually use this enable the cvar: scriptProfile
function ADDON.Debug:ProfileFunction(name, func, includeSubroutines)
    local lastTime = lastProfileTimes[name] or 0
    local lastCount = lastProfileCounts[name] or 0
    local totalTime, totalCount = GetFunctionCPUUsage(func, includeSubroutines)
    if totalCount > lastCount then
        print("*" .. name .. "*", "current_time=" .. (totalTime - lastTime), "total_time=" .. totalTime, "total_count=" .. totalCount)
        lastProfileTimes[name] = totalTime
        lastProfileCounts[name] = totalCount
    end
end
function ADDON.Debug:WatchFunction(name, func, includeSubroutines)
    C_Timer.NewTicker(5, function()
        ADDON.Debug:ProfileFunction(name, func, includeSubroutines)
    end)
end

local function runFilterTest(testName)
    ADDON:ResetFilterSettings()
    for key, value in pairs(ADDON.settings.filter[testName]) do
        if type(value) == "table" then
            for subKey, _ in pairs(value) do
                ADDON.settings.filter[testName][key][subKey] = false
            end
        else
            ADDON.settings.filter[testName][key] = false
        end
    end
    for _, mountId in ipairs(ADDON:FilterMounts()) do
        local name, spellID, _, _, _, sourceType = C_MountJournal.GetMountInfoByID(mountId)
        print("No " .. testName .. " info for mount: " .. name .. " (" .. spellID .. ", " .. mountId .. ", " .. sourceType .. ") ")
    end
end

local function checkDBForOldMountIds(index)
    for mountId, _ in pairs(ADDON.DB[index]) do
        local name = C_MountJournal.GetMountInfoByID(mountId)
        if not name then
            print(index .. ":", "old entry for mount: " .. mountId)
        end
    end
end

local function testDatabase()
    local filterSettingsBackup = CopyTable(ADDON.settings.filter)

    runFilterTest("source")
    runFilterTest("mountType")
    runFilterTest("faction")
    runFilterTest("family")
    runFilterTest("expansion")

    ADDON.settings.filter = CopyTable(filterSettingsBackup)
    if ADDON.settings.personalFilter then
        MJEPersonalSettings.filter = ADDON.settings.filter
    else
        MJEGlobalSettings.filter = ADDON.settings.filter
    end

    --for _, expansionMounts in pairs(ADDON.DB.Expansion) do
    --    for id, _ in pairs(expansionMounts) do
    --        if id ~= "minID" and id ~= "maxID" and not mounts[id] then
    --            print("Old expansion info for mount: " .. id)
    --        end
    --    end
    --end

    checkDBForOldMountIds("Ignored")
end

local taintedList = {}
local function checkTaintedTable(tbl, parentPath, taintedList)
    for key, val in pairs(tbl) do
        if type(key) == "number" or (type(key) == "string" and not key:match("MJE_")) then
            local isSecure, taintedBy = issecurevariable(tbl, key)
            if not isSecure and taintedList[key] ~= true then
                print(key .. " got tainted within " .. parentPath .. " by: " .. taintedBy)
                taintedList[key] = true
            elseif isSecure and taintedList[key] == true then
                print(key .. " is not tainted within " .. parentPath .. " anymore")
                taintedList[key] = nil
            end

            if taintedList[key] ~= true and type(val) == "table" and key ~= "parent" and key ~= "ModelScene" and key ~= "tooltipFrame" then
                if taintedList[key] == nil then
                    taintedList[key] = {}
                end
                taintedList[key] = checkTaintedTable(val, parentPath .. "." .. key, taintedList[key])
            end
        end
    end

    return taintedList
end
local function checkForTaint()
    local isSecure, taintedBy = issecurevariable("MountJournal")
    if not isSecure and not taintedList["MountJournal"] then
        print("MountJournal got tainted by: " .. taintedBy)
        taintedList["MountJournal"] = true
    end
    taintedList = checkTaintedTable(MountJournal, "MountJournal", taintedList)
end

ADDON.Events:RegisterCallback("loadUI", function()
    if ADDON.settings.ui.debugMode then
        testDatabase()

        checkForTaint()
        C_Timer.NewTicker(1, checkForTaint)
    end
end, "debug")