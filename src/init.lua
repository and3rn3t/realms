--[[
    Source initialization
    Load all game modules here
]]

local src = {}

-- Core systems
src.core = {}
src.core.StateManager = require("src.core.StateManager")
src.core.Input = require("src.core.Input")
src.core.AssetManager = require("src.core.AssetManager")
src.core.Camera = require("src.core.Camera")
src.core.Resolution = require("src.core.Resolution")

-- Game modules
src.entities = {}
src.world = {}
src.combat = {}
src.quests = {}
src.inventory = {}
src.dialogue = {}
src.ui = {}
src.data = {}

return src
