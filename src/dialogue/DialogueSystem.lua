--[[
    Dialogue System
    Handles dialogue with branching and conditional responses
]]

local DialogueSystem = {}
DialogueSystem.currentDialogue = nil
DialogueSystem.currentNode = nil
DialogueSystem.currentNPC = nil
DialogueSystem.history = {}
DialogueSystem.selectedChoice = 1

-- Initialize dialogue system
function DialogueSystem.init()
    DialogueSystem.currentDialogue = nil
    DialogueSystem.currentNode = nil
    DialogueSystem.history = {}
end

-- Start dialogue
function DialogueSystem.start(dialogue, npc)
    DialogueSystem.currentDialogue = dialogue
    DialogueSystem.currentNode = dialogue.start or dialogue.nodes[1]
    DialogueSystem.currentNPC = npc
    DialogueSystem.selectedChoice = 1
end

-- Get current dialogue text
function DialogueSystem.getCurrentText()
    if not DialogueSystem.currentNode then
        return nil
    end

    return DialogueSystem.currentNode.text
end

-- Get current choices
function DialogueSystem.getCurrentChoices()
    if not DialogueSystem.currentNode then
        return {}
    end

    local choices = {}
    if DialogueSystem.currentNode.choices then
        for i, choice in ipairs(DialogueSystem.currentNode.choices) do
            -- Check conditions
            if not choice.condition or DialogueSystem.checkCondition(choice.condition) then
                table.insert(choices, {
                    text = choice.text,
                    next = choice.next,
                    action = choice.action,
                })
            end
        end
    end

    return choices
end

-- Select choice
function DialogueSystem.selectChoice(index)
    if not DialogueSystem.currentNode or not DialogueSystem.currentNode.choices then
        return
    end

    local choices = DialogueSystem.getCurrentChoices()
    if index < 1 or index > #choices then
        return
    end

    local choice = choices[index]
    if not choice then
        return
    end

    -- Execute action
    if choice.action then
        DialogueSystem.executeAction(choice.action)
    end

    -- Move to next node
    if choice.next then
        DialogueSystem.currentNode = DialogueSystem.findNode(choice.next)
        DialogueSystem.selectedChoice = 1
    else
        DialogueSystem.endDialogue()
    end
end

-- Get selected choice index
function DialogueSystem.getSelectedChoice()
    return DialogueSystem.selectedChoice
end

-- Set selected choice index
function DialogueSystem.setSelectedChoice(index)
    local choices = DialogueSystem.getCurrentChoices()
    DialogueSystem.selectedChoice = math.max(1, math.min(#choices, index))
end

-- Set player reference for actions
function DialogueSystem.setPlayer(player)
    DialogueSystem.player = player
end

-- Check condition
function DialogueSystem.checkCondition(condition)
    if not condition then return true end

    -- Simple condition checking (can be expanded)
    if condition.type == "quest" then
        -- Check quest state
        local QuestSystem = require("src.quests.QuestSystem")
        if condition.state == "completed" then
            return QuestSystem.isCompleted(condition.questId)
        elseif condition.state == "active" then
            return QuestSystem.isActive(condition.questId)
        elseif condition.state == "not_started" then
            return not QuestSystem.isActive(condition.questId) and not QuestSystem.isCompleted(condition.questId)
        end
        return true
    elseif condition.type == "item" then
        -- Check item in inventory
        if DialogueSystem.player and DialogueSystem.player.inventory then
            return DialogueSystem.player.inventory:hasItem(condition.itemId, condition.quantity or 1)
        end
        return false
    end
    return true
end

-- Execute action
function DialogueSystem.executeAction(action)
    if not action then return end

    if action.type == "quest" then
        -- Start/complete quest
        local QuestSystem = require("src.quests.QuestSystem")
        if action.action == "start" then
            QuestSystem.startQuest(action.questId)
        elseif action.action == "complete" then
            QuestSystem.completeQuest(action.questId)
        end
    elseif action.type == "give_item" then
        -- Give item to player
        if DialogueSystem.player and DialogueSystem.player.inventory then
            DialogueSystem.player.inventory:addItem(action.itemId, action.quantity or 1)
        end
    elseif action.type == "take_item" then
        -- Take item from player
        if DialogueSystem.player and DialogueSystem.player.inventory then
            DialogueSystem.player.inventory:removeItem(action.itemId, action.quantity or 1)
        end
    end
end

-- Find node by ID
function DialogueSystem.findNode(nodeId)
    if not DialogueSystem.currentDialogue or not DialogueSystem.currentDialogue.nodes then
        return nil
    end

    for _, node in ipairs(DialogueSystem.currentDialogue.nodes) do
        if node.id == nodeId then
            return node
        end
    end

    return nil
end

-- End dialogue
function DialogueSystem.endDialogue()
    DialogueSystem.currentDialogue = nil
    DialogueSystem.currentNode = nil
    DialogueSystem.currentNPC = nil
    DialogueSystem.selectedChoice = 1
end

-- Is dialogue active
function DialogueSystem.isActive()
    return DialogueSystem.currentDialogue ~= nil
end

return DialogueSystem

