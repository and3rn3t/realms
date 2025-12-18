# 🏰 Realm Forge ⚔️

Transform real-world locations into magical fantasy realms using Lua and public APIs!

## ✨ Overview

**Realm Forge** is a creative Lua-based tool that takes any real-world address and generates a rich fantasy world complete with:

- 🗺️ **Terrain Mapping**: Mountains become Dragon Peaks, swamps turn into Cursed Wetlands
- 🧙 **NPC Generation**: Populate your realm with unique characters
- 📜 **Lore Creation**: AI-generated backstories and historical context
- 👑 **Faction Systems**: Kingdoms, guilds, and rival groups
- ⚔️ **Quest Generation**: Adventures and missions for your realm
- 🐉 **D&D Integration**: Monsters and items from the D&D 5e API

## 🌟 Features

- **Geographic Intelligence**: Uses real elevation, climate, and terrain data
- **Multiple API Integration**: Combines data from 7+ public APIs
- **Fantasy Transformation**: Applies fantasy themes to real-world geography
- **NPC Diversity**: Generates characters with faces, names, and backgrounds
- **Extensible**: Modular design for easy customization
- **Free to Use**: Primarily uses free, open APIs

## 🔌 APIs Used

This project integrates the following public APIs:

- **[OpenStreetMap Nominatim](https://nominatim.openstreetmap.org/)** - Geocoding and location search
- **[Open Topo Data](https://www.opentopodata.org/)** - Elevation data
- **[Open-Meteo](https://open-meteo.com/)** - Weather and climate information
- **[RandomUser.me](https://randomuser.me/)** - NPC face and name generation
- **[D&D 5e API](https://www.dnd5eapi.co/)** - Monsters, spells, and items
- **[HuggingFace](https://huggingface.co/)** - AI-powered lore generation (optional, requires API key)
- **[Wikipedia](https://www.wikipedia.org/)** - Historical context for enriched lore

## 📋 Prerequisites

- **Lua** 5.3 or higher
- **LuaRocks** (Lua package manager)
- Internet connection (for API calls)

### Installing Lua and LuaRocks

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install lua5.4 liblua5.4-dev luarocks
```

**macOS (with Homebrew):**
```bash
brew install lua luarocks
```

**Windows:**
- Download from [lua.org](https://www.lua.org/download.html)
- Or use [LuaForWindows](https://github.com/rjpcomputing/luaforwindows)

## 🚀 Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/and3rn3t/realms.git
   cd realms
   ```

2. **Install dependencies:**
   ```bash
   luarocks install --only-deps realm-forge-dev-1.rockspec
   ```

3. **Set up environment (optional):**
   ```bash
   cp .env.example .env
   # Edit .env with your API keys if using optional features
   ```

## 🎮 Quick Start

### Basic Usage

```lua
-- Load the realm generator
local RealmForge = require("src.init")

-- Generate a realm from an address
local realm = RealmForge.generate({
  address = "Seattle, Washington",
  radius = 50  -- km radius to explore
})

-- Print the generated realm
print(realm:to_json())
```

### Run the Example

```bash
lua examples/generate_realm.lua
```

## 📁 Project Structure

```
realms/
├── .gitignore                 # Ignore patterns
├── .luacheckrc                # Lua linter config
├── .editorconfig              # Editor settings
├── .env.example               # API key template
├── README.md                  # This file
├── LICENSE                    # MIT License
├── realm-forge-dev-1.rockspec # Dependency specification
├── config/
│   └── settings.lua           # Configuration and constants
├── src/
│   ├── init.lua               # Main entry point
│   ├── api/                   # API client modules
│   │   ├── nominatim.lua      # Geocoding
│   │   ├── elevation.lua      # Elevation data
│   │   ├── weather.lua        # Weather/climate
│   │   ├── randomuser.lua     # NPC generation
│   │   ├── dnd.lua            # D&D content
│   │   ├── huggingface.lua    # AI lore
│   │   └── wikipedia.lua      # Historical context
│   ├── core/                  # Core game logic
│   │   ├── realm.lua          # Main Realm class
│   │   ├── location.lua       # Location data
│   │   ├── npc.lua            # NPC logic
│   │   ├── lore.lua           # Lore generation
│   │   └── terrain.lua        # Terrain classification
│   ├── generators/            # Content generators
│   │   ├── name_generator.lua # Fantasy names
│   │   ├── faction_generator.lua # Kingdoms/factions
│   │   └── quest_generator.lua   # Quests/adventures
│   └── utils/                 # Utility modules
│       ├── http.lua           # HTTP wrapper
│       ├── json.lua           # JSON utilities
│       └── helpers.lua        # Helper functions
├── output/                    # Generated realm files
│   └── .gitkeep
└── examples/
    └── generate_realm.lua     # Example script
```

## ⚙️ Configuration

### Terrain Classification

Realm Forge transforms real-world terrain into fantasy equivalents:

| Real Terrain | Elevation | Fantasy Theme |
|--------------|-----------|---------------|
| Mountains | >500m | Dragon Peaks / Dwarf Strongholds |
| Hills | 200-500m | Hobbit Shires / Gnome Villages |
| Plains | Variable | Nomad Grasslands / Human Farmlands |
| Wetlands | <10m | Cursed Swamps / Haunted Marshes |
| Forests | Any | Enchanted Woodlands / Elven Realms |
| Rivers/Lakes | Water | Sacred Waters / Mystic Shores |
| Urban | Any | Kingdom Capitals / Trading Hubs |
| Coastline | Sea level | Pirate Havens / Port Cities |

### API Configuration

Default API endpoints are configured in `config/settings.lua`. You can customize them or add your own API integrations.

### Environment Variables

Optional API keys can be set in `.env`:
- `HUGGINGFACE_API_KEY` - For AI-generated lore (requires account)
- `MAPBOX_API_KEY` - For enhanced map features
- `UNSPLASH_API_KEY` - For realm imagery

## 🛠️ Development

### Running the Linter

```bash
luacheck .
```

### Testing Individual Modules

```lua
-- Test geocoding
local nominatim = require("src.api.nominatim")
local result = nominatim.search("Seattle, WA")
print(result)
```

## 🤝 Contributing

Contributions are welcome! This is a learning project exploring Lua and API integration.

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run the linter (`luacheck .`)
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Ideas for Contributions

- Add new API integrations
- Improve terrain classification logic
- Create new fantasy themes
- Add more NPC characteristics
- Enhance lore generation
- Add export formats (JSON, Markdown, HTML)
- Create a web interface
- Add unit tests

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Thanks to all the free and open API providers
- Inspired by tabletop RPGs and world-building communities
- Built as a learning project to explore Lua programming

## 📞 Contact

- GitHub: [@and3rn3t](https://github.com/and3rn3t)
- Project: [realms](https://github.com/and3rn3t/realms)

---

**Happy world-building!** 🌍✨🏰