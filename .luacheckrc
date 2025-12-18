-- Luacheck configuration
-- See: https://luacheck.readthedocs.io/

-- Standard globals
std = "lua51+love"

-- LÖVE specific globals
globals = {
    "love",
}

-- Read-only globals (libraries you may add)
read_globals = {
    -- Add library globals here as needed
    -- "Class",
    -- "Vector",
}

-- Ignore unused self arguments (common in OOP)
self = false

-- Max line length (0 = no limit)
max_line_length = 120

-- Files/directories to ignore
exclude_files = {
    "libs/*",
    ".luarocks/*",
}

-- Ignore specific warnings
ignore = {
    "212", -- Unused argument
    "213", -- Unused loop variable
}
