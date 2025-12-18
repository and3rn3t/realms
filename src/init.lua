-- Realm Forge - Main Entry Point
-- A Lua-based fantasy world generator

local RealmForge = {
  _VERSION = "0.1.0",
  _DESCRIPTION = "Transform real-world locations into magical fantasy realms",
  _LICENSE = "MIT"
}

-- Load core modules
local Realm = require("src.core.realm")
local settings = require("config.settings")

-- Load utility modules
local helpers = require("src.utils.helpers")

---
-- Generate a new fantasy realm from a real-world location
-- @param options table Configuration options for realm generation
--   - address: string - Real-world address or location name (required)
--   - radius: number - Radius in kilometers to explore (default: 50)
--   - npc_count: number - Number of NPCs to generate (default: 20)
--   - include_quests: boolean - Generate quests (default: true)
--   - include_factions: boolean - Generate factions (default: true)
-- @return Realm object or nil, error
function RealmForge.generate(options)
  -- Validate input
  if not options or type(options) ~= "table" then
    return nil, "Options must be a table"
  end

  if not options.address or options.address == "" then
    return nil, "Address is required"
  end

  -- Set defaults
  local config = {
    address = options.address,
    radius = options.radius or 50,
    npc_count = options.npc_count or settings.NPC.name_count_per_realm,
    include_quests = options.include_quests ~= false,
    include_factions = options.include_factions ~= false
  }

  -- Create and initialize realm
  local realm = Realm.new(config)

  -- TODO: Implement realm generation pipeline:
  -- 1. Geocode address to get coordinates
  -- 2. Fetch elevation data for the area
  -- 3. Fetch weather/climate data
  -- 4. Classify terrain types
  -- 5. Apply fantasy themes
  -- 6. Generate NPCs
  -- 7. Generate factions
  -- 8. Generate quests
  -- 9. Generate lore

  return realm
end

---
-- Load an existing realm from a file
-- @param filepath string Path to the realm file
-- @return Realm object or nil, error
function RealmForge.load(filepath)
  -- TODO: Implement realm loading from JSON/Lua file
  return nil, "Not yet implemented"
end

---
-- Save a realm to a file
-- @param realm Realm The realm object to save
-- @param filepath string Path where to save the realm
-- @return boolean Success status, error message
function RealmForge.save(realm, filepath)
  -- TODO: Implement realm saving to JSON/Lua file
  return false, "Not yet implemented"
end

---
-- Get version information
-- @return string Version string
function RealmForge.version()
  return RealmForge._VERSION
end

---
-- Get configuration settings
-- @return table Current configuration
function RealmForge.get_config()
  return settings
end

return RealmForge
