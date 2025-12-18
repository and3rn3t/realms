--[[
    Quest System
    Handles quests, objectives, and completion
]]

local QuestSystem = {}
QuestSystem.quests = {}
QuestSystem.activeQuests = {}
QuestSystem.completedQuests = {}

-- Initialize quest system
function QuestSystem.init()
    QuestSystem.quests = {}
    QuestSystem.activeQuests = {}
    QuestSystem.completedQuests = {}
end

-- Register a quest
function QuestSystem.registerQuest(questId, questData)
    QuestSystem.quests[questId] = questData
end

-- Start a quest
function QuestSystem.startQuest(questId)
    if not QuestSystem.quests[questId] then
        return false
    end

    if QuestSystem.isActive(questId) or QuestSystem.isCompleted(questId) then
        return false
    end

    local quest = QuestSystem.quests[questId]
    quest.state = "active"
    quest.progress = {}

    -- Initialize objectives
    if quest.objectives then
        for _, objective in ipairs(quest.objectives) do
            quest.progress[objective.id] = {
                current = 0,
                target = objective.target,
                completed = false,
            }
        end
    end

    table.insert(QuestSystem.activeQuests, questId)
    return true
end

-- Update quest progress
function QuestSystem.updateProgress(questId, objectiveId, amount)
    if not QuestSystem.isActive(questId) then
        return false
    end

    local quest = QuestSystem.quests[questId]
    if not quest.progress[objectiveId] then
        return false
    end

    quest.progress[objectiveId].current = quest.progress[objectiveId].current + amount

    if quest.progress[objectiveId].current >= quest.progress[objectiveId].target then
        quest.progress[objectiveId].completed = true
        quest.progress[objectiveId].current = quest.progress[objectiveId].target
    end

    -- Check if all objectives completed
    local allCompleted = true
    for _, prog in pairs(quest.progress) do
        if not prog.completed then
            allCompleted = false
            break
        end
    end

    if allCompleted then
        QuestSystem.completeQuest(questId)
    end

    return true
end

-- Complete a quest
function QuestSystem.completeQuest(questId)
    if not QuestSystem.isActive(questId) then
        return false
    end

    local quest = QuestSystem.quests[questId]
    quest.state = "completed"

    -- Remove from active
    for i, qid in ipairs(QuestSystem.activeQuests) do
        if qid == questId then
            table.remove(QuestSystem.activeQuests, i)
            break
        end
    end

    -- Add to completed
    table.insert(QuestSystem.completedQuests, questId)

    -- Give rewards
    if quest.rewards then
        -- Give experience
        if quest.rewards.experience then
            -- Would need player reference
        end

        -- Give items
        if quest.rewards.items then
            -- Would need inventory reference
        end
    end

    return true
end

-- Check if quest is active
function QuestSystem.isActive(questId)
    for _, qid in ipairs(QuestSystem.activeQuests) do
        if qid == questId then
            return true
        end
    end
    return false
end

-- Check if quest is completed
function QuestSystem.isCompleted(questId)
    for _, qid in ipairs(QuestSystem.completedQuests) do
        if qid == questId then
            return true
        end
    end
    return false
end

-- Get active quests
function QuestSystem.getActiveQuests()
    return QuestSystem.activeQuests
end

-- Get quest data
function QuestSystem.getQuest(questId)
    return QuestSystem.quests[questId]
end

return QuestSystem

