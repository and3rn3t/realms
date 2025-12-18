--[[
    Item Data Definitions
    Defines all items in the game
]]

local Items = {}

Items.rarity = {
    common = {name = "Common", color = {1, 1, 1}},
    uncommon = {name = "Uncommon", color = {0.2, 1, 0.2}},
    rare = {name = "Rare", color = {0.2, 0.5, 1}},
    epic = {name = "Epic", color = {0.8, 0.2, 1}},
    legendary = {name = "Legendary", color = {1, 0.8, 0.2}},
}

Items.data = {
    -- Weapons
    sword_basic = {
        name = "Basic Sword",
        type = "weapon",
        rarity = "common",
        damage = 10,
        value = 50,
    },
    sword_iron = {
        name = "Iron Sword",
        type = "weapon",
        rarity = "uncommon",
        damage = 20,
        value = 150,
    },

    -- Armor
    armor_leather = {
        name = "Leather Armor",
        type = "armor",
        rarity = "common",
        defense = 5,
        value = 40,
    },

    -- Consumables
    potion_health = {
        name = "Health Potion",
        type = "consumable",
        rarity = "common",
        effect = "heal",
        value = 50,
        amount = 25,
    },
    potion_mana = {
        name = "Mana Potion",
        type = "consumable",
        rarity = "common",
        effect = "mana",
        value = 50,
        amount = 25,
    },
}

function Items.getItem(id)
    return Items.data[id]
end

function Items.getAllItems()
    return Items.data
end

function Items.getRarityColor(rarity)
    local r = Items.rarity[rarity]
    if r then
        return r.color[1], r.color[2], r.color[3]
    end
    return 1, 1, 1
end

return Items

