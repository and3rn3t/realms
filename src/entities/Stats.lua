--[[
    Character Stats System
    Handles health, mana, attributes, leveling, and skill trees
]]

local Stats = {}
Stats.__index = Stats

function Stats.new()
    local self = setmetatable({}, Stats)

    -- Base stats
    self.level = 1
    self.experience = 0
    self.experienceToNext = 100

    -- Vital stats
    self.health = 100
    self.maxHealth = 100
    self.mana = 50
    self.maxMana = 50

    -- Attributes
    self.strength = 10
    self.dexterity = 10
    self.intelligence = 10
    self.vitality = 10
    self.wisdom = 10
    self.luck = 10

    -- Stat points available
    self.statPoints = 0

    -- Skills (skill tree)
    self.skills = {}
    self.skillPoints = 0

    return self
end

function Stats:addExperience(amount)
    self.experience = self.experience + amount

    while self.experience >= self.experienceToNext do
        self:levelUp()
    end
end

function Stats:levelUp()
    self.experience = self.experience - self.experienceToNext
    self.level = self.level + 1
    self.statPoints = self.statPoints + 5
    self.skillPoints = self.skillPoints + 1

    -- Increase experience needed (exponential)
    self.experienceToNext = math.floor(self.experienceToNext * 1.2)

    -- Increase max health and mana
    self.maxHealth = self.maxHealth + self.vitality * 2
    self.maxMana = self.maxMana + self.wisdom * 2

    -- Restore health and mana on level up
    self.health = self.maxHealth
    self.mana = self.maxMana

    return true
end

function Stats:setHealth(health)
    self.health = math.max(0, math.min(self.maxHealth, health))
end

function Stats:setMana(mana)
    self.mana = math.max(0, math.min(self.maxMana, mana))
end

function Stats:addHealth(amount)
    self:setHealth(self.health + amount)
end

function Stats:addMana(amount)
    self:setMana(self.mana + amount)
end

function Stats:spendStatPoint(stat)
    if self.statPoints <= 0 then
        return false
    end

    if stat == "strength" then
        self.strength = self.strength + 1
    elseif stat == "dexterity" then
        self.dexterity = self.dexterity + 1
    elseif stat == "intelligence" then
        self.intelligence = self.intelligence + 1
    elseif stat == "vitality" then
        self.vitality = self.vitality + 1
        self.maxHealth = self.maxHealth + 2
    elseif stat == "wisdom" then
        self.wisdom = self.wisdom + 1
        self.maxMana = self.maxMana + 2
    elseif stat == "luck" then
        self.luck = self.luck + 1
    else
        return false
    end

    self.statPoints = self.statPoints - 1
    return true
end

function Stats:unlockSkill(skillId, skillData)
    if self.skillPoints <= 0 then
        return false
    end

    -- Check prerequisites
    if skillData.prerequisites then
        for _, prereq in ipairs(skillData.prerequisites) do
            if not self.skills[prereq] then
                return false
            end
        end
    end

    -- Unlock skill
    self.skills[skillId] = {
        unlocked = true,
        level = 1,
        data = skillData,
    }

    self.skillPoints = self.skillPoints - 1
    return true
end

function Stats:upgradeSkill(skillId)
    if not self.skills[skillId] then
        return false
    end

    local skill = self.skills[skillId]
    if skill.level >= (skill.data.maxLevel or 5) then
        return false
    end

    if self.skillPoints <= 0 then
        return false
    end

    skill.level = skill.level + 1
    self.skillPoints = self.skillPoints - 1
    return true
end

function Stats:hasSkill(skillId)
    return self.skills[skillId] ~= nil
end

function Stats:getSkillLevel(skillId)
    if not self.skills[skillId] then
        return 0
    end
    return self.skills[skillId].level
end

function Stats:getDamage()
    return self.strength * 2
end

function Stats:getDefense()
    return self.vitality * 1.5
end

function Stats:getMagicDamage()
    return self.intelligence * 2
end

function Stats:getCriticalChance()
    return self.dexterity * 0.5 + self.luck * 0.3
end

function Stats:getCriticalDamage()
    return 1.5 + self.dexterity * 0.01
end

return Stats

