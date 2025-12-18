--[[
    Character Stats UI
    Displays character stats and allows stat point allocation
]]

local StatsUI = {}
StatsUI.visible = false
StatsUI.selectedStat = 1

function StatsUI.new()
    local self = {}
    self.visible = false
    self.selectedStat = 1
    return self
end

function StatsUI:toggle()
    self.visible = not self.visible
end

function StatsUI:draw(stats)
    if not self.visible or not stats then return end

    local width = 600
    local height = 550
    local x = (love.graphics.getWidth() - width) / 2
    local y = (love.graphics.getHeight() - height) / 2

    -- Background
    love.graphics.setColor(0.1, 0.1, 0.1, 0.95)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("line", x, y, width, height)

    -- Title
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Character Stats", x + 20, y + 20)

    local textY = y + 60

    -- Level and Experience
    love.graphics.setColor(1, 1, 0.5)
    love.graphics.print("Level: " .. stats.level, x + 20, textY)
    textY = textY + 25

    local expPercent = stats.experience / stats.experienceToNext
    local expBarWidth = 300
    local expBarHeight = 20
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", x + 20, textY, expBarWidth, expBarHeight)
    love.graphics.setColor(0.2, 0.8, 1)
    love.graphics.rectangle("fill", x + 20, textY, expBarWidth * expPercent, expBarHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x + 20, textY, expBarWidth, expBarHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("%d / %d XP", stats.experience, stats.experienceToNext), x + 330, textY + 3)
    textY = textY + 35

    -- Stat Points Available
    if stats.statPoints > 0 then
        love.graphics.setColor(0.3, 1, 0.3)
        love.graphics.print("Stat Points Available: " .. stats.statPoints, x + 20, textY)
        textY = textY + 30
    end

    -- Skill Points Available
    if stats.skillPoints > 0 then
        love.graphics.setColor(0.3, 1, 0.3)
        love.graphics.print("Skill Points Available: " .. stats.skillPoints, x + 20, textY)
        textY = textY + 30
    end

    textY = textY + 10

    -- Attributes section
    love.graphics.setColor(1, 1, 0.5)
    love.graphics.print("Attributes", x + 20, textY)
    textY = textY + 30

    -- List of stats
    local statList = {
        {name = "Strength", value = stats.strength, key = "strength", description = "Increases physical damage"},
        {name = "Dexterity", value = stats.dexterity, key = "dexterity", description = "Increases critical chance"},
        {
            name = "Intelligence",
            value = stats.intelligence,
            key = "intelligence",
            description = "Increases magic damage"
        },
        {name = "Vitality", value = stats.vitality, key = "vitality", description = "Increases max health"},
        {name = "Wisdom", value = stats.wisdom, key = "wisdom", description = "Increases max mana"},
        {name = "Luck", value = stats.luck, key = "luck", description = "Increases critical chance"},
    }

    -- Draw stats
    for i, stat in ipairs(statList) do
        local statY = textY + (i - 1) * 35

        -- Highlight selected stat if points available
        if stats.statPoints > 0 and i == self.selectedStat then
            love.graphics.setColor(0.2, 0.4, 0.8, 0.5)
            love.graphics.rectangle("fill", x + 15, statY - 2, width - 30, 32)
        end

        -- Stat name and value
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(stat.name .. ":", x + 25, statY + 5)
        love.graphics.setColor(0.8, 0.8, 1)
        love.graphics.print(tostring(stat.value), x + 150, statY + 5)

        -- Description
        love.graphics.setColor(0.6, 0.6, 0.6)
        love.graphics.print(stat.description, x + 200, statY + 5)

        -- Increase button hint if points available
        if stats.statPoints > 0 and i == self.selectedStat then
            love.graphics.setColor(0.3, 1, 0.3)
            love.graphics.print("Press ENTER to increase", x + 400, statY + 5)
        end
    end

    textY = textY + #statList * 35 + 20

    -- Combat Stats section
    love.graphics.setColor(1, 1, 0.5)
    love.graphics.print("Combat Stats", x + 20, textY)
    textY = textY + 30

    local combatStats = {
        {name = "Health", current = stats.health, max = stats.maxHealth},
        {name = "Mana", current = stats.mana, max = stats.maxMana},
        {name = "Damage", value = stats:getDamage()},
        {name = "Defense", value = stats:getDefense()},
        {name = "Magic Damage", value = stats:getMagicDamage()},
        {name = "Critical Chance", value = string.format("%.1f%%", stats:getCriticalChance())},
    }

    for i, stat in ipairs(combatStats) do
        local statY = textY + (i - 1) * 25
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(stat.name .. ":", x + 25, statY)
        love.graphics.setColor(0.8, 0.8, 1)
        if stat.current and stat.max then
            love.graphics.print(string.format("%d / %d", stat.current, stat.max), x + 150, statY)
        else
            love.graphics.print(tostring(stat.value), x + 150, statY)
        end
    end

    -- Close hint
    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.print("Press C or ESC to close", x + width - 200, y + height - 25)
end

function StatsUI:keypressed(key, stats)
    if not self.visible or not stats then return end

    if key == "c" or key == "escape" then
        self.visible = false
        return
    end

    -- Arrow keys for stat selection
    if stats.statPoints > 0 then
        if key == "up" then
            self.selectedStat = math.max(1, self.selectedStat - 1)
        elseif key == "down" then
            self.selectedStat = math.min(6, self.selectedStat + 1)
        elseif key == "return" or key == "kpenter" then
            -- Allocate stat point
            local statList = {
                "strength", "dexterity", "intelligence", "vitality", "wisdom", "luck"
            }
            if self.selectedStat >= 1 and self.selectedStat <= #statList then
                local statKey = statList[self.selectedStat]
                if stats:spendStatPoint(statKey) then
                    print("Increased " .. statKey)
                end
            end
        end
    end
end

return StatsUI

