-- JSON Utility Module
-- JSON encoding and decoding

local json = {}

-- Try to load a JSON library
-- Prefer dkjson as it's pure Lua and widely available
local has_dkjson, dkjson = pcall(require, "dkjson")
local has_cjson, cjson = pcall(require, "cjson")

---
-- Encode a Lua table to JSON string
-- @param data table Data to encode
-- @return string JSON string, or nil and error
function json.encode(data)
  if not data then
    return nil, "Data cannot be nil"
  end

  if has_cjson then
    local success, result = pcall(cjson.encode, data)
    if success then
      return result, nil
    else
      return nil, "cjson encoding error: " .. tostring(result)
    end
  elseif has_dkjson then
    local result, err = dkjson.encode(data)
    if result then
      return result, nil
    else
      return nil, "dkjson encoding error: " .. tostring(err)
    end
  else
    return nil, "No JSON library available. Install dkjson or lua-cjson"
  end
end

---
-- Decode a JSON string to Lua table
-- @param json_str string JSON string to decode
-- @return table Decoded data, or nil and error
function json.decode(json_str)
  if not json_str or json_str == "" then
    return nil, "JSON string cannot be empty"
  end

  if has_cjson then
    local success, result = pcall(cjson.decode, json_str)
    if success then
      return result, nil
    else
      return nil, "cjson decoding error: " .. tostring(result)
    end
  elseif has_dkjson then
    local result, pos, err = dkjson.decode(json_str)
    if result then
      return result, nil
    else
      return nil, "dkjson decoding error at position " .. tostring(pos) .. ": " .. tostring(err)
    end
  else
    return nil, "No JSON library available. Install dkjson or lua-cjson"
  end
end

---
-- Pretty print JSON
-- @param data table Data to encode
-- @param indent string Indentation string (default: "  ")
-- @return string Pretty-printed JSON, or nil and error
function json.encode_pretty(data, indent)
  indent = indent or "  "

  if has_dkjson then
    -- dkjson supports pretty printing
    local result, err = dkjson.encode(data, {indent = true})
    if result then
      return result, nil
    else
      return nil, "dkjson encoding error: " .. tostring(err)
    end
  elseif has_cjson then
    -- cjson doesn't support pretty printing, use basic encoding
    return json.encode(data)
  else
    return nil, "No JSON library available. Install dkjson or lua-cjson"
  end
end

---
-- Check if a JSON library is available
-- @return boolean True if a JSON library is loaded
function json.is_available()
  return has_dkjson or has_cjson
end

---
-- Get the name of the loaded JSON library
-- @return string Library name or "none"
function json.get_library_name()
  if has_cjson then
    return "lua-cjson"
  elseif has_dkjson then
    return "dkjson"
  else
    return "none"
  end
end

---
-- Save data to JSON file
-- @param filepath string File path
-- @param data table Data to save
-- @return boolean Success, or nil and error
function json.save_to_file(filepath, data)
  local json_str, err = json.encode_pretty(data)
  if not json_str then
    return nil, err
  end

  local file, file_err = io.open(filepath, "w")
  if not file then
    return nil, "Failed to open file: " .. tostring(file_err)
  end

  file:write(json_str)
  file:close()

  return true, nil
end

---
-- Load data from JSON file
-- @param filepath string File path
-- @return table Loaded data, or nil and error
function json.load_from_file(filepath)
  local file, err = io.open(filepath, "r")
  if not file then
    return nil, "Failed to open file: " .. tostring(err)
  end

  local content = file:read("*all")
  file:close()

  return json.decode(content)
end

return json
