-- Wikipedia API Client
-- Fetch historical and geographical context
-- API Docs: https://www.mediawiki.org/wiki/API:Main_page

local wikipedia = {}

local http = require("src.utils.http")
local settings = require("config.settings")

local BASE_URL = settings.API.WIKIPEDIA

---
-- Search Wikipedia for articles
-- @param query string Search query
-- @param limit number Number of results (default: 5)
-- @return table Array of search results or nil and error
function wikipedia.search(query, limit)
  limit = limit or 5

  if not query or query == "" then
    return nil, "Query cannot be empty"
  end

  -- TODO: Implement Wikipedia search
  -- 1. Build request URL with search parameters
  -- 2. Use action=opensearch or action=query
  -- 3. Make HTTP GET request
  -- 4. Parse JSON response
  -- 5. Return article titles and snippets

  -- Example: https://en.wikipedia.org/w/api.php?action=opensearch&search=Seattle&limit=5

  return nil, "Not yet implemented"
end

---
-- Get Wikipedia article summary
-- @param title string Article title
-- @return table Article summary data or nil and error
function wikipedia.get_summary(title)
  if not title or title == "" then
    return nil, "Title cannot be empty"
  end

  -- TODO: Implement article summary retrieval
  -- 1. Build request URL with title parameter
  -- 2. Use action=query&prop=extracts&exintro=1
  -- 3. Make HTTP GET request
  -- 4. Parse JSON response
  -- 5. Extract summary text
  -- 6. Return cleaned summary

  return nil, "Not yet implemented"
end

---
-- Get historical context for a location
-- @param location_name string Location name
-- @return string Historical context text or nil and error
function wikipedia.get_location_history(location_name)
  -- TODO: Implement location history retrieval
  -- 1. Search for location article
  -- 2. Get summary/history section
  -- 3. Extract relevant historical facts
  -- 4. Return formatted historical context

  return nil, "Not yet implemented"
end

---
-- Get random Wikipedia article
-- @return table Random article data or nil and error
function wikipedia.get_random()
  -- TODO: Implement random article retrieval
  -- Useful for generating unexpected lore elements

  return nil, "Not yet implemented"
end

---
-- Extract key facts from Wikipedia text
-- @param text string Wikipedia article text
-- @return table Array of key facts
function wikipedia.extract_facts(text)
  -- TODO: Parse Wikipedia text and extract interesting facts
  -- Look for dates, names, events, etc.
  -- Useful for generating lore inspiration

  return nil, "Not yet implemented"
end

return wikipedia
