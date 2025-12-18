-- HTTP Utility Module
-- Wrapper for HTTP requests using LuaSocket

local http = {}

-- Load dependencies
local socket_http = require("socket.http")
local socket_url = require("socket.url")
local ltn12 = require("ltn12")

local settings = require("config.settings")

---
-- Make an HTTP GET request
-- @param url string URL to request
-- @param headers table Optional HTTP headers
-- @return string Response body, or nil and error
function http.get(url, headers)
  if not url or url == "" then
    return nil, "URL cannot be empty"
  end

  -- Default headers
  headers = headers or {}
  headers["User-Agent"] = headers["User-Agent"] or settings.HTTP.user_agent

  -- TODO: Implement GET request with error handling
  -- 1. Validate URL
  -- 2. Set up request with headers
  -- 3. Make request using socket.http
  -- 4. Handle timeouts and retries
  -- 5. Return response body or error

  local response_body = {}
  local result, status_code, response_headers = socket_http.request {
    url = url,
    method = "GET",
    headers = headers,
    sink = ltn12.sink.table(response_body)
  }

  if not result then
    return nil, status_code  -- status_code contains error message
  end

  return table.concat(response_body), nil
end

---
-- Make an HTTP POST request
-- @param url string URL to request
-- @param body string Request body
-- @param headers table Optional HTTP headers
-- @return string Response body, or nil and error
function http.post(url, body, headers)
  if not url or url == "" then
    return nil, "URL cannot be empty"
  end

  -- Default headers
  headers = headers or {}
  headers["User-Agent"] = headers["User-Agent"] or settings.HTTP.user_agent
  headers["Content-Type"] = headers["Content-Type"] or "application/json"
  headers["Content-Length"] = #body

  -- TODO: Implement POST request
  local response_body = {}
  local result, status_code, response_headers = socket_http.request {
    url = url,
    method = "POST",
    headers = headers,
    source = ltn12.source.string(body),
    sink = ltn12.sink.table(response_body)
  }

  if not result then
    return nil, status_code
  end

  return table.concat(response_body), nil
end

---
-- Make an HTTP GET request and parse JSON response
-- @param url string URL to request
-- @param headers table Optional HTTP headers
-- @return table Parsed JSON, or nil and error
function http.get_json(url, headers)
  local json = require("src.utils.json")

  local response, err = http.get(url, headers)
  if not response then
    return nil, err
  end

  -- Parse JSON
  local data, parse_err = json.decode(response)
  if not data then
    return nil, "Failed to parse JSON: " .. (parse_err or "unknown error")
  end

  return data, nil
end

---
-- Make an HTTP POST request with JSON body
-- @param url string URL to request
-- @param data table Data to encode as JSON
-- @param headers table Optional HTTP headers
-- @return table Parsed JSON response, or nil and error
function http.post_json(url, data, headers)
  local json = require("src.utils.json")

  -- Encode data as JSON
  local body = json.encode(data)

  headers = headers or {}
  headers["Content-Type"] = "application/json"

  local response, err = http.post(url, body, headers)
  if not response then
    return nil, err
  end

  -- Parse JSON response
  local response_data, parse_err = json.decode(response)
  if not response_data then
    return nil, "Failed to parse JSON response: " .. (parse_err or "unknown error")
  end

  return response_data, nil
end

---
-- Build URL with query parameters
-- @param base_url string Base URL
-- @param params table Query parameters
-- @return string Complete URL with parameters
function http.build_url(base_url, params)
  if not params or next(params) == nil then
    return base_url
  end

  local query_parts = {}
  for key, value in pairs(params) do
    local encoded_value = socket_url.escape(tostring(value))
    table.insert(query_parts, string.format("%s=%s", key, encoded_value))
  end

  return base_url .. "?" .. table.concat(query_parts, "&")
end

---
-- Make an HTTP request with retry logic
-- @param method string HTTP method (GET, POST)
-- @param url string URL to request
-- @param options table Request options
-- @return string Response, or nil and error
function http.request_with_retry(method, url, options)
  options = options or {}
  local max_retries = options.max_retries or settings.HTTP.max_retries
  local retry_count = 0

  while retry_count < max_retries do
    local response, err

    if method == "GET" then
      response, err = http.get(url, options.headers)
    elseif method == "POST" then
      response, err = http.post(url, options.body, options.headers)
    else
      return nil, "Unsupported HTTP method: " .. method
    end

    if response then
      return response, nil
    end

    -- Retry on failure
    retry_count = retry_count + 1
    if retry_count < max_retries then
      -- Wait before retrying (exponential backoff)
      local wait_time = math.pow(2, retry_count - 1)
      socket.sleep(wait_time)
    end
  end

  return nil, "Max retries exceeded"
end

return http
