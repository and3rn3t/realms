--[[
    Environment System
    Handles day/night cycle, weather, and ambient audio
]]

local Environment = {}
Environment.time = 0 -- Game time in seconds
Environment.dayLength = 300 -- 5 minutes per day
Environment.currentTime = 0 -- 0-1, where 0 is midnight, 0.5 is noon
Environment.weather = "clear" -- "clear", "rain", "fog", "snow"
Environment.weatherIntensity = 0 -- 0-1
Environment.ambientMusic = nil
Environment.ambientSounds = {}

-- Initialize environment
function Environment.init()
    Environment.time = 0
    Environment.currentTime = 0.25 -- Start at dawn
    Environment.weather = "clear"
    Environment.weatherIntensity = 0
end

-- Update environment
function Environment.update(dt)
    -- Update time
    Environment.time = Environment.time + dt
    Environment.currentTime = (Environment.time % Environment.dayLength) / Environment.dayLength

    -- Update weather (simple random changes)
    if math.random() < 0.001 then -- 0.1% chance per frame
        local weathers = {"clear", "rain", "fog"}
        Environment.weather = weathers[math.random(#weathers)]
        Environment.weatherIntensity = math.random() * 0.5 + 0.5
    end
end

-- Get time of day string
function Environment.getTimeOfDay()
    if Environment.currentTime < 0.25 then
        return "night"
    elseif Environment.currentTime < 0.3 then
        return "dawn"
    elseif Environment.currentTime < 0.7 then
        return "day"
    elseif Environment.currentTime < 0.75 then
        return "dusk"
    else
        return "night"
    end
end

-- Get light level (0-1)
function Environment.getLightLevel()
    local time = Environment.currentTime

    if time < 0.25 or time > 0.75 then
        -- Night
        return 0.3
    elseif time < 0.3 or time > 0.7 then
        -- Dawn/Dusk
        local t = (time < 0.3) and (time - 0.25) / 0.05 or (0.75 - time) / 0.05
        return 0.3 + t * 0.7
    else
        -- Day
        return 1.0
    end
end

-- Set weather
function Environment.setWeather(weather, intensity)
    Environment.weather = weather or "clear"
    Environment.weatherIntensity = intensity or 0.5
end

-- Get weather color tint
function Environment.getWeatherTint()
    if Environment.weather == "rain" then
        return 0.7, 0.7, 0.8, 1 - Environment.weatherIntensity * 0.3
    elseif Environment.weather == "fog" then
        return 0.8, 0.8, 0.8, Environment.weatherIntensity * 0.5
    elseif Environment.weather == "snow" then
        return 0.9, 0.9, 1.0, Environment.weatherIntensity * 0.3
    else
        return 1, 1, 1, 0
    end
end

-- Set ambient music for realm
function Environment.setAmbientMusic(realm, musicKey)
    local src = require("src.init")
    local music = src.core.AssetManager.getMusic(musicKey)

    if music then
        if Environment.ambientMusic then
            love.audio.stop(Environment.ambientMusic)
        end
        Environment.ambientMusic = music
        music:play()
    end
end

-- Stop ambient music
function Environment.stopAmbientMusic()
    if Environment.ambientMusic then
        love.audio.stop(Environment.ambientMusic)
        Environment.ambientMusic = nil
    end
end

-- Add ambient sound
function Environment.addAmbientSound(soundKey, volume, loop)
    local src = require("src.init")
    local sound = src.core.AssetManager.getSound(soundKey)

    if sound then
        sound:setVolume(volume or 0.5)
        sound:setLooping(loop ~= false)
        sound:play()
        table.insert(Environment.ambientSounds, sound)
        return sound
    end
    return nil
end

-- Clear ambient sounds
function Environment.clearAmbientSounds()
    for _, sound in ipairs(Environment.ambientSounds) do
        sound:stop()
    end
    Environment.ambientSounds = {}
end

-- Draw weather effects
function Environment.drawWeather()
    if Environment.weather == "rain" and Environment.weatherIntensity > 0 then
        love.graphics.setColor(0.5, 0.5, 0.8, Environment.weatherIntensity * 0.3)
        -- Simple rain effect (would be better with particles)
        for i = 1, 50 do
            local x = (Environment.time * 100 + i * 20) % love.graphics.getWidth()
            local y = (Environment.time * 200 + i * 30) % love.graphics.getHeight()
            love.graphics.line(x, y, x + 2, y + 10)
        end
    elseif Environment.weather == "fog" and Environment.weatherIntensity > 0 then
        love.graphics.setColor(0.8, 0.8, 0.8, Environment.weatherIntensity * 0.5)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end

    love.graphics.setColor(1, 1, 1)
end

-- Apply time of day lighting
function Environment.applyLighting()
    local lightLevel = Environment.getLightLevel()
    local r, g, b, a = Environment.getWeatherTint()

    love.graphics.setColor(lightLevel * r, lightLevel * g, lightLevel * b, a)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)
end

return Environment

