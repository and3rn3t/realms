--[[
    Mod Loader System
    Framework for loading and managing mods
]]

local ModLoader = {}
ModLoader.mods = {}
ModLoader.enabled = true

-- Initialize mod loader
function ModLoader.init()
    ModLoader.mods = {}
    ModLoader.enabled = true
end

-- Load a mod from a directory
function ModLoader.loadMod(modPath, modName)
    if not ModLoader.enabled then
        return false
    end

    modName = modName or modPath

    -- Check if mod already loaded
    if ModLoader.mods[modName] then
        print("Mod '" .. modName .. "' already loaded")
        return false
    end

    local mod = {
        name = modName,
        path = modPath,
        loaded = false,
        data = {},
    }

    -- Try to load mod manifest
    local manifestPath = modPath .. "/mod.json"
    local manifestFile = love.filesystem.read(manifestPath)

    if manifestFile then
        -- Parse JSON (would need json.lua library)
        -- For now, use a simple Lua config file
        local manifestPathLua = modPath .. "/mod.lua"
        local manifestChunk = love.filesystem.load(manifestPathLua)

        if manifestChunk then
            local manifest = manifestChunk()
            mod.data = manifest or {}
        end
    end

    -- Load mod content
    ModLoader.loadModContent(mod)

    ModLoader.mods[modName] = mod
    mod.loaded = true

    print("Mod '" .. modName .. "' loaded successfully")
    return true
end

-- Load content from a mod
function ModLoader.loadModContent(mod)
    -- Load items
    if mod.data.items then
        local Items = require("src.data.Items")
        for itemId, itemData in pairs(mod.data.items) do
            Items.data[itemId] = itemData
        end
    end

    -- Load quests
    if mod.data.quests then
        local Quests = require("src.data.Quests")
        for questId, questData in pairs(mod.data.quests) do
            Quests.data[questId] = questData
        end
    end

    -- Load enemies
    if mod.data.enemies then
        local Enemies = require("src.data.Enemies")
        for enemyType, enemyData in pairs(mod.data.enemies) do
            Enemies.data[enemyType] = enemyData
        end
    end

    -- Load realms
    if mod.data.realms then
        local Realms = require("src.data.Realms")
        for realmName, realmData in pairs(mod.data.realms) do
            Realms.data[realmName] = realmData
        end
    end
end

-- Unload a mod
function ModLoader.unloadMod(modName)
    if not ModLoader.mods[modName] then
        return false
    end

    local mod = ModLoader.mods[modName]

    -- Remove mod content (would need to track what was added)
    -- For now, just mark as unloaded
    mod.loaded = false
    ModLoader.mods[modName] = nil

    print("Mod '" .. modName .. "' unloaded")
    return true
end

-- Get all loaded mods
function ModLoader.getLoadedMods()
    local loaded = {}
    for name, mod in pairs(ModLoader.mods) do
        if mod.loaded then
            table.insert(loaded, name)
        end
    end
    return loaded
end

-- Check if a mod is loaded
function ModLoader.isModLoaded(modName)
    return ModLoader.mods[modName] ~= nil and ModLoader.mods[modName].loaded
end

-- Load all mods from mods directory
function ModLoader.loadAllMods()
    if not ModLoader.enabled then
        return
    end

    -- Check for mods directory
    local modsDir = "mods"

    -- In LÖVE2D, we'd use love.filesystem.getDirectoryItems
    -- For now, this is a framework that can be expanded
    print("Mod loader ready - mods can be loaded from 'mods' directory")
end

-- Enable/disable mod loader
function ModLoader.setEnabled(enabled)
    ModLoader.enabled = enabled
end

return ModLoader

