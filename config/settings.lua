-- Realm Forge Configuration
-- Default settings and constants for the fantasy world generator

local settings = {}

-- API Endpoints
settings.API = {
  NOMINATIM = "https://nominatim.openstreetmap.org",
  ELEVATION = "https://api.opentopodata.org/v1/srtm90m",
  WEATHER = "https://api.open-meteo.com/v1/forecast",
  RANDOMUSER = "https://randomuser.me/api",
  DND = "https://www.dnd5eapi.co/api",
  HUGGINGFACE = "https://api-inference.huggingface.co/models",
  WIKIPEDIA = "https://en.wikipedia.org/w/api.php"
}

-- Terrain Classification and Fantasy Themes
-- Elevation-based classification with fantasy transformations
settings.TERRAIN_TYPES = {
  MOUNTAINS = {
    min_elevation = 500,      -- meters
    max_elevation = 9000,
    fantasy_names = {
      "Dragon Peaks",
      "Dwarf Strongholds",
      "Sky Citadels",
      "Giant's Spine",
      "Frostfang Mountains"
    },
    description = "Towering peaks where dragons nest and dwarves carve their kingdoms"
  },
  HILLS = {
    min_elevation = 200,
    max_elevation = 500,
    fantasy_names = {
      "Hobbit Shires",
      "Gnome Villages",
      "Rolling Highlands",
      "Halfling Downs",
      "Shepherd's Knolls"
    },
    description = "Gentle slopes perfect for farming communities and hidden villages"
  },
  PLAINS = {
    min_elevation = 10,
    max_elevation = 200,
    fantasy_names = {
      "Nomad Grasslands",
      "Human Farmlands",
      "Endless Steppes",
      "Golden Fields",
      "Centaur Plains"
    },
    description = "Vast open lands where nomadic tribes roam and crops flourish"
  },
  WETLANDS = {
    min_elevation = -10,
    max_elevation = 10,
    fantasy_names = {
      "Cursed Swamps",
      "Haunted Marshes",
      "Witch's Bog",
      "Murkmire",
      "Shadowfen"
    },
    description = "Mysterious wetlands shrouded in mist and dark magic"
  },
  COASTAL = {
    near_water = true,
    elevation_max = 50,
    fantasy_names = {
      "Pirate Havens",
      "Port Cities",
      "Smuggler's Cove",
      "Siren's Reef",
      "Trade Harbors"
    },
    description = "Bustling ports where merchants and rogues cross paths"
  },
  FOREST = {
    vegetation_dense = true,
    fantasy_names = {
      "Enchanted Woodlands",
      "Elven Realms",
      "Ancient Groves",
      "Druid's Forest",
      "Fey Wilds"
    },
    description = "Dense woods where ancient magic flows and elves make their homes"
  },
  WATER = {
    water_body = true,
    fantasy_names = {
      "Sacred Waters",
      "Mystic Shores",
      "Crystal Lakes",
      "Mermaid Lagoon",
      "Dragon's Pool"
    },
    description = "Waters blessed by ancient powers and guarded by mystical beings"
  },
  URBAN = {
    is_urban = true,
    fantasy_names = {
      "Kingdom Capitals",
      "Trading Hubs",
      "Wizard's City",
      "Crown Fortress",
      "Merchant's Square"
    },
    description = "Bustling centers of civilization where all races gather"
  }
}

-- Weather and Climate Fantasy Interpretations
settings.CLIMATE_THEMES = {
  TROPICAL = {
    temp_range = {20, 40},  -- Celsius
    description = "Jungle realms with exotic beasts and ancient ruins",
    inhabitants = {"Lizardfolk", "Yuan-ti", "Jungle Elves"}
  },
  TEMPERATE = {
    temp_range = {0, 20},
    description = "Balanced lands ideal for diverse civilizations",
    inhabitants = {"Humans", "Halflings", "Half-elves"}
  },
  COLD = {
    temp_range = {-40, 0},
    description = "Frozen wastes home to hardy peoples and ice magic",
    inhabitants = {"Frost Giants", "Ice Dwarves", "Winter Elves"}
  },
  ARID = {
    precipitation_low = true,
    description = "Desert kingdoms with hidden oases and ancient secrets",
    inhabitants = {"Genasi", "Desert Nomads", "Sand Elves"}
  }
}

-- NPC Generation Settings
settings.NPC = {
  races = {
    "Human", "Elf", "Dwarf", "Halfling", "Gnome",
    "Half-Elf", "Half-Orc", "Tiefling", "Dragonborn"
  },
  classes = {
    "Warrior", "Mage", "Rogue", "Cleric", "Ranger",
    "Paladin", "Bard", "Druid", "Monk", "Warlock"
  },
  name_count_per_realm = 20  -- Default number of NPCs to generate
}

-- Faction Types
settings.FACTION_TYPES = {
  "Kingdom", "Guild", "Cult", "Order", "Clan",
  "Empire", "Republic", "Tribe", "Covenant", "Alliance"
}

-- Quest Difficulty Levels
settings.QUEST_DIFFICULTIES = {
  EASY = {level = 1, reward_multiplier = 1},
  MEDIUM = {level = 5, reward_multiplier = 2},
  HARD = {level = 10, reward_multiplier = 4},
  LEGENDARY = {level = 15, reward_multiplier = 10}
}

-- HTTP Request Settings
settings.HTTP = {
  timeout = 10,  -- seconds
  user_agent = "RealmForge/1.0 (Lua Fantasy World Generator)",
  max_retries = 3
}

-- Output Settings
settings.OUTPUT = {
  directory = "output",
  format = "json",  -- json, lua, or markdown
  include_metadata = true
}

-- Debug Settings
settings.DEBUG = {
  enabled = false,
  log_api_calls = false,
  verbose = false
}

return settings
