-- HuggingFace API Client
-- AI-powered text generation for lore creation
-- API Docs: https://huggingface.co/docs/api-inference/

local huggingface = {}

local http = require("src.utils.http")
local settings = require("config.settings")

local BASE_URL = settings.API.HUGGINGFACE
local DEFAULT_MODEL = "gpt2"  -- Free model, can be changed

---
-- Generate lore text using AI
-- @param prompt string The prompt for lore generation
-- @param options table Optional parameters (max_length, temperature, etc.)
-- @return string Generated lore text or nil and error
function huggingface.generate_lore(prompt, options)
  options = options or {}

  if not prompt or prompt == "" then
    return nil, "Prompt cannot be empty"
  end

  -- TODO: Implement AI lore generation
  -- 1. Check if API key is available (optional feature)
  -- 2. Build request to text-generation endpoint
  -- 3. Include prompt and parameters
  -- 4. Make HTTP POST request with Authorization header
  -- 5. Parse response and extract generated text
  -- 6. Return lore text

  -- Note: This is an optional feature requiring API key
  -- If no key, return placeholder or use local generation

  return nil, "Not yet implemented - requires API key"
end

---
-- Generate a kingdom backstory
-- @param kingdom_name string Name of the kingdom
-- @param terrain_type string Terrain type for context
-- @return string Generated backstory or nil and error
function huggingface.generate_kingdom_backstory(kingdom_name, terrain_type)
  -- TODO: Implement kingdom backstory generation
  -- Create a specific prompt for kingdom history

  local prompt = string.format(
    "Write a brief fantasy backstory for the kingdom of %s, located in %s terrain:",
    kingdom_name,
    terrain_type
  )

  return huggingface.generate_lore(prompt)
end

---
-- Generate an NPC backstory
-- @param npc_name string NPC name
-- @param npc_class string NPC class/profession
-- @return string Generated backstory or nil and error
function huggingface.generate_npc_backstory(npc_name, npc_class)
  -- TODO: Implement NPC backstory generation

  local prompt = string.format(
    "Write a brief backstory for %s, a %s:",
    npc_name,
    npc_class
  )

  return huggingface.generate_lore(prompt)
end

---
-- Generate a quest description
-- @param quest_type string Type of quest
-- @param location string Location name
-- @return string Generated quest description or nil and error
function huggingface.generate_quest_description(quest_type, location)
  -- TODO: Implement quest description generation

  local prompt = string.format(
    "Create a fantasy quest about %s in the location called %s:",
    quest_type,
    location
  )

  return huggingface.generate_lore(prompt)
end

---
-- Check if HuggingFace API is available
-- @return boolean True if API key is configured
function huggingface.is_available()
  -- TODO: Check if HUGGINGFACE_API_KEY environment variable is set
  return false
end

return huggingface
