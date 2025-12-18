-- RandomUser.me API Client
-- Generate random user profiles for NPCs
-- API Docs: https://randomuser.me/documentation

local randomuser = {}

local http = require("src.utils.http")
local settings = require("config.settings")

local BASE_URL = settings.API.RANDOMUSER

---
-- Generate random NPC profiles
-- @param count number Number of NPCs to generate (default: 1)
-- @param nationality string Optional nationality filter
-- @return table Array of NPC profile data or nil and error
function randomuser.generate(count, nationality)
  count = count or 1

  -- TODO: Implement NPC generation
  -- 1. Build request URL with results parameter
  -- 2. Add nationality filter if provided (us, gb, fr, de, etc.)
  -- 3. Make HTTP GET request
  -- 4. Parse JSON response
  -- 5. Extract name, picture, gender, age, etc.
  -- 6. Return array of NPC data

  -- Example: https://randomuser.me/api/?results=10

  return nil, "Not yet implemented"
end

---
-- Generate a single NPC with specific characteristics
-- @param options table Optional filters (gender, nationality, etc.)
-- @return table NPC profile or nil and error
function randomuser.generate_one(options)
  options = options or {}

  -- TODO: Implement single NPC generation with filters
  -- Supported filters: gender (male/female), nat (nationality code)

  return nil, "Not yet implemented"
end

---
-- Extract relevant NPC data from API response
-- @param api_result table Raw API response
-- @return table Cleaned NPC data
function randomuser.parse_npc(api_result)
  -- TODO: Parse and structure NPC data
  -- Extract: full name, first name, last name, picture URL, gender, age
  -- Format for use in realm generation

  return nil, "Not yet implemented"
end

return randomuser
