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
    sword_steel = {
        name = "Steel Sword",
        type = "weapon",
        rarity = "rare",
        damage = 35,
        value = 400,
    },
    sword_magic = {
        name = "Magic Sword",
        type = "weapon",
        rarity = "epic",
        damage = 50,
        magicDamage = 20,
        value = 1000,
    },
    staff_basic = {
        name = "Basic Staff",
        type = "weapon",
        rarity = "common",
        damage = 5,
        magicDamage = 15,
        value = 60,
    },
    staff_arcane = {
        name = "Arcane Staff",
        type = "weapon",
        rarity = "rare",
        damage = 10,
        magicDamage = 40,
        value = 500,
    },

    -- Armor
    armor_leather = {
        name = "Leather Armor",
        type = "armor",
        rarity = "common",
        defense = 5,
        value = 40,
    },
    armor_chain = {
        name = "Chain Mail",
        type = "armor",
        rarity = "uncommon",
        defense = 12,
        value = 200,
    },
    armor_plate = {
        name = "Plate Armor",
        type = "armor",
        rarity = "rare",
        defense = 25,
        value = 600,
    },
    armor_magic = {
        name = "Enchanted Robes",
        type = "armor",
        rarity = "epic",
        defense = 15,
        magicResist = 30,
        value = 1200,
    },

    -- Consumables
    potion_health = {
        name = "Health Potion",
        type = "consumable",
        rarity = "common",
        effect = "heal",
        stackable = true,
        maxStack = 99,
        value = 50,
        amount = 25,
    },
    potion_health_greater = {
        name = "Greater Health Potion",
        type = "consumable",
        rarity = "uncommon",
        effect = "heal",
        stackable = true,
        maxStack = 99,
        value = 150,
        amount = 75,
    },
    potion_mana = {
        name = "Mana Potion",
        type = "consumable",
        rarity = "common",
        effect = "mana",
        stackable = true,
        maxStack = 99,
        value = 50,
        amount = 25,
    },
    potion_mana_greater = {
        name = "Greater Mana Potion",
        type = "consumable",
        rarity = "uncommon",
        effect = "mana",
        stackable = true,
        maxStack = 99,
        value = 150,
        amount = 75,
    },
    potion_elixir = {
        name = "Elixir of Power",
        type = "consumable",
        rarity = "rare",
        effect = "buff",
        stackable = true,
        maxStack = 10,
        value = 500,
        buffDuration = 300,
    },

    -- Materials
    iron_ore = {
        name = "Iron Ore",
        type = "material",
        rarity = "common",
        stackable = true,
        maxStack = 99,
        value = 10,
    },
    steel_ingot = {
        name = "Steel Ingot",
        type = "material",
        rarity = "uncommon",
        stackable = true,
        maxStack = 99,
        value = 50,
    },
    magic_crystal = {
        name = "Magic Crystal",
        type = "material",
        rarity = "rare",
        stackable = true,
        maxStack = 50,
        value = 200,
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

