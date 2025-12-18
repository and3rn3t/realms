package = "realm-forge"
version = "dev-1"

source = {
  url = "git://github.com/and3rn3t/realms.git",
  branch = "main"
}

description = {
  summary = "A Lua-based fantasy world generator that transforms local geography into magical realms",
  detailed = [[
    Realm Forge is a creative tool that takes real-world locations and transforms them
    into rich fantasy worlds. It uses multiple public APIs to gather data about terrain,
    weather, and geography, then applies fantasy themes to generate unique realms complete
    with NPCs, lore, factions, and quests.
  ]],
  homepage = "https://github.com/and3rn3t/realms",
  license = "MIT"
}

dependencies = {
  "lua >= 5.3",
  "luasocket >= 3.0",
  "luasec >= 1.0",
  "dkjson >= 2.5"
}

build = {
  type = "builtin",
  modules = {
    ["realm-forge"] = "src/init.lua",
    ["realm-forge.config.settings"] = "config/settings.lua",
    ["realm-forge.api.nominatim"] = "src/api/nominatim.lua",
    ["realm-forge.api.elevation"] = "src/api/elevation.lua",
    ["realm-forge.api.weather"] = "src/api/weather.lua",
    ["realm-forge.api.randomuser"] = "src/api/randomuser.lua",
    ["realm-forge.api.dnd"] = "src/api/dnd.lua",
    ["realm-forge.api.huggingface"] = "src/api/huggingface.lua",
    ["realm-forge.api.wikipedia"] = "src/api/wikipedia.lua",
    ["realm-forge.core.realm"] = "src/core/realm.lua",
    ["realm-forge.core.location"] = "src/core/location.lua",
    ["realm-forge.core.npc"] = "src/core/npc.lua",
    ["realm-forge.core.lore"] = "src/core/lore.lua",
    ["realm-forge.core.terrain"] = "src/core/terrain.lua",
    ["realm-forge.generators.name_generator"] = "src/generators/name_generator.lua",
    ["realm-forge.generators.faction_generator"] = "src/generators/faction_generator.lua",
    ["realm-forge.generators.quest_generator"] = "src/generators/quest_generator.lua",
    ["realm-forge.utils.http"] = "src/utils/http.lua",
    ["realm-forge.utils.json"] = "src/utils/json.lua",
    ["realm-forge.utils.helpers"] = "src/utils/helpers.lua"
  },
  copy_directories = {
    "examples",
    "output"
  }
}
