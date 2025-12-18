-- Location Module
-- Represents a geographic location within a realm

local Location = {}
Location.__index = Location

---
-- Create a new Location
-- @param data table Location data
-- @return Location New location object
function Location.new(data)
  local self = setmetatable({}, Location)

  -- Geographic properties
  self.name = data.name or "Unknown"
  self.lat = data.lat
  self.lon = data.lon
  self.elevation = data.elevation  -- meters

  -- Real-world classification
  self.place_type = data.place_type  -- city, town, village, natural, etc.
  self.osm_data = data.osm_data      -- OpenStreetMap data

  -- Fantasy transformation
  self.fantasy_name = nil            -- Generated fantasy name
  self.terrain_type = nil            -- MOUNTAINS, HILLS, PLAINS, etc.
  self.theme = nil                   -- Specific fantasy theme
  self.description = nil             -- Fantasy description

  -- Features
  self.features = data.features or {}  -- Special features (rivers, forests, etc.)
  self.inhabitants = {}                -- Races/creatures inhabiting this location
  self.points_of_interest = {}         -- Notable locations within

  return self
end

---
-- Apply fantasy theme based on terrain type
-- @param terrain_type string Terrain classification
-- @param settings table Settings from config
function Location:apply_fantasy_theme(terrain_type, settings)
  self.terrain_type = terrain_type

  -- TODO: Implement fantasy theme application
  -- 1. Select random fantasy name from terrain type options
  -- 2. Choose appropriate inhabitants based on terrain
  -- 3. Generate description
  -- 4. Add themed features

  return self
end

---
-- Set fantasy name for the location
-- @param name string Fantasy name
function Location:set_fantasy_name(name)
  self.fantasy_name = name
end

---
-- Add a point of interest
-- @param poi table Point of interest data
function Location:add_poi(poi)
  table.insert(self.points_of_interest, poi)
end

---
-- Add inhabitants (races/creatures)
-- @param inhabitants table Array of inhabitant types
function Location:set_inhabitants(inhabitants)
  self.inhabitants = inhabitants
end

---
-- Generate a description of the location
-- @return string Location description
function Location:describe()
  if self.description then
    return self.description
  end

  -- TODO: Generate description based on terrain, elevation, features
  return string.format("%s at elevation %dm", self.name, self.elevation or 0)
end

---
-- Convert location to table
-- @return table Location data
function Location:to_table()
  return {
    name = self.name,
    fantasy_name = self.fantasy_name,
    coordinates = {lat = self.lat, lon = self.lon},
    elevation = self.elevation,
    terrain_type = self.terrain_type,
    theme = self.theme,
    description = self.description,
    features = self.features,
    inhabitants = self.inhabitants,
    points_of_interest = self.points_of_interest
  }
end

return Location
