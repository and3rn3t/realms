--[[
    Realms - A LÖVE2D Game Project
    Entry point for the game
]]

-- Load source modules
local src = require("src.init")

-- Game state
local Game = {}
Game.title = "Realms"
Game.version = "0.1.0"

-- Initialize game
function love.load()
    -- Set default filter for pixel art
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Initialize core systems
    src.core.Resolution.init(800, 600)
    src.core.StateManager.init()
    src.core.Input.init()
    src.core.AssetManager.init()
    src.core.Camera.init()

    -- Initialize world system
    src.world = {}
    src.world.World = require("src.world.World")
    src.world.World.init()

    -- Load realm data
    src.data = {}
    src.data.Realms = require("src.data.Realms")
    for name, data in pairs(src.data.Realms.getAllRealms()) do
        src.world.World.registerRealm(name, data)
    end

    -- Initialize game systems
    src.quests = {}
    src.quests.QuestSystem = require("src.quests.QuestSystem")
    src.quests.QuestSystem.init()

    -- Load quest data
    src.data.Quests = require("src.data.Quests")
    for questId, questData in pairs(src.data.Quests.data) do
        src.quests.QuestSystem.registerQuest(questId, questData)
    end

    -- Initialize dialogue system
    src.dialogue = {}
    src.dialogue.DialogueSystem = require("src.dialogue.DialogueSystem")
    src.dialogue.DialogueSystem.init()

    -- Initialize combat system
    src.combat = {}
    src.combat.CombatSystem = require("src.combat.CombatSystem")
    src.combat.CombatSystem.init()

    -- Initialize crafting system
    src.crafting = {}
    src.crafting.CraftingSystem = require("src.crafting.CraftingSystem")
    src.crafting.CraftingSystem.init()

    -- Load recipes
    src.data.Recipes = require("src.data.Recipes")
    for recipeId, recipeData in pairs(src.data.Recipes.getAllRecipes()) do
        src.crafting.CraftingSystem.registerRecipe(recipeId, recipeData)
    end

    -- Initialize save system
    src.save = {}
    src.save.SaveSystem = require("src.save.SaveSystem")
    src.save.SaveSystem.init()

    -- Initialize UI systems
    src.ui.UIManager.init()

    -- Initialize mod loader
    src.modding.ModLoader = require("src.modding.ModLoader")
    src.modding.ModLoader.init()
    src.modding.ModLoader.loadAllMods()

    -- Create menu state
    local MenuState = {
        name = "menu",
        enter = function(self)
            print("Entered menu state")
        end,
        update = function(self, dt)
            -- Menu update logic
        end,
        draw = function(self)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print("Welcome to Realms!", 10, 10)
            love.graphics.print("Press ENTER to start", 10, 30)
            love.graphics.print("Press ESC to quit", 10, 50)
        end,
        keypressed = function(self, key)
            if key == "return" or key == "kpenter" then
                src.core.StateManager.switch("game")
            elseif key == "escape" then
                love.event.quit()
            end
        end
    }

    -- Create game state
    local GameState = {
        name = "game",
        player = nil,
        npcs = {},
        enemies = {},
        craftingStations = {},
        hud = nil,
        inventoryUI = nil,
        showInventory = false,
        showDialogue = false,
        showCrafting = false,
        showQuestLog = false,
        enter = function(self)
            print("Entered game state")

            -- Create player
            local Player = require("src.entities.Player")
            self.player = Player.new(400, 300)
            self.player:load()

            -- Connect inventory to player
            local Inventory = require("src.inventory.Inventory")
            self.player.inventory = Inventory.new(30)
            self.player.stats:setLevel(1)

            -- Initialize HUD
            local HUD = require("src.ui.HUD")
            self.hud = HUD.new()
            src.ui.UIManager.addElement("hud", self.hud)

            -- Initialize Inventory UI
            local InventoryUI = require("src.ui.InventoryUI")
            self.inventoryUI = InventoryUI.new()
            self.inventoryUI.visible = false
            src.ui.UIManager.addElement("inventory", self.inventoryUI)

            -- Initialize Quest Log UI
            local QuestLogUI = require("src.ui.QuestLogUI")
            self.questLogUI = QuestLogUI.new()
            self.questLogUI.visible = false
            src.ui.UIManager.addElement("questlog", self.questLogUI)

            -- Initialize Crafting UI
            local CraftingUI = require("src.ui.CraftingUI")
            self.craftingUI = CraftingUI.new()
            self.craftingUI.visible = false
            src.ui.UIManager.addElement("crafting", self.craftingUI)

            -- Load starting realm
            local realm = src.world.World.loadRealm("starting_realm")
            if realm then
                -- Set up player collision
                if realm:getCollisionWorld() then
                    self.player:setCollisionWorld(realm:getCollisionWorld())
                end

                -- Set camera target and bounds
                src.core.Camera.setTarget(self.player)
                local bx, by, bw, bh = realm:getBounds()
                src.core.Camera.setBounds(bx, by, bw, bh)

                -- Add some NPCs to the world
                local NPC = require("src.entities.NPC")
                local npc1 = NPC.new(500, 300, {
                    name = "Villager",
                    dialogue = {
                        nodes = {
                            {
                                id = "start",
                                text = "Welcome to the realm! I have a quest for you.",
                                choices = {
                                    {
                                        text = "What quest?",
                                        next = "quest_info",
                                        action = {type = "quest", questId = "first_quest", action = "start"}
                                    },
                                    {
                                        text = "Maybe later.",
                                        next = "end"
                                    }
                                }
                            },
                            {
                                id = "quest_info",
                                text = "Talk to the other NPC to complete your first quest!",
                                choices = {
                                    {text = "Thanks!", next = "end"}
                                }
                            },
                            {
                                id = "end",
                                text = "Good luck!"
                            }
                        },
                        start = "start"
                    }
                })
                table.insert(self.npcs, npc1)

                -- Set player references for systems
                src.dialogue.DialogueSystem.setPlayer(self.player)
                src.quests.QuestSystem.setPlayer(self.player)

                -- Add some enemies
                local Enemy = require("src.entities.Enemy")
                local enemy1 = Enemy.new(600, 400, "basic")
                table.insert(self.enemies, enemy1)
                src.combat.CombatSystem.addEnemy(enemy1)

                local enemy2 = Enemy.new(700, 500, "basic")
                table.insert(self.enemies, enemy2)
                src.combat.CombatSystem.addEnemy(enemy2)

                -- Add crafting stations
                local CraftingStation = require("src.entities.CraftingStation")
                local forge = CraftingStation.new(300, 400, "forge")
                local forgeRecipes = src.data.Recipes.getRecipesByStation("forge")
                forge:setRecipes(forgeRecipes)
                table.insert(self.craftingStations, forge)

                local alchemy = CraftingStation.new(200, 500, "alchemy")
                local alchemyRecipes = src.data.Recipes.getRecipesByStation("alchemy")
                alchemy:setRecipes(alchemyRecipes)
                table.insert(self.craftingStations, alchemy)
            end
        end,
        update = function(self, dt)
            src.core.Input.update()

            -- Handle dialogue
            if src.dialogue.DialogueSystem.isActive() then
                -- Dialogue input handling
                if src.core.Input.wasPressed("interact") or src.core.Input.wasPressed("return") then
                    local choices = src.dialogue.DialogueSystem.getCurrentChoices()
                    if #choices > 0 then
                        src.dialogue.DialogueSystem.selectChoice(1)
                    else
                        src.dialogue.DialogueSystem.endDialogue()
                        self.showDialogue = false
                    end
                end
            else
                -- Update world
                src.world.World.update(dt)

                -- Update player
                if self.player then
                    self.player:update(dt, src.core.Input)

                    -- Check for NPC interactions
                    if src.core.Input.wasPressed("interact") then
                        for _, npc in ipairs(self.npcs) do
                            if npc:canPlayerInteract(self.player) then
                                src.dialogue.DialogueSystem.start(npc.dialogue, npc)
                                self.showDialogue = true
                                break
                            end
                        end

                        -- Check for crafting station interactions
                        if not self.showDialogue then
                            for _, station in ipairs(self.craftingStations) do
                                if station:canPlayerInteract(self.player) then
                                    self.craftingUI:open(station, src.crafting.CraftingSystem)
                                    self.showCrafting = true
                                    break
                                end
                            end
                        end
                    end

                    -- Toggle inventory
                    if src.core.Input.wasPressed("inventory") then
                        self.showInventory = not self.showInventory
                        self.inventoryUI.visible = self.showInventory
                    end

                    -- Toggle quest log
                    if src.core.Input.wasPressed("q") and not self.showInventory then
                        self.showQuestLog = not self.showQuestLog
                        self.questLogUI.visible = self.showQuestLog
                    end
                end

                -- Update NPCs
                for _, npc in ipairs(self.npcs) do
                    npc:update(dt)
                end

                -- Update crafting stations
                for _, station in ipairs(self.craftingStations) do
                    station:update(dt)
                end

                -- Save game (F5)
                if src.core.Input.wasPressed("f5") then
                    local saveData = {
                        player = {
                            x = self.player.x,
                            y = self.player.y,
                            stats = self.player.stats,
                            inventory = self.player.inventory,
                        },
                        activeQuests = src.quests.QuestSystem.getActiveQuests(),
                    }
                    src.save.SaveSystem.save(1, saveData)
                    print("Game saved!")
                end

                -- Load game (F9)
                if src.core.Input.wasPressed("f9") then
                    local saveData = src.save.SaveSystem.load(1)
                    if saveData and saveData.data then
                        -- Restore player position
                        if saveData.data.player then
                            self.player.x = saveData.data.player.x or self.player.x
                            self.player.y = saveData.data.player.y or self.player.y
                        end
                        print("Game loaded!")
                    end
                end

                -- Update combat system
                src.combat.CombatSystem.update(dt, self.player)

                -- Update enemies
                for i = #self.enemies, 1, -1 do
                    local enemy = self.enemies[i]
                    if enemy.active then
                        enemy:update(dt, self.player)
                    else
                        table.remove(self.enemies, i)
                    end
                end

                -- Update camera
                src.core.Camera.update(dt)
            end

            -- Update UI
            src.ui.UIManager.update(dt)
        end,
        draw = function(self)
            src.core.Resolution.begin()

            src.core.Camera.begin()

            -- Draw world
            src.world.World.draw()

            -- Draw NPCs
            for _, npc in ipairs(self.npcs) do
                npc:draw()
            end

            -- Draw crafting stations
            for _, station in ipairs(self.craftingStations) do
                station:draw()
            end

            -- Draw enemies
            for _, enemy in ipairs(self.enemies) do
                enemy:draw()
            end

            -- Draw player
            if self.player then
                self.player:draw()
            end

            src.core.Camera.finish()

            -- Draw UI
            if self.hud and self.player then
                self.hud:draw(self.player)
            end

            if self.inventoryUI and self.showInventory and self.player then
                self.inventoryUI:draw(self.player.inventory)
            end

            if self.questLogUI and self.showQuestLog then
                self.questLogUI:draw(src.quests.QuestSystem)
            end

            if self.craftingUI and self.showCrafting and self.player then
                self.craftingUI:draw(self.player.inventory)
            end

            -- Draw dialogue
            if self.showDialogue and src.dialogue.DialogueSystem.isActive() then
                local text = src.dialogue.DialogueSystem.getCurrentText()
                local choices = src.dialogue.DialogueSystem.getCurrentChoices()

                if text then
                    local font = src.core.AssetManager.getDefaultFont(14)
                    love.graphics.setFont(font)

                    -- Dialogue box
                    local boxWidth = 600
                    local boxHeight = 150
                    local boxX = (love.graphics.getWidth() - boxWidth) / 2
                    local boxY = love.graphics.getHeight() - boxHeight - 20

                    love.graphics.setColor(0, 0, 0, 0.8)
                    love.graphics.rectangle("fill", boxX, boxY, boxWidth, boxHeight)
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.rectangle("line", boxX, boxY, boxWidth, boxHeight)

                    -- Dialogue text
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.print(text, boxX + 10, boxY + 10)

                    -- Choices
                    if #choices > 0 then
                        for i, choice in ipairs(choices) do
                            local prefix = (i == 1 and "> " or "  ")
                            local yPos = boxY + 50 + (i - 1) * 20
                            love.graphics.print(prefix .. choice.text, boxX + 10, yPos)
                        end
                    end
                end
            end

            -- Debug info
            love.graphics.setColor(1, 1, 1)
            local font = src.core.AssetManager.getDefaultFont(12)
            love.graphics.setFont(font)
            love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)

            if self.player then
                local health, maxHealth = self.player:getHealth()
                love.graphics.print("Health: " .. math.floor(health) .. "/" .. maxHealth, 10, 25)
                love.graphics.print("I: Inventory | Q: Quest Log | E: Interact", 10, 40)
            end

            src.core.Resolution.finish()
        end,
        keypressed = function(self, key)
            if key == "escape" then
                -- Close any open UIs first
                if self.showInventory then
                    self.showInventory = false
                    self.inventoryUI.visible = false
                elseif self.showQuestLog then
                    self.showQuestLog = false
                    self.questLogUI.visible = false
                else
                    src.core.StateManager.switch("menu")
                end
            elseif self.questLogUI and self.showQuestLog then
                self.questLogUI:keypressed(key)
            elseif self.craftingUI and self.showCrafting and self.player then
                self.craftingUI:keypressed(key, self.player.inventory)
                if not self.craftingUI.visible then
                    self.showCrafting = false
                end
            end
        end
    }

    -- Register states
    src.core.StateManager.register("menu", MenuState)
    src.core.StateManager.register("game", GameState)

    -- Start with menu state
    src.core.StateManager.switch("menu")

    print(Game.title .. " v" .. Game.version .. " loaded!")
end

function love.update(dt)
    src.core.StateManager.update(dt)
end

function love.draw()
    src.core.StateManager.draw()
end

function love.keypressed(key, scancode, isrepeat)
    src.core.Input.keypressed(key, scancode, isrepeat)
    src.core.StateManager.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    src.core.Input.keyreleased(key, scancode)
    src.core.StateManager.keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
    src.core.Input.mousepressed(x, y, button, istouch, presses)
    src.core.StateManager.mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    src.core.Input.mousereleased(x, y, button, istouch, presses)
    src.core.StateManager.mousereleased(x, y, button, istouch, presses)
end

function love.resize(w, h)
    src.core.Resolution.resize(w, h)
end
