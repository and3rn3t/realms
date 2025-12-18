--[[
    Asset Manager
    Loads and caches images, sounds, fonts efficiently
]]

local AssetManager = {}
AssetManager.images = {}
AssetManager.sounds = {}
AssetManager.music = {}
AssetManager.fonts = {}
AssetManager.loaded = false

-- Initialize asset manager
function AssetManager.init()
    AssetManager.images = {}
    AssetManager.sounds = {}
    AssetManager.music = {}
    AssetManager.fonts = {}
    AssetManager.loaded = false
end

-- Load an image
function AssetManager.loadImage(path, key)
    key = key or path

    if AssetManager.images[key] then
        return AssetManager.images[key]
    end

    local success, image = pcall(love.graphics.newImage, path)
    if success and image then
        AssetManager.images[key] = image
        return image
    else
        print("Warning: Failed to load image: " .. tostring(path))
        return nil
    end
end

-- Get a loaded image
function AssetManager.getImage(key)
    return AssetManager.images[key]
end

-- Load a sound
function AssetManager.loadSound(path, key)
    key = key or path

    if AssetManager.sounds[key] then
        return AssetManager.sounds[key]
    end

    local success, sound = pcall(love.audio.newSource, path, "static")
    if success and sound then
        AssetManager.sounds[key] = sound
        return sound
    else
        print("Warning: Failed to load sound: " .. tostring(path))
        return nil
    end
end

-- Get a loaded sound
function AssetManager.getSound(key)
    return AssetManager.sounds[key]
end

-- Play a sound
function AssetManager.playSound(key, volume)
    local sound = AssetManager.getSound(key)
    if sound then
        local instance = sound:clone()
        if volume then
            instance:setVolume(volume)
        end
        instance:play()
        return instance
    end
    return nil
end

-- Load music
function AssetManager.loadMusic(path, key)
    key = key or path

    if AssetManager.music[key] then
        return AssetManager.music[key]
    end

    local success, music = pcall(love.audio.newSource, path, "stream")
    if success and music then
        music:setLooping(true)
        AssetManager.music[key] = music
        return music
    else
        print("Warning: Failed to load music: " .. tostring(path))
        return nil
    end
end

-- Get loaded music
function AssetManager.getMusic(key)
    return AssetManager.music[key]
end

-- Play music
function AssetManager.playMusic(key, volume)
    local music = AssetManager.getMusic(key)
    if music then
        love.audio.stop()
        if volume then
            music:setVolume(volume)
        end
        music:play()
        return music
    end
    return nil
end

-- Stop music
function AssetManager.stopMusic()
    love.audio.stop()
end

-- Load a font
function AssetManager.loadFont(path, size, key)
    key = key or (path .. "_" .. tostring(size))

    if AssetManager.fonts[key] then
        return AssetManager.fonts[key]
    end

    local success, font = pcall(love.graphics.newFont, path, size)
    if success and font then
        AssetManager.fonts[key] = font
        return font
    else
        -- Fallback to default font
        print("Warning: Failed to load font: " .. tostring(path) .. ", using default")
        return love.graphics.getFont()
    end
end

-- Get a loaded font
function AssetManager.getFont(key)
    return AssetManager.fonts[key] or love.graphics.getFont()
end

-- Load default font at size
function AssetManager.getDefaultFont(size)
    local key = "default_" .. tostring(size)
    if not AssetManager.fonts[key] then
        AssetManager.fonts[key] = love.graphics.newFont(size)
    end
    return AssetManager.fonts[key]
end

-- Preload assets from a table
function AssetManager.preload(assets)
    assets = assets or {}

    -- Load images
    if assets.images then
        for key, path in pairs(assets.images) do
            AssetManager.loadImage(path, key)
        end
    end

    -- Load sounds
    if assets.sounds then
        for key, path in pairs(assets.sounds) do
            AssetManager.loadSound(path, key)
        end
    end

    -- Load music
    if assets.music then
        for key, path in pairs(assets.music) do
            AssetManager.loadMusic(path, key)
        end
    end

    -- Load fonts
    if assets.fonts then
        for key, data in pairs(assets.fonts) do
            AssetManager.loadFont(data.path, data.size, key)
        end
    end
end

-- Clear all assets (use with caution)
function AssetManager.clear()
    AssetManager.images = {}
    AssetManager.sounds = {}
    AssetManager.music = {}
    AssetManager.fonts = {}
end

return AssetManager

