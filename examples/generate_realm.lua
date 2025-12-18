#!/usr/bin/env lua
-- Realm Forge Example Script
-- Demonstrates how to generate a fantasy realm from a real-world location

-- Add src to package path
package.path = package.path .. ";./?.lua;./src/?.lua"

-- Load Realm Forge
local RealmForge = require("src.init")

-- Load utilities
local json = require("src.utils.json")
local helpers = require("src.utils.helpers")

---
-- Main function
local function main()
  print("🏰 Welcome to Realm Forge! ⚔️")
  print("=" .. string.rep("=", 50))
  print()

  -- Example 1: Generate realm from a specific address
  print("📍 Generating realm from: Seattle, Washington")
  print()

  local realm, err = RealmForge.generate({
    address = "Seattle, Washington",
    radius = 50,           -- 50km radius
    npc_count = 20,        -- Generate 20 NPCs
    include_quests = true, -- Include quests
    include_factions = true -- Include factions
  })

  if not realm then
    print("❌ Error generating realm: " .. tostring(err))
    return
  end

  -- Print realm summary
  print("✅ Realm generated successfully!")
  print()
  print(realm:summary())
  print()

  -- Display statistics
  local stats = realm:get_stats()
  print("📊 Realm Statistics:")
  print("  - Locations: " .. stats.location_count)
  print("  - NPCs: " .. stats.npc_count)
  print("  - Factions: " .. stats.faction_count)
  print("  - Quests: " .. stats.quest_count)
  print()

  -- Save realm to JSON file
  local output_file = "output/seattle_realm.json"
  print("💾 Saving realm to: " .. output_file)

  local realm_data = realm:to_table()
  local save_success, save_err = json.save_to_file(output_file, realm_data)

  if save_success then
    print("✅ Realm saved successfully!")
  else
    print("❌ Error saving realm: " .. tostring(save_err))
  end

  print()
  print("=" .. string.rep("=", 50))
  print("🎉 Realm generation complete!")
  print()
  print("Next steps:")
  print("  1. Explore the generated realm data")
  print("  2. Customize terrain classifications")
  print("  3. Add more NPCs and quests")
  print("  4. Generate lore and backstories")
  print("  5. Create your own adventure!")
end

-- Example 2: Interactive mode (commented out by default)
--[[
local function interactive_mode()
  print("🏰 Realm Forge - Interactive Mode ⚔️")
  print()

  -- Get address from user
  io.write("Enter a location (address, city, or landmark): ")
  local address = io.read()

  if not address or address == "" then
    print("Error: Address cannot be empty")
    return
  end

  -- Get radius
  io.write("Enter exploration radius in kilometers (default: 50): ")
  local radius_input = io.read()
  local radius = tonumber(radius_input) or 50

  -- Generate realm
  print()
  print("🔮 Generating realm...")
  print()

  local realm, err = RealmForge.generate({
    address = address,
    radius = radius
  })

  if not realm then
    print("❌ Error: " .. tostring(err))
    return
  end

  print(realm:summary())

  -- Save option
  io.write("\nSave realm to file? (y/n): ")
  local save_choice = io.read()

  if save_choice:lower() == "y" then
    -- Generate filename from address
    local filename = address:gsub("[^%w]+", "_"):lower()
    local filepath = string.format("output/%s_realm.json", filename)

    local success = json.save_to_file(filepath, realm:to_table())
    if success then
      print("✅ Saved to: " .. filepath)
    end
  end
end
--]]

-- Run the example
main()

-- To run interactive mode instead, uncomment this line:
-- interactive_mode()
