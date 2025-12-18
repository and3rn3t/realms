--[[
    Dialogue System
    Handles dialogue with branching and conditional responses
]]

local DialogueSystem = {}
DialogueSystem.currentDialogue = nil
DialogueSystem.currentNode = nil
DialogueSystem.history = {}

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

    local choice = DialogueSystem.currentNode.choices[index]
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
    else
        DialogueSystem.endDialogue()
    end
end

-- Check condition
function DialogueSystem.checkCondition(condition)
    -- Simple condition checking (can be expanded)
    if condition.type == "quest" then
        -- Check quest state
        return true -- Placeholder
    elseif condition.type == "item" then
        -- Check item in inventory
        return true -- Placeholder
    end
    return true
end

-- Execute action
function DialogueSystem.executeAction(action)
    if action.type == "quest" then
        -- Start/complete quest
    elseif action.type == "give_item" then
        -- Give item to player
    elseif action.type == "take_item" then
        -- Take item from player
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
end

-- Is dialogue active
function DialogueSystem.isActive()
    return DialogueSystem.currentDialogue ~= nil
end

return DialogueSystem

