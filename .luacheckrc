-- Luacheck configuration for Realm Forge
-- See: https://luacheck.readthedocs.io/en/stable/config.html

-- Lua version
std = "lua54"

-- Maximum line length
max_line_length = 120

-- Maximum code complexity
max_cyclomatic_complexity = 15

-- Global variables that are allowed
globals = {
  "require",
  "print",
  "io",
  "os",
  "arg"
}

-- Read-only globals (allowed to read, not write)
read_globals = {
  "string",
  "table",
  "math",
  "debug",
  "package",
  "coroutine",
  "_VERSION"
}

-- Ignored warnings
ignore = {
  "212", -- Unused argument (common in callback functions)
  "213", -- Unused loop variable
}

-- Files to exclude
exclude_files = {
  "lua_modules/",
  ".luarocks/",
  "output/"
}

-- Allow unused self in methods
self = false
