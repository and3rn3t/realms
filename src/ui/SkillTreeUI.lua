--[[
    Skill Tree UI
    Displays skill tree and allows unlocking/upgrading skills
]]

local SkillTreeUI = {}
SkillTreeUI.visible = false
SkillTreeUI.selectedSkill = 1
SkillTreeUI.mode = "unlock" -- "unlock" or "upgrade"

function SkillTreeUI.new()
    local self = {}
    self.visible = false
    self.selectedSkill = 1
    self.mode = "unlock"
    return self
end

function SkillTreeUI:toggle()
    self.visible = not self.visible
end

function SkillTreeUI:draw(stats)
    if not self.visible or not stats then return end

    local width = 700
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
    love.graphics.print("Skill Tree", x + 20, y + 20)

    -- Skill Points Available
    if stats.skillPoints > 0 then
        love.graphics.setColor(0.3, 1, 0.3)
        love.graphics.print("Skill Points Available: " .. stats.skillPoints, x + 20, y + 50)
    else
        love.graphics.setColor(0.6, 0.6, 0.6)
        love.graphics.print("No skill points available", x + 20, y + 50)
    end

    -- Mode tabs
    local tabY = y + 80
    local tabWidth = 120
    local tabHeight = 30

    -- Unlock tab
    if self.mode == "unlock" then
        love.graphics.setColor(0.3, 0.5, 0.8)
    else
        love.graphics.setColor(0.2, 0.2, 0.2)
    end
    love.graphics.rectangle("fill", x + 20, tabY, tabWidth, tabHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x + 20, tabY, tabWidth, tabHeight)
    love.graphics.print("Unlock", x + 30, tabY + 8)

    -- Upgrade tab
    if self.mode == "upgrade" then
        love.graphics.setColor(0.3, 0.5, 0.8)
    else
        love.graphics.setColor(0.2, 0.2, 0.2)
    end
    love.graphics.rectangle("fill", x + 150, tabY, tabWidth, tabHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x + 150, tabY, tabWidth, tabHeight)
    love.graphics.print("Upgrade", x + 160, tabY + 8)

    -- Skill list area
    local listX = x + 20
    local listY = tabY + tabHeight + 10
    local listWidth = 300
    local listHeight = height - (listY - y) - 20

    love.graphics.setColor(0.15, 0.15, 0.15)
    love.graphics.rectangle("fill", listX, listY, listWidth, listHeight)
    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.rectangle("line", listX, listY, listWidth, listHeight)

    -- Get skills based on mode
    local Skills = require("src.data.Skills")
    local skillList = {}

    if self.mode == "unlock" then
        -- Show skills that can be unlocked
        for skillId, skillData in pairs(Skills.data) do
            if not stats:hasSkill(skillId) then
                -- Check prerequisites
                local canUnlock = true
                if skillData.prerequisites then
                    for _, prereq in ipairs(skillData.prerequisites) do
                        if not stats:hasSkill(prereq) then
                            canUnlock = false
                            break
                        end
                    end
                end
                table.insert(skillList, {
                    id = skillId,
                    data = skillData,
                    canUnlock = canUnlock,
                    unlocked = false,
                })
            end
        end
    else
        -- Show unlocked skills that can be upgraded
        for skillId, skillData in pairs(Skills.data) do
            if stats:hasSkill(skillId) then
                local skill = stats.skills[skillId]
                local canUpgrade = skill.level < (skillData.maxLevel or 5)
                table.insert(skillList, {
                    id = skillId,
                    data = skillData,
                    canUpgrade = canUpgrade,
                    unlocked = true,
                    level = skill.level,
                })
            end
        end
    end

    -- Draw skill list
    local skillY = listY + 10
    for i, skill in ipairs(skillList) do
        if i == self.selectedSkill then
            love.graphics.setColor(0.3, 0.5, 0.8)
            love.graphics.rectangle("fill", listX + 5, skillY - 2, listWidth - 10, 40)
        end

        -- Skill name
        if skill.canUnlock == false or (self.mode == "upgrade" and not skill.canUpgrade) then
            love.graphics.setColor(0.5, 0.5, 0.5)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.print(skill.data.name or skill.id, listX + 10, skillY + 5)

        -- Skill level/status
        if skill.unlocked then
            love.graphics.setColor(0.3, 1, 0.3)
            local levelText = string.format(
                "Lv %d/%d", skill.level, skill.data.maxLevel or 5
            )
            love.graphics.print(levelText, listX + 10, skillY + 20)
        else
            love.graphics.setColor(0.6, 0.6, 0.6)
            love.graphics.print("Locked", listX + 10, skillY + 20)
        end

        skillY = skillY + 45
    end

    -- Skill details area
    local detailsX = listX + listWidth + 10
    local detailsY = listY
    local detailsWidth = width - (detailsX - x) - 20
    local detailsHeight = listHeight

    love.graphics.setColor(0.15, 0.15, 0.15)
    love.graphics.rectangle("fill", detailsX, detailsY, detailsWidth, detailsHeight)
    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.rectangle("line", detailsX, detailsY, detailsWidth, detailsHeight)

    -- Draw selected skill details
    if #skillList > 0 and self.selectedSkill <= #skillList then
        local skill = skillList[self.selectedSkill]
        local textY = detailsY + 20

        -- Skill name
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.print(skill.data.name or skill.id, detailsX + 10, textY)
        textY = textY + 30

        -- Skill description
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.print(skill.data.description or "No description", detailsX + 10, textY)
        textY = textY + 40

        -- Skill level info
        if skill.unlocked then
            love.graphics.setColor(1, 1, 1)
            local levelText = string.format(
                "Level: %d / %d", skill.level, skill.data.maxLevel or 5
            )
            love.graphics.print(levelText, detailsX + 10, textY)
            textY = textY + 25
        end

        -- Effects
        if skill.data.effects then
            love.graphics.setColor(1, 1, 0.5)
            love.graphics.print("Effects:", detailsX + 10, textY)
            textY = textY + 25

            love.graphics.setColor(1, 1, 1)
            for effectName, effectValue in pairs(skill.data.effects) do
                local effectText = effectName .. ": +" .. tostring(effectValue) .. " per level"
                love.graphics.print("• " .. effectText, detailsX + 20, textY)
                textY = textY + 25
            end
        end

        -- Prerequisites
        if skill.data.prerequisites and #skill.data.prerequisites > 0 then
            textY = textY + 10
            love.graphics.setColor(1, 1, 0.5)
            love.graphics.print("Prerequisites:", detailsX + 10, textY)
            textY = textY + 25

            love.graphics.setColor(1, 1, 1)
            for _, prereqId in ipairs(skill.data.prerequisites) do
                local prereqData = Skills.getSkill(prereqId)
                local prereqName = prereqData and prereqData.name or prereqId
                local hasPrereq = stats:hasSkill(prereqId)

                if hasPrereq then
                    love.graphics.setColor(0.3, 1, 0.3)
                else
                    love.graphics.setColor(1, 0.3, 0.3)
                end
                love.graphics.print("• " .. prereqName, detailsX + 20, textY)
                textY = textY + 25
            end
        end

        -- Action button hint
        textY = detailsY + detailsHeight - 40
        if self.mode == "unlock" then
            if skill.canUnlock and stats.skillPoints > 0 then
                love.graphics.setColor(0.3, 1, 0.3)
                love.graphics.print("Press ENTER to unlock", detailsX + 10, textY)
            elseif not skill.canUnlock then
                love.graphics.setColor(1, 0.3, 0.3)
                love.graphics.print("Prerequisites not met", detailsX + 10, textY)
            else
                love.graphics.setColor(1, 0.3, 0.3)
                love.graphics.print("No skill points available", detailsX + 10, textY)
            end
        else
            if skill.canUpgrade and stats.skillPoints > 0 then
                love.graphics.setColor(0.3, 1, 0.3)
                love.graphics.print("Press ENTER to upgrade", detailsX + 10, textY)
            elseif not skill.canUpgrade then
                love.graphics.setColor(0.6, 0.6, 0.6)
                love.graphics.print("Skill at max level", detailsX + 10, textY)
            else
                love.graphics.setColor(1, 0.3, 0.3)
                love.graphics.print("No skill points available", detailsX + 10, textY)
            end
        end
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.print("No skills available", detailsX + 10, detailsY + 20)
    end

    -- Close hint
    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.print("Press K or ESC to close | TAB to switch mode", x + width - 350, y + height - 25)
end

function SkillTreeUI:keypressed(key, stats)
    if not self.visible or not stats then return end

    if key == "k" or key == "escape" then
        self.visible = false
        return
    end

    if key == "tab" then
        -- Switch mode
        self.mode = (self.mode == "unlock") and "upgrade" or "unlock"
        self.selectedSkill = 1
        return
    end

    -- Get skills based on mode
    local Skills = require("src.data.Skills")
    local skillList = {}

    if self.mode == "unlock" then
        for skillId, skillData in pairs(Skills.data) do
            if not stats:hasSkill(skillId) then
                local canUnlock = true
                if skillData.prerequisites then
                    for _, prereq in ipairs(skillData.prerequisites) do
                        if not stats:hasSkill(prereq) then
                            canUnlock = false
                            break
                        end
                    end
                end
                table.insert(skillList, {
                    id = skillId,
                    data = skillData,
                    canUnlock = canUnlock,
                })
            end
        end
    else
        for skillId, skillData in pairs(Skills.data) do
            if stats:hasSkill(skillId) then
                local skill = stats.skills[skillId]
                local canUpgrade = skill.level < (skillData.maxLevel or 5)
                table.insert(skillList, {
                    id = skillId,
                    data = skillData,
                    canUpgrade = canUpgrade,
                })
            end
        end
    end

    -- Arrow keys for skill selection
    if key == "up" then
        self.selectedSkill = math.max(1, self.selectedSkill - 1)
    elseif key == "down" then
        self.selectedSkill = math.min(#skillList, self.selectedSkill + 1)
    elseif key == "return" or key == "kpenter" then
        -- Unlock or upgrade skill
        if #skillList > 0 and self.selectedSkill <= #skillList then
            local skill = skillList[self.selectedSkill]
            if self.mode == "unlock" then
                if skill.canUnlock and stats.skillPoints > 0 then
                    if stats:unlockSkill(skill.id, skill.data) then
                        print("Unlocked skill: " .. (skill.data.name or skill.id))
                    end
                end
            else
                if skill.canUpgrade and stats.skillPoints > 0 then
                    if stats:upgradeSkill(skill.id) then
                        print("Upgraded skill: " .. (skill.data.name or skill.id))
                    end
                end
            end
        end
    end
end

return SkillTreeUI

