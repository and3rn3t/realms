# Modding Guide

This directory is for user-created mods. Mods can add new content to the game including:
- Items
- Quests
- Enemies
- Realms

## Creating a Mod

1. Create a new folder in the `mods` directory
2. Create a `mod.lua` file with your mod data
3. Use the example mod as a template

## Mod Structure

```lua
return {
    name = "Your Mod Name",
    version = "1.0.0",
    author = "Your Name",
    description = "Description of your mod",

    items = {
        -- Add items here
    },

    quests = {
        -- Add quests here
    },

    enemies = {
        -- Add enemies here
    },

    realms = {
        -- Add realms here
    },
}
```

## Loading Mods

Mods are automatically loaded when the game starts. The mod loader will scan the `mods` directory and load all valid mods.

