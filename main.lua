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

    -- Initialize exploration system
    src.world.Exploration = require("src.world.Exploration")
    src.world.Exploration.init()

    -- Initialize environment system
    src.world.Environment = require("src.world.Environment")
    src.world.Environment.init()

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

    -- Initialize magic system
    src.combat.MagicSystem = require("src.combat.MagicSystem")
    src.combat.MagicSystem.init()

    -- Load spell data
    src.data.Spells = require("src.data.Spells")
    for spellId, spellData in pairs(src.data.Spells.getAllSpells()) do
        src.combat.MagicSystem.registerSpell(spellId, spellData)
    end

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

    -- Initialize loot system
    src.inventory.Loot = require("src.inventory.Loot")
    src.inventory.Loot.init()

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
        showStats = false,
        showSkillTree = false,
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

            -- Give player starting spells
            self.player:learnSpell("heal")
            self.player:learnSpell("fireball")

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

            -- Initialize Stats UI
            local StatsUI = require("src.ui.StatsUI")
            self.statsUI = StatsUI.new()
            self.statsUI.visible = false
            src.ui.UIManager.addElement("stats", self.statsUI)

            -- Initialize Skill Tree UI
            local SkillTreeUI = require("src.ui.SkillTreeUI")
            self.skillTreeUI = SkillTreeUI.new()
            self.skillTreeUI.visible = false
            src.ui.UIManager.addElement("skilltree", self.skillTreeUI)

            -- Load starting realm
            local realm = src.world.World.loadRealm("starting_realm")
            if realm then
                -- Initialize exploration for realm
                src.world.Exploration.initFogOfWar(realm, false)

                -- Add some landmarks
                src.world.Exploration.addLandmark("Starting Point", realm.name, 400, 300, "town")
                src.world.Exploration.addLandmark("Ancient Ruins", realm.name, 800, 600, "dungeon")

                -- Add a portal to forest realm
                src.world.Exploration.addPortal(
                    "Forest Portal", realm.name, 1000, 500, "forest_realm", 200, 200
                )

                -- Set up player collision
                if realm:getCollisionWorld() then
                    self.player:setCollisionWorld(realm:getCollisionWorld())
                end

                -- Set camera target and bounds
                src.core.Camera.setTarget(self.player)
                local bx, by, bw, bh = realm:getBounds()
                src.core.Camera.setBounds(bx, by, bw, bh)

                -- Discover starting landmark
                src.world.Exploration.discoverLandmark("Starting Point")

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
                local choices = src.dialogue.DialogueSystem.getCurrentChoices()

                -- Arrow key navigation for choices
                if #choices > 0 then
                    if src.core.Input.wasPressed("up") then
                        local current = src.dialogue.DialogueSystem.getSelectedChoice()
                        src.dialogue.DialogueSystem.setSelectedChoice(current - 1)
                    elseif src.core.Input.wasPressed("down") then
                        local current = src.dialogue.DialogueSystem.getSelectedChoice()
                        src.dialogue.DialogueSystem.setSelectedChoice(current + 1)
                    end
                end

                -- Select choice or continue
                local interactPressed = src.core.Input.wasPressed("interact")
                    or src.core.Input.wasPressed("return")
                    or src.core.Input.wasPressed("kpenter")
                if interactPressed then
                    if #choices > 0 then
                        local selected = src.dialogue.DialogueSystem.getSelectedChoice()
                        src.dialogue.DialogueSystem.selectChoice(selected)
                    else
                        src.dialogue.DialogueSystem.endDialogue()
                        self.showDialogue = false
                    end
                end
            else
                -- Update world
                src.world.World.update(dt)

                -- Update environment
                src.world.Environment.update(dt)

                -- Update exploration (reveal fog of war around player)
                local currentRealm = src.world.World.getCurrentRealm()
                if currentRealm and self.player then
                    src.world.Exploration.revealArea(
                        currentRealm, self.player.x, self.player.y, 100
                    )
                end

                -- Update loot system
                src.inventory.Loot.update(dt)

                -- Auto-collect loot when player walks over it
                if self.player and self.player.inventory then
                    src.inventory.Loot.checkCollection(self.player, self.player.inventory)
                end

                -- Update player
                if self.player then
                    self.player:update(dt, src.core.Input)

                    -- Handle player attack
                    local canAct = not self.showDialogue and not self.showInventory
                        and not self.showQuestLog and not self.showStats
                        and not self.showCrafting
                    if src.core.Input.wasPressed("attack") and canAct then
                        self.player:attack(self.enemies)
                    end

                    -- Handle spell casting (1-4 keys for quick spells)
                    if canAct then
                        local knownSpells = self.player:getKnownSpells()
                        if src.core.Input.wasPressed("1") and knownSpells[1] then
                            self.player:castSpell(knownSpells[1].id, self.enemies)
                        elseif src.core.Input.wasPressed("2") and knownSpells[2] then
                            self.player:castSpell(knownSpells[2].id, self.enemies)
                        elseif src.core.Input.wasPressed("3") and knownSpells[3] then
                            self.player:castSpell(knownSpells[3].id, self.enemies)
                        elseif src.core.Input.wasPressed("4") and knownSpells[4] then
                            self.player:castSpell(knownSpells[4].id, self.enemies)
                        end
                    end

                    -- Handle item usage (F1-F4 for quick items)
                    if src.core.Input.wasPressed("f1") then
                        self.player:useQuickItem(1)
                    elseif src.core.Input.wasPressed("f2") then
                        self.player:useQuickItem(2)
                    elseif src.core.Input.wasPressed("f3") then
                        self.player:useQuickItem(3)
                    elseif src.core.Input.wasPressed("f4") then
                        self.player:useQuickItem(4)
                    end

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

                            -- Check for chest interactions
                            if not self.showCrafting and self.player.inventory then
                                src.inventory.Loot.checkChest(self.player, self.player.inventory)
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

                    -- Toggle stats
                    if src.core.Input.wasPressed("c") and not self.showInventory and not self.showQuestLog then
                        self.showStats = not self.showStats
                        self.statsUI.visible = self.showStats
                    end

                    -- Toggle skill tree
                    local canOpenSkillTree = not self.showInventory
                        and not self.showQuestLog and not self.showStats
                    if src.core.Input.wasPressed("k") and canOpenSkillTree then
                        self.showSkillTree = not self.showSkillTree
                        self.skillTreeUI.visible = self.showSkillTree
                    end

                    -- Toggle minimap
                    if src.core.Input.wasPressed("m") then
                        self.showMinimap = not self.showMinimap
                    end

                    -- Check for portal interactions
                    if currentRealm and self.player then
                        local portal = src.world.Exploration.checkPortal(
                            self.player, currentRealm
                        )
                        if portal and src.core.Input.wasPressed("interact") then
                            -- Travel through portal
                            local newRealm = src.world.World.loadRealm(portal.toRealm)
                            if newRealm then
                                self.player.x = portal.toX
                                self.player.y = portal.toY
                                if newRealm:getCollisionWorld() then
                                    self.player:setCollisionWorld(
                                        newRealm:getCollisionWorld()
                                    )
                                end
                                local bx, by, bw, bh = newRealm:getBounds()
                                src.core.Camera.setBounds(bx, by, bw, bh)
                                src.world.Exploration.initFogOfWar(newRealm, false)
                                print("Traveled to " .. newRealm.name)
                            end
                        end
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
                            facing = self.player.facing,
                            -- Stats
                            stats = {
                                level = self.player.stats.level,
                                experience = self.player.stats.experience,
                                experienceToNext = self.player.stats.experienceToNext,
                                health = self.player.stats.health,
                                maxHealth = self.player.stats.maxHealth,
                                mana = self.player.stats.mana,
                                maxMana = self.player.stats.maxMana,
                                strength = self.player.stats.strength,
                                dexterity = self.player.stats.dexterity,
                                intelligence = self.player.stats.intelligence,
                                vitality = self.player.stats.vitality,
                                wisdom = self.player.stats.wisdom,
                                luck = self.player.stats.luck,
                                statPoints = self.player.stats.statPoints,
                                skillPoints = self.player.stats.skillPoints,
                                skills = self.player.stats.skills,
                            },
                            -- Inventory
                            inventory = {
                                items = self.player.inventory.items,
                                equipped = self.player.inventory.equipped,
                            },
                            -- Spells
                            knownSpells = self.player.knownSpells,
                            -- Quick items
                            quickItems = self.player.quickItems,
                        },
                        -- Quest system
                        activeQuests = src.quests.QuestSystem.getActiveQuests(),
                        completedQuests = src.quests.QuestSystem.completedQuests or {},
                        -- Current realm
                        currentRealm = currentRealm and currentRealm.name or "starting_realm",
                        -- Exploration
                        exploration = {
                            fogOfWar = src.world.Exploration.fogOfWar,
                            landmarks = src.world.Exploration.landmarks,
                        },
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
                            local p = saveData.data.player
                            self.player.x = p.x or self.player.x
                            self.player.y = p.y or self.player.y
                            self.player.facing = p.facing or self.player.facing

                            -- Restore stats
                            if p.stats then
                                local s = self.player.stats
                                s.level = p.stats.level or s.level
                                s.experience = p.stats.experience or s.experience
                                s.experienceToNext = p.stats.experienceToNext or s.experienceToNext
                                s.health = p.stats.health or s.health
                                s.maxHealth = p.stats.maxHealth or s.maxHealth
                                s.mana = p.stats.mana or s.mana
                                s.maxMana = p.stats.maxMana or s.maxMana
                                s.strength = p.stats.strength or s.strength
                                s.dexterity = p.stats.dexterity or s.dexterity
                                s.intelligence = p.stats.intelligence or s.intelligence
                                s.vitality = p.stats.vitality or s.vitality
                                s.wisdom = p.stats.wisdom or s.wisdom
                                s.luck = p.stats.luck or s.luck
                                s.statPoints = p.stats.statPoints or s.statPoints
                                s.skillPoints = p.stats.skillPoints or s.skillPoints
                                if p.stats.skills then
                                    -- Restore skills with proper data references
                                    local Skills = require("src.data.Skills")
                                    s.skills = {}
                                    for skillId, skillData in pairs(p.stats.skills) do
                                        if skillData then
                                            s.skills[skillId] = {
                                                unlocked = skillData.unlocked,
                                                level = skillData.level,
                                                data = Skills.getSkill(skillId),
                                            }
                                        end
                                    end
                                end
                            end

                            -- Restore inventory
                            if p.inventory then
                                self.player.inventory.items = p.inventory.items or {}
                                self.player.inventory.equipped = p.inventory.equipped or {}
                            end

                            -- Restore spells
                            if p.knownSpells then
                                self.player.knownSpells = p.knownSpells
                            end

                            -- Restore quick items
                            if p.quickItems then
                                self.player.quickItems = p.quickItems
                            end
                        end

                        -- Restore quests
                        if saveData.data.activeQuests then
                            for _, questId in ipairs(saveData.data.activeQuests) do
                                src.quests.QuestSystem.startQuest(questId)
                            end
                        end
                        if saveData.data.completedQuests then
                            src.quests.QuestSystem.completedQuests = saveData.data.completedQuests
                        end

                        -- Restore realm
                        if saveData.data.currentRealm then
                            local realm = src.world.World.loadRealm(saveData.data.currentRealm)
                            if realm then
                                if realm:getCollisionWorld() then
                                    self.player:setCollisionWorld(realm:getCollisionWorld())
                                end
                                local bx, by, bw, bh = realm:getBounds()
                                src.core.Camera.setBounds(bx, by, bw, bh)
                            end
                        end

                        -- Restore exploration
                        if saveData.data.exploration then
                            if saveData.data.exploration.fogOfWar then
                                src.world.Exploration.fogOfWar = saveData.data.exploration.fogOfWar
                            end
                            if saveData.data.exploration.landmarks then
                                src.world.Exploration.landmarks = saveData.data.exploration.landmarks
                            end
                        end

                        print("Game loaded!")
                    end
                end

                -- Update combat system
                src.combat.CombatSystem.update(dt, self.player)

                -- Update magic system
                src.combat.MagicSystem.update(dt)

                -- Complete spell casting if cast time finished
                if self.player and self.player.castingSpell then
                    if self.player.castTimer <= 0 then
                        self.player:executeSpell(self.player.castingSpell, self.enemies)
                        self.player.castingSpell = nil
                    end
                end

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

            -- Draw fog of war
            local currentRealm = src.world.World.getCurrentRealm()
            if currentRealm then
                src.world.Exploration.drawFogOfWar(currentRealm)
            end

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

            -- Draw loot drops and chests
            src.inventory.Loot.draw()

            -- Draw player
            if self.player then
                self.player:draw()
            end

            src.core.Camera.finish()

            -- Apply environment lighting
            src.world.Environment.applyLighting()

            -- Draw weather effects
            src.world.Environment.drawWeather()

            -- Draw minimap
            if self.showMinimap and currentRealm and self.player then
                src.world.Exploration.drawMinimap(currentRealm, self.player)
            end

            -- Apply environment lighting
            src.world.Environment.applyLighting()

            -- Draw weather effects
            src.world.Environment.drawWeather()

            -- Draw minimap
            if self.showMinimap and currentRealm and self.player then
                src.world.Exploration.drawMinimap(currentRealm, self.player)
            end

            -- Draw UI
            if self.hud and self.player then
                self.hud:draw(self.player)
            end

            if self.inventoryUI and self.showInventory and self.player then
                self.inventoryUI:draw(self.player.inventory, self.player)
            end

            if self.questLogUI and self.showQuestLog then
                self.questLogUI:draw(src.quests.QuestSystem)
            end

            if self.craftingUI and self.showCrafting and self.player then
                self.craftingUI:draw(self.player.inventory)
            end

            if self.statsUI and self.showStats and self.player then
                self.statsUI:draw(self.player.stats)
            end

            if self.skillTreeUI and self.showSkillTree and self.player then
                self.skillTreeUI:draw(self.player.stats)
            end

            -- Draw dialogue
            if self.showDialogue and src.dialogue.DialogueSystem.isActive() then
                local text = src.dialogue.DialogueSystem.getCurrentText()
                local choices = src.dialogue.DialogueSystem.getCurrentChoices()
                local selectedChoice = src.dialogue.DialogueSystem.getSelectedChoice()
                local npc = src.dialogue.DialogueSystem.currentNPC

                if text then
                    local font = src.core.AssetManager.getDefaultFont(14)
                    love.graphics.setFont(font)

                    -- Calculate box size based on content
                    local boxWidth = 700
                    local textHeight = 60
                    local choiceHeight = #choices > 0 and (#choices * 30 + 20) or 0
                    local boxHeight = textHeight + choiceHeight + 40
                    local boxX = (love.graphics.getWidth() - boxWidth) / 2
                    local boxY = love.graphics.getHeight() - boxHeight - 30

                    -- Dialogue box background with border
                    love.graphics.setColor(0.05, 0.05, 0.1, 0.95)
                    love.graphics.rectangle("fill", boxX, boxY, boxWidth, boxHeight)
                    love.graphics.setColor(0.4, 0.6, 1)
                    love.graphics.setLineWidth(3)
                    love.graphics.rectangle("line", boxX, boxY, boxWidth, boxHeight)
                    love.graphics.setLineWidth(1)

                    -- NPC name (if available)
                    local textY = boxY + 15
                    if npc and npc.name then
                        love.graphics.setColor(1, 1, 0.5)
                        love.graphics.print(npc.name, boxX + 15, textY)
                        textY = textY + 25
                    end

                    -- Dialogue text with word wrapping
                    love.graphics.setColor(1, 1, 1)
                    local textX = boxX + 15
                    local maxWidth = boxWidth - 30
                    local lines = {}
                    local words = {}
                    for word in text:gmatch("%S+") do
                        table.insert(words, word)
                    end

                    local currentLine = ""
                    for _, word in ipairs(words) do
                        local testLine = currentLine == "" and word or currentLine .. " " .. word
                        local width = font:getWidth(testLine)
                        if width > maxWidth and currentLine ~= "" then
                            table.insert(lines, currentLine)
                            currentLine = word
                        else
                            currentLine = testLine
                        end
                    end
                    if currentLine ~= "" then
                        table.insert(lines, currentLine)
                    end

                    for i, line in ipairs(lines) do
                        love.graphics.print(line, textX, textY)
                        textY = textY + 20
                    end

                    -- Choices with selection indicator
                    if #choices > 0 then
                        textY = textY + 10
                        love.graphics.setColor(0.3, 0.3, 0.3)
                        love.graphics.rectangle("fill", boxX + 10, textY, boxWidth - 20, choiceHeight - 10)

                        for i, choice in ipairs(choices) do
                            local choiceY = textY + 10 + (i - 1) * 30

                            if i == selectedChoice then
                                -- Highlight selected choice
                                love.graphics.setColor(0.2, 0.4, 0.8, 0.5)
                                love.graphics.rectangle("fill", boxX + 15, choiceY - 2, boxWidth - 30, 28)
                                love.graphics.setColor(1, 1, 0.5)
                                love.graphics.print("> " .. choice.text, boxX + 25, choiceY + 5)
                            else
                                love.graphics.setColor(0.8, 0.8, 0.8)
                                love.graphics.print("  " .. choice.text, boxX + 25, choiceY + 5)
                            end
                        end

                        -- Navigation hint
                        love.graphics.setColor(0.6, 0.6, 0.6)
                        love.graphics.print("↑↓ to select, ENTER to choose", boxX + 15, boxY + boxHeight - 20)
                    else
                        -- Continue hint
                        love.graphics.setColor(0.6, 0.6, 0.6)
                        love.graphics.print("Press ENTER to continue", boxX + 15, boxY + boxHeight - 20)
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
                local knownSpells = self.player:getKnownSpells()
                local spellText = "I: Inventory | Q: Quest Log | C: Stats | K: Skills | "
                    .. "M: Minimap | E: Interact | J/Z: Attack"
                if #knownSpells > 0 then
                    spellText = spellText .. " | 1-4: Spells"
                end
                love.graphics.print(spellText, 10, 40)

                -- Show time of day
                local timeOfDay = src.world.Environment.getTimeOfDay()
                love.graphics.print("Time: " .. timeOfDay, 10, love.graphics.getHeight() - 20)

                -- Show known spells with cooldowns
                if #knownSpells > 0 then
                    local spellY = 55
                    for i, spell in ipairs(knownSpells) do
                        if spell.data then
                            local Spells = require("src.data.Spells")
                            local spellData = Spells.getSpell(spell.id)
                            local cooldown = spellData and spellData.cooldown or 0
                            local manaText = string.format(
                                "%d: %s (%d mana)", i, spell.data.name, spell.data.manaCost
                            )
                            if cooldown > 0 then
                                manaText = manaText .. string.format(" [CD: %.1fs]", cooldown)
                            end
                            love.graphics.print(manaText, 10, spellY)
                            spellY = spellY + 15
                        end
                    end
                end

                -- Show equipped items
                if self.player.inventory and self.player.inventory.equipped then
                    local equipText = "Equipped: "
                    local Items = require("src.data.Items")
                    if self.player.inventory.equipped.weapon then
                        local itemData = Items.getItem(self.player.inventory.equipped.weapon)
                        if itemData then
                            equipText = equipText .. "W:" .. itemData.name .. " "
                        end
                    end
                    if self.player.inventory.equipped.armor then
                        local itemData = Items.getItem(self.player.inventory.equipped.armor)
                        if itemData then
                            equipText = equipText .. "A:" .. itemData.name .. " "
                        end
                    end
                    if equipText ~= "Equipped: " then
                        love.graphics.print(equipText, 10, love.graphics.getHeight() - 60)
                    end
                end

                -- Show quick items
                if self.player.quickItems then
                    local quickText = "Quick Items: "
                    for i = 1, 4 do
                        local itemId = self.player:getQuickItem(i)
                        if itemId then
                            local Items = require("src.data.Items")
                            local itemData = Items.getItem(itemId)
                            if itemData then
                                local key = "F" .. i
                                local cd = self.player.itemCooldowns[itemId] or 0
                                if cd > 0 then
                                    quickText = quickText .. key .. "["
                                        .. string.format("%.1f", cd) .. "] "
                                else
                                    quickText = quickText .. key .. " "
                                end
                            end
                        end
                    end
                    if quickText ~= "Quick Items: " then
                        love.graphics.print(quickText, 10, love.graphics.getHeight() - 40)
                    end
                end
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
                elseif self.showStats then
                    self.showStats = false
                    self.statsUI.visible = false
                elseif self.showSkillTree then
                    self.showSkillTree = false
                    self.skillTreeUI.visible = false
                elseif self.showCrafting then
                    self.showCrafting = false
                    self.craftingUI:close()
                else
                    src.core.StateManager.switch("menu")
                end
            elseif self.questLogUI and self.showQuestLog then
                self.questLogUI:keypressed(key)
            elseif self.inventoryUI and self.showInventory and self.player then
                self.inventoryUI:keypressed(key, self.player.inventory, self.player)
                if not self.inventoryUI.visible then
                    self.showInventory = false
                end
            elseif self.craftingUI and self.showCrafting and self.player then
                self.craftingUI:keypressed(key, self.player.inventory)
                if not self.craftingUI.visible then
                    self.showCrafting = false
                end
            elseif self.statsUI and self.showStats and self.player then
                self.statsUI:keypressed(key, self.player.stats)
                if not self.statsUI.visible then
                    self.showStats = false
                end
            elseif self.skillTreeUI and self.showSkillTree and self.player then
                self.skillTreeUI:keypressed(key, self.player.stats)
                if not self.skillTreeUI.visible then
                    self.showSkillTree = false
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
