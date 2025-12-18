-- Open Topo Data / Open-Elevation API Client
-- Elevation data for terrain classification
-- API Docs: https://www.opentopodata.org/

local elevation = {}

local http = require("src.utils.http")
local settings = require("config.settings")

local BASE_URL = settings.API.ELEVATION

---
-- Get elevation for a single point
-- @param lat number Latitude
-- @param lon number Longitude
-- @return number Elevation in meters, or nil and error
function elevation.get_point(lat, lon)
  if not lat or not lon then
    return nil, "Latitude and longitude are required"
  end

  -- TODO: Implement single point elevation query
  -- 1. Build request URL: /v1/srtm90m?locations=lat,lon
  -- 2. Make HTTP GET request
  -- 3. Parse JSON response
  -- 4. Extract elevation value
  -- 5. Return elevation in meters

  -- Example: https://api.opentopodata.org/v1/srtm90m?locations=47.6062,-122.3321

  return nil, "Not yet implemented"
end

---
-- Get elevation for multiple points
-- @param locations table Array of {lat, lon} coordinate pairs
-- @return table Array of elevation values or nil and error
function elevation.get_batch(locations)
  if not locations or #locations == 0 then
    return nil, "Locations array cannot be empty"
  end

  -- TODO: Implement batch elevation query
  -- 1. Format locations as lat1,lon1|lat2,lon2|...
  -- 2. Build request URL
  -- 3. Make HTTP GET request
  -- 4. Parse JSON response
  -- 5. Return array of elevation values

  return nil, "Not yet implemented"
end

---
-- Get elevation profile along a path
-- @param start_lat number Starting latitude
-- @param start_lon number Starting longitude
-- @param end_lat number Ending latitude
-- @param end_lon number Ending longitude
-- @param samples number Number of sample points along the path (default: 10)
-- @return table Array of {lat, lon, elevation} or nil and error
function elevation.get_profile(start_lat, start_lon, end_lat, end_lon, samples)
  samples = samples or 10

  -- TODO: Implement elevation profile
  -- 1. Generate interpolated points along the path
  -- 2. Query elevation for each point
  -- 3. Return profile data

  return nil, "Not yet implemented"
end

---
-- Calculate terrain statistics for a bounding box
-- @param bbox table Bounding box {min_lat, min_lon, max_lat, max_lon}
-- @return table Statistics: min, max, average elevation
function elevation.get_stats(bbox)
  -- TODO: Implement terrain statistics
  -- Sample points within bounding box and calculate stats

  return nil, "Not yet implemented"
end

return elevation
