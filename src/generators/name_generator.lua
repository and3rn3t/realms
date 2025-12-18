-- Name Generator
-- Generate fantasy names for places, NPCs, and items

local name_generator = {}

-- Name components for procedural generation
local PREFIXES = {
  "Ald", "Bel", "Cor", "Dun", "Eth", "Far", "Gal", "Hel", "Ith", "Kal",
  "Lor", "Mel", "Nor", "Oak", "Raven", "Sil", "Thor", "Val", "Wil", "Zar"
}

local SUFFIXES = {
  "bar", "den", "dor", "fell", "ford", "gate", "haven", "helm", "hill", "holm",
  "keep", "moor", "port", "shire", "stone", "vale", "ward", "wick", "wind", "wood"
}

local MIDDLE_PARTS = {
  "al", "en", "il", "or", "an", "ath", "eth", "oth", "un", "ar"
}

---
-- Generate a fantasy place name
-- @param terrain_type string Optional terrain type for themed names
-- @return string Generated place name
function name_generator.generate_place_name(terrain_type)
  -- TODO: Implement place name generation
  -- Use terrain type to influence name style
  -- Combine prefixes, middle parts, and suffixes

  local prefix = PREFIXES[math.random(#PREFIXES)]
  local suffix = SUFFIXES[math.random(#SUFFIXES)]

  -- Sometimes add a middle part
  if math.random() > 0.5 then
    local middle = MIDDLE_PARTS[math.random(#MIDDLE_PARTS)]
    return prefix .. middle .. suffix
  else
    return prefix .. suffix
  end
end

---
-- Generate a fantasy character name
-- @param race string Optional race for themed names
-- @param gender string Optional gender
-- @return string Generated character name
function name_generator.generate_character_name(race, gender)
  -- TODO: Implement race-specific name generation
  -- Different patterns for different races:
  -- - Elves: Flowing, melodic names
  -- - Dwarves: Hard consonants, clan names
  -- - Humans: Varied styles
  -- - etc.

  return name_generator.generate_place_name()
end

---
-- Generate a fantasy kingdom/faction name
-- @return string Generated faction name
function name_generator.generate_faction_name()
  local adjectives = {
    "Ancient", "Golden", "Silver", "Iron", "Shadow", "Crimson", "Azure",
    "Eternal", "Forgotten", "Radiant", "Dark", "Holy", "Wild", "Free"
  }

  local nouns = {
    "Kingdom", "Empire", "Alliance", "Order", "Brotherhood", "Sisterhood",
    "Guild", "Circle", "Covenant", "Legion", "Conclave", "Federation"
  }

  local adj = adjectives[math.random(#adjectives)]
  local noun = nouns[math.random(#nouns)]

  return string.format("%s %s", adj, noun)
end

---
-- Generate a tavern/inn name
-- @return string Generated tavern name
function name_generator.generate_tavern_name()
  local adjectives = {
    "Prancing", "Sleeping", "Golden", "Silver", "Rusty", "Dancing",
    "Laughing", "Drunken", "Merry", "Red", "Green", "Blue"
  }

  local nouns = {
    "Dragon", "Pony", "Bear", "Lion", "Griffin", "Unicorn",
    "Stag", "Wolf", "Fox", "Rooster", "Boar", "Maiden"
  }

  local places = {"Inn", "Tavern", "Alehouse", "Lodge"}

  local adj = adjectives[math.random(#adjectives)]
  local noun = nouns[math.random(#nouns)]
  local place = places[math.random(#places)]

  return string.format("The %s %s %s", adj, noun, place)
end

---
-- Generate a quest name
-- @return string Generated quest name
function name_generator.generate_quest_name()
  local verbs = {
    "Search", "Quest", "Hunt", "Rescue", "Defend", "Recover",
    "Destroy", "Discover", "Escape", "Infiltrate", "Retrieve"
  }

  local objects = {
    "Ancient Artifact", "Lost Treasure", "Sacred Relic", "Stolen Crown",
    "Hidden Temple", "Cursed Item", "Legendary Weapon", "Missing Person",
    "Dark Secret", "Forgotten Knowledge", "Dragon's Hoard"
  }

  local verb = verbs[math.random(#verbs)]
  local obj = objects[math.random(#objects)]

  return string.format("%s for the %s", verb, obj)
end

---
-- Generate a random name based on type
-- @param name_type string Type: "place", "character", "faction", "tavern", "quest"
-- @param options table Optional parameters for generation
-- @return string Generated name
function name_generator.generate(name_type, options)
  options = options or {}

  if name_type == "place" then
    return name_generator.generate_place_name(options.terrain_type)
  elseif name_type == "character" then
    return name_generator.generate_character_name(options.race, options.gender)
  elseif name_type == "faction" then
    return name_generator.generate_faction_name()
  elseif name_type == "tavern" then
    return name_generator.generate_tavern_name()
  elseif name_type == "quest" then
    return name_generator.generate_quest_name()
  else
    return name_generator.generate_place_name()
  end
end

return name_generator
