--[[
    Quest Log UI
    Displays active and completed quests with objectives
]]

local QuestLogUI = {}
QuestLogUI.visible = false
QuestLogUI.selectedTab = "active" -- "active" or "completed"
QuestLogUI.selectedQuest = 1

function QuestLogUI.new()
    local self = {}
    self.visible = false
    self.selectedTab = "active"
    self.selectedQuest = 1
    return self
end

function QuestLogUI:toggle()
    self.visible = not self.visible
end

function QuestLogUI:draw(questSystem)
    if not self.visible or not questSystem then return end

    local width = 600
    local height = 500
    local x = (love.graphics.getWidth() - width) / 2
    local y = (love.graphics.getHeight() - height) / 2

    -- Background
    love.graphics.setColor(0.1, 0.1, 0.1, 0.95)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("line", x, y, width, height)

    -- Title
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Quest Log", x + 20, y + 20)

    -- Tabs
    local tabWidth = 100
    local tabHeight = 30
    local tabY = y + 50

    -- Active tab
    if self.selectedTab == "active" then
        love.graphics.setColor(0.3, 0.5, 0.8)
    else
        love.graphics.setColor(0.2, 0.2, 0.2)
    end
    love.graphics.rectangle("fill", x + 20, tabY, tabWidth, tabHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x + 20, tabY, tabWidth, tabHeight)
    love.graphics.print("Active", x + 30, tabY + 8)

    -- Completed tab
    if self.selectedTab == "completed" then
        love.graphics.setColor(0.3, 0.5, 0.8)
    else
        love.graphics.setColor(0.2, 0.2, 0.2)
    end
    love.graphics.rectangle("fill", x + 130, tabY, tabWidth, tabHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x + 130, tabY, tabWidth, tabHeight)
    love.graphics.print("Completed", x + 140, tabY + 8)

    -- Quest list area
    local listX = x + 20
    local listY = tabY + tabHeight + 10
    local listWidth = 200
    local listHeight = height - (listY - y) - 20

    love.graphics.setColor(0.15, 0.15, 0.15)
    love.graphics.rectangle("fill", listX, listY, listWidth, listHeight)
    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.rectangle("line", listX, listY, listWidth, listHeight)

    -- Get quests based on selected tab
    local quests = {}
    if self.selectedTab == "active" then
        local activeIds = questSystem.getActiveQuests()
        for _, questId in ipairs(activeIds) do
            table.insert(quests, questSystem.getQuest(questId))
        end
    else
        local completedIds = questSystem.getCompletedQuests()
        for _, questId in ipairs(completedIds) do
            table.insert(quests, questSystem.getQuest(questId))
        end
    end

    -- Draw quest list
    local questY = listY + 10
    for i, quest in ipairs(quests) do
        if i == self.selectedQuest then
            love.graphics.setColor(0.3, 0.5, 0.8)
            love.graphics.rectangle("fill", listX + 5, questY - 2, listWidth - 10, 25)
        end
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(quest.name or "Unknown Quest", listX + 10, questY)
        questY = questY + 30
    end

    -- Quest details area
    local detailsX = listX + listWidth + 10
    local detailsY = listY
    local detailsWidth = width - (detailsX - x) - 20
    local detailsHeight = listHeight

    love.graphics.setColor(0.15, 0.15, 0.15)
    love.graphics.rectangle("fill", detailsX, detailsY, detailsWidth, detailsHeight)
    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.rectangle("line", detailsX, detailsY, detailsWidth, detailsHeight)

    -- Draw selected quest details
    if #quests > 0 and self.selectedQuest <= #quests then
        local quest = quests[self.selectedQuest]
        local textY = detailsY + 20

        -- Quest name
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.print(quest.name or "Unknown Quest", detailsX + 10, textY)
        textY = textY + 30

        -- Quest description
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.print(quest.description or "No description", detailsX + 10, textY)
        textY = textY + 40

        -- Objectives
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Objectives:", detailsX + 10, textY)
        textY = textY + 25

        if quest.objectives then
            for _, objective in ipairs(quest.objectives) do
                local progress = quest.progress and quest.progress[objective.id]
                local completed = progress and progress.completed or false
                local current = progress and progress.current or 0
                local target = objective.target or 1

                if completed then
                    love.graphics.setColor(0.3, 1, 0.3)
                else
                    love.graphics.setColor(1, 1, 1)
                end

                local objectiveText = objective.description or "Unknown objective"
                local progressText = string.format(" (%d/%d)", current, target)
                love.graphics.print("• " .. objectiveText .. progressText, detailsX + 20, textY)
                textY = textY + 25
            end
        end

        -- Rewards
        if quest.rewards then
            textY = textY + 10
            love.graphics.setColor(1, 1, 0.5)
            love.graphics.print("Rewards:", detailsX + 10, textY)
            textY = textY + 25

            love.graphics.setColor(1, 1, 1)
            if quest.rewards.experience then
                love.graphics.print("• Experience: " .. quest.rewards.experience, detailsX + 20, textY)
                textY = textY + 25
            end

            if quest.rewards.items then
                for _, item in ipairs(quest.rewards.items) do
                    local Items = require("src.data.Items")
                    local itemData = Items.getItem(item.id)
                    local itemName = itemData and itemData.name or item.id
                    love.graphics.print("• " .. itemName .. " x" .. (item.quantity or 1), detailsX + 20, textY)
                    textY = textY + 25
                end
            end
        end
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.print("No quests available", detailsX + 10, detailsY + 20)
    end

    -- Close hint
    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.print("Press Q to close", x + width - 150, y + height - 25)
end

function QuestLogUI:keypressed(key)
    if not self.visible then return end

    if key == "q" or key == "escape" then
        self.visible = false
        return
    end

    if key == "tab" then
        -- Switch tabs
        if self.selectedTab == "active" then
            self.selectedTab = "completed"
        else
            self.selectedTab = "active"
        end
        self.selectedQuest = 1
        return
    end

    -- Arrow keys for quest selection
    local questSystem = require("src.quests.QuestSystem")
    local quests = {}
    if self.selectedTab == "active" then
        local activeIds = questSystem.getActiveQuests()
        for _, questId in ipairs(activeIds) do
            table.insert(quests, questSystem.getQuest(questId))
        end
    else
        local completedIds = questSystem.getCompletedQuests()
        for _, questId in ipairs(completedIds) do
            table.insert(quests, questSystem.getQuest(questId))
        end
    end

    if key == "up" then
        self.selectedQuest = math.max(1, self.selectedQuest - 1)
    elseif key == "down" then
        self.selectedQuest = math.min(#quests, self.selectedQuest + 1)
    end
end

return QuestLogUI

