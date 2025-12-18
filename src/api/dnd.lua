-- D&D 5e API Client
-- Monsters, spells, items from D&D 5th edition
-- API Docs: https://www.dnd5eapi.co/docs/

local dnd = {}

local http = require("src.utils.http")
local settings = require("config.settings")

local BASE_URL = settings.API.DND

---
-- Get a random monster for the realm
-- @param challenge_rating number Optional CR filter (0-30)
-- @return table Monster data or nil and error
function dnd.get_random_monster(challenge_rating)
  -- TODO: Implement random monster retrieval
  -- 1. Get list of all monsters from /api/monsters
  -- 2. Filter by challenge rating if specified
  -- 3. Select random monster from list
  -- 4. Get full monster details
  -- 5. Return monster data

  return nil, "Not yet implemented"
end

---
-- Get monsters suitable for a terrain type
-- @param terrain_type string Terrain type (e.g., "MOUNTAINS", "FOREST")
-- @return table Array of appropriate monsters
function dnd.get_monsters_by_terrain(terrain_type)
  -- TODO: Implement terrain-based monster filtering
  -- Map terrain types to appropriate monster environments
  -- Mountains -> Dragons, Giants
  -- Forest -> Beasts, Fey
  -- Swamp -> Undead, Aberrations
  -- etc.

  return nil, "Not yet implemented"
end

---
-- Get a random magic item
-- @param rarity string Optional rarity filter (common, uncommon, rare, very rare, legendary)
-- @return table Item data or nil and error
function dnd.get_random_item(rarity)
  -- TODO: Implement random magic item retrieval
  -- 1. Get list of magic items from /api/magic-items
  -- 2. Filter by rarity if specified
  -- 3. Select random item
  -- 4. Return item data with description

  return nil, "Not yet implemented"
end

---
-- Get a random spell
-- @param level number Spell level (0-9)
-- @return table Spell data or nil and error
function dnd.get_random_spell(level)
  -- TODO: Implement random spell retrieval
  -- Useful for generating magical locations or wizard NPCs

  return nil, "Not yet implemented"
end

---
-- Get list of all monster types
-- @return table Array of monster type names
function dnd.get_monster_types()
  -- TODO: Query available monster types
  -- Returns: aberration, beast, celestial, construct, dragon, elemental,
  --          fey, fiend, giant, humanoid, monstrosity, ooze, plant, undead

  return nil, "Not yet implemented"
end

---
-- Search for specific D&D content
-- @param endpoint string API endpoint (monsters, spells, magic-items, etc.)
-- @param name string Name to search for
-- @return table Search results or nil and error
function dnd.search(endpoint, name)
  -- TODO: Implement generic search functionality
  -- Allows searching any D&D API endpoint by name

  return nil, "Not yet implemented"
end

return dnd
