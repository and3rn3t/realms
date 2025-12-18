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

    -- Apply skill effects
    self:applySkillEffectsOnUnlock(skillId, skillData)

    return true
end

-- Apply skill effects when unlocked
function Stats:applySkillEffectsOnUnlock(skillId, skillData)
    if skillData.effects then
        if skillData.effects.maxHealth then
            self.maxHealth = self.maxHealth + skillData.effects.maxHealth
            self.health = self.health + skillData.effects.maxHealth
        end
        if skillData.effects.maxMana then
            self.maxMana = self.maxMana + skillData.effects.maxMana
            self.mana = self.mana + skillData.effects.maxMana
        end
    end
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

    -- Apply skill effects on upgrade
    if skill.data and skill.data.effects then
        if skill.data.effects.maxHealth then
            self.maxHealth = self.maxHealth + skill.data.effects.maxHealth
            self.health = self.health + skill.data.effects.maxHealth
        end
        if skill.data.effects.maxMana then
            self.maxMana = self.maxMana + skill.data.effects.maxMana
            self.mana = self.mana + skill.data.effects.maxMana
        end
    end

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
    local damage = self.strength * 2

    -- Apply skill bonuses
    if self.skills.combat_mastery then
        local skill = self.skills.combat_mastery
        if skill.data and skill.data.effects and skill.data.effects.damage then
            damage = damage + (skill.data.effects.damage * skill.level)
        end
    end

    return damage
end

function Stats:getDefense()
    local defense = self.vitality * 1.5

    -- Apply skill bonuses
    if self.skills.defensive_stance then
        local skill = self.skills.defensive_stance
        if skill.data and skill.data.effects and skill.data.effects.defense then
            defense = defense + (skill.data.effects.defense * skill.level)
        end
    end

    return defense
end

function Stats:getMagicDamage()
    local magicDamage = self.intelligence * 2

    -- Apply skill bonuses
    if self.skills.spell_power then
        local skill = self.skills.spell_power
        if skill.data and skill.data.effects and skill.data.effects.magicDamage then
            magicDamage = magicDamage + (skill.data.effects.magicDamage * skill.level)
        end
    end

    return magicDamage
end

function Stats:getCriticalChance()
    local critChance = self.dexterity * 0.5 + self.luck * 0.3

    -- Apply skill bonuses
    if self.skills.critical_strike then
        local skill = self.skills.critical_strike
        if skill.data and skill.data.effects and skill.data.effects.critChance then
            critChance = critChance + (skill.data.effects.critChance * skill.level)
        end
    end

    return critChance
end

function Stats:getCriticalDamage()
    local critDamage = 1.5 + self.dexterity * 0.01

    -- Apply skill bonuses
    if self.skills.critical_strike then
        local skill = self.skills.critical_strike
        if skill.data and skill.data.effects and skill.data.effects.critDamage then
            critDamage = critDamage + (skill.data.effects.critDamage * skill.level)
        end
    end

    return critDamage
end

-- Apply skill effects on level up
function Stats:applySkillEffects()
    -- Health boost
    if self.skills.health_boost then
        local skill = self.skills.health_boost
        if skill.data and skill.data.effects and skill.data.effects.maxHealth then
            -- This is applied when skill is unlocked/upgraded
        end
    end

    -- Magic affinity
    if self.skills.magic_affinity then
        local skill = self.skills.magic_affinity
        if skill.data and skill.data.effects and skill.data.effects.maxMana then
            -- This is applied when skill is unlocked/upgraded
        end
    end
end

return Stats

