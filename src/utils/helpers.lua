-- Helper Utilities
-- General-purpose helper functions

local helpers = {}

---
-- Deep copy a table
-- @param original table Table to copy
-- @return table Deep copy of the table
function helpers.deep_copy(original)
  if type(original) ~= "table" then
    return original
  end

  local copy = {}
  for key, value in pairs(original) do
    copy[helpers.deep_copy(key)] = helpers.deep_copy(value)
  end

  return setmetatable(copy, getmetatable(original))
end

---
-- Merge two tables (shallow merge)
-- @param t1 table First table
-- @param t2 table Second table (overwrites values from t1)
-- @return table Merged table
function helpers.merge_tables(t1, t2)
  local result = {}

  for k, v in pairs(t1) do
    result[k] = v
  end

  for k, v in pairs(t2) do
    result[k] = v
  end

  return result
end

---
-- Check if a table contains a value
-- @param table table Table to search
-- @param value any Value to find
-- @return boolean True if value is found
function helpers.table_contains(table, value)
  for _, v in ipairs(table) do
    if v == value then
      return true
    end
  end
  return false
end

---
-- Get random element from array
-- @param array table Array to pick from
-- @return any Random element, or nil if array is empty
function helpers.random_choice(array)
  if not array or #array == 0 then
    return nil
  end
  return array[math.random(#array)]
end

---
-- Shuffle an array in place
-- @param array table Array to shuffle
-- @return table Shuffled array
function helpers.shuffle(array)
  for i = #array, 2, -1 do
    local j = math.random(i)
    array[i], array[j] = array[j], array[i]
  end
  return array
end

---
-- Calculate distance between two coordinates (Haversine formula)
-- @param lat1 number First latitude
-- @param lon1 number First longitude
-- @param lat2 number Second latitude
-- @param lon2 number Second longitude
-- @return number Distance in kilometers
function helpers.calculate_distance(lat1, lon1, lat2, lon2)
  local earth_radius = 6371  -- km

  local dlat = math.rad(lat2 - lat1)
  local dlon = math.rad(lon2 - lon1)

  local a = math.sin(dlat / 2) * math.sin(dlat / 2) +
            math.cos(math.rad(lat1)) * math.cos(math.rad(lat2)) *
            math.sin(dlon / 2) * math.sin(dlon / 2)

  local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

  return earth_radius * c
end

---
-- Generate a bounding box around a center point
-- @param lat number Center latitude
-- @param lon number Center longitude
-- @param radius number Radius in kilometers
-- @return table Bounding box {min_lat, min_lon, max_lat, max_lon}
function helpers.generate_bounding_box(lat, lon, radius)
  -- Approximate conversion: 1 degree latitude ≈ 111 km
  -- Longitude varies with latitude
  local lat_offset = radius / 111.0
  local lon_offset = radius / (111.0 * math.cos(math.rad(lat)))

  return {
    min_lat = lat - lat_offset,
    min_lon = lon - lon_offset,
    max_lat = lat + lat_offset,
    max_lon = lon + lon_offset
  }
end

---
-- Load environment variables from .env file
-- @param filepath string Path to .env file (default: ".env")
-- @return table Environment variables
function helpers.load_env(filepath)
  filepath = filepath or ".env"

  local env = {}
  local file = io.open(filepath, "r")

  if not file then
    return env  -- Return empty table if file doesn't exist
  end

  for line in file:lines() do
    -- Skip comments and empty lines
    if line:match("^%s*#") or line:match("^%s*$") then
      goto continue
    end

    -- Parse KEY=VALUE
    local key, value = line:match("^%s*([%w_]+)%s*=%s*(.*)%s*$")
    if key and value then
      -- Remove quotes if present
      value = value:match('^"(.*)"$') or value:match("^'(.*)'$") or value
      env[key] = value
    end

    ::continue::
  end

  file:close()
  return env
end

---
-- Set environment variables
-- @param env table Environment variables to set
function helpers.set_env(env)
  for key, value in pairs(env) do
    os.setenv(key, value)
  end
end

---
-- Clamp a value between min and max
-- @param value number Value to clamp
-- @param min number Minimum value
-- @param max number Maximum value
-- @return number Clamped value
function helpers.clamp(value, min, max)
  return math.max(min, math.min(max, value))
end

---
-- Round a number to specified decimal places
-- @param number number Number to round
-- @param decimals number Number of decimal places (default: 0)
-- @return number Rounded number
function helpers.round(number, decimals)
  decimals = decimals or 0
  local multiplier = 10 ^ decimals
  return math.floor(number * multiplier + 0.5) / multiplier
end

---
-- Format a number with thousands separators
-- @param number number Number to format
-- @return string Formatted number string
function helpers.format_number(number)
  local formatted = tostring(number)
  local k

  while true do
    formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
    if k == 0 then
      break
    end
  end

  return formatted
end

---
-- Sleep for specified seconds
-- @param seconds number Seconds to sleep
function helpers.sleep(seconds)
  local socket = require("socket")
  socket.sleep(seconds)
end

---
-- Print a table (for debugging)
-- @param t table Table to print
-- @param indent number Current indentation level
function helpers.print_table(t, indent)
  indent = indent or 0
  local prefix = string.rep("  ", indent)

  if type(t) ~= "table" then
    print(prefix .. tostring(t))
    return
  end

  for k, v in pairs(t) do
    if type(v) == "table" then
      print(prefix .. tostring(k) .. ":")
      helpers.print_table(v, indent + 1)
    else
      print(prefix .. tostring(k) .. ": " .. tostring(v))
    end
  end
end

return helpers
