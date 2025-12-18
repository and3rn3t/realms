-- Terrain Module
-- Terrain classification and fantasy theme mapping

local terrain = {}

local settings = require("config.settings")

---
-- Classify terrain based on elevation
-- @param elevation number Elevation in meters
-- @return string Terrain type classification
function terrain.classify_by_elevation(elevation)
  if not elevation then
    return "UNKNOWN"
  end

  -- Use settings to determine terrain type
  local types = settings.TERRAIN_TYPES

  if elevation >= types.MOUNTAINS.min_elevation then
    return "MOUNTAINS"
  elseif elevation >= types.HILLS.min_elevation then
    return "HILLS"
  elseif elevation >= types.PLAINS.min_elevation then
    return "PLAINS"
  elseif elevation >= types.WETLANDS.min_elevation then
    return "WETLANDS"
  else
    return "WETLANDS"  -- Below sea level
  end
end

---
-- Get fantasy theme for a terrain type
-- @param terrain_type string Terrain classification
-- @return table Fantasy theme data
function terrain.get_fantasy_theme(terrain_type)
  local types = settings.TERRAIN_TYPES

  if not types[terrain_type] then
    return {
      fantasy_names = {"Unknown Land"},
      description = "Uncharted territory"
    }
  end

  return types[terrain_type]
end

---
-- Select random fantasy name for terrain
-- @param terrain_type string Terrain classification
-- @return string Fantasy name
function terrain.get_random_fantasy_name(terrain_type)
  local theme = terrain.get_fantasy_theme(terrain_type)
  local names = theme.fantasy_names

  if not names or #names == 0 then
    return "Unknown Land"
  end

  return names[math.random(#names)]
end

---
-- Classify terrain with multiple factors
-- @param elevation number Elevation in meters
-- @param has_water boolean Near water body
-- @param is_urban boolean Urban area
-- @param vegetation string Vegetation type
-- @return string Terrain classification
function terrain.classify_advanced(elevation, has_water, is_urban, vegetation)
  -- Priority classification
  if is_urban then
    return "URBAN"
  end

  if has_water and elevation and elevation < 50 then
    return "COASTAL"
  end

  if vegetation == "forest" then
    return "FOREST"
  end

  -- Fall back to elevation-based classification
  return terrain.classify_by_elevation(elevation)
end

---
-- Get appropriate inhabitants for terrain type
-- @param terrain_type string Terrain classification
-- @return table Array of suitable races/creatures
function terrain.get_inhabitants(terrain_type)
  -- TODO: Expand with more detailed inhabitant mappings
  local inhabitants_map = {
    MOUNTAINS = {"Dwarves", "Giants", "Dragons", "Goliaths"},
    HILLS = {"Halflings", "Gnomes", "Humans"},
    PLAINS = {"Humans", "Centaurs", "Nomadic Tribes"},
    WETLANDS = {"Lizardfolk", "Bullywugs", "Swamp Hags"},
    FOREST = {"Elves", "Druids", "Fey Creatures", "Rangers"},
    COASTAL = {"Sailors", "Merfolk", "Pirates", "Tritons"},
    WATER = {"Merfolk", "Tritons", "Sea Elves", "Nereids"},
    URBAN = {"Humans", "Half-Elves", "All Races"}
  }

  return inhabitants_map[terrain_type] or {"Unknown"}
end

---
-- Generate terrain description
-- @param terrain_type string Terrain classification
-- @param elevation number Elevation in meters
-- @return string Terrain description
function terrain.describe(terrain_type, elevation)
  local theme = terrain.get_fantasy_theme(terrain_type)
  local fantasy_name = terrain.get_random_fantasy_name(terrain_type)

  return string.format(
    "%s - %s (Elevation: %dm)",
    fantasy_name,
    theme.description,
    elevation or 0
  )
end

---
-- Analyze terrain composition for a region
-- @param elevation_data table Array of elevation values
-- @return table Terrain composition statistics
function terrain.analyze_region(elevation_data)
  if not elevation_data or #elevation_data == 0 then
    return nil, "No elevation data provided"
  end

  local composition = {
    MOUNTAINS = 0,
    HILLS = 0,
    PLAINS = 0,
    WETLANDS = 0
  }

  local total = #elevation_data
  local sum = 0
  local min_elev = elevation_data[1]
  local max_elev = elevation_data[1]

  -- Analyze each point
  for _, elev in ipairs(elevation_data) do
    local type = terrain.classify_by_elevation(elev)
    composition[type] = (composition[type] or 0) + 1

    sum = sum + elev
    min_elev = math.min(min_elev, elev)
    max_elev = math.max(max_elev, elev)
  end

  -- Calculate percentages
  local percentages = {}
  for type, count in pairs(composition) do
    percentages[type] = (count / total) * 100
  end

  return {
    composition = composition,
    percentages = percentages,
    average_elevation = sum / total,
    min_elevation = min_elev,
    max_elevation = max_elev,
    dominant_type = terrain.get_dominant_type(composition)
  }
end

---
-- Get dominant terrain type from composition
-- @param composition table Terrain type counts
-- @return string Dominant terrain type
function terrain.get_dominant_type(composition)
  local max_count = 0
  local dominant = "UNKNOWN"

  for type, count in pairs(composition) do
    if count > max_count then
      max_count = count
      dominant = type
    end
  end

  return dominant
end

return terrain
