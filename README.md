# Realms

A LÖVE2D game project built with Lua.

## Requirements

- [LÖVE2D](https://love2d.org/) 11.4 or higher
- Lua 5.1 (bundled with LÖVE2D)

## Getting Started

### Install LÖVE2D

**Linux (Ubuntu/Debian):**
```bash
sudo apt install love
```

**macOS (Homebrew):**
```bash
brew install love
```

**Windows:**
Download from [love2d.org](https://love2d.org/)

### Run the Game

```bash
love .
```

Or drag the project folder onto the LÖVE executable.

## Project Structure

```
realms/
├── main.lua          # Entry point
├── conf.lua          # LÖVE2D configuration
├── src/              # Game source code
├── libs/             # Third-party libraries
└── assets/
    ├── images/       # Sprites, textures
    ├── sounds/       # Audio files
    └── fonts/        # Font files
```

## Recommended Libraries

For a small home project, these lightweight libraries are recommended:

### Essential (Pick what you need)

| Library | Purpose | Link |
|---------|---------|------|
| **bump.lua** | Simple AABB collision detection | [GitHub](https://github.com/kikito/bump.lua) |
| **hump** | Gamestates, timers, vectors, cameras | [GitHub](https://github.com/vrld/hump) |
| **lume** | Utility functions (tables, math, strings) | [GitHub](https://github.com/rxi/lume) |

### Graphics & UI

| Library | Purpose | Link |
|---------|---------|------|
| **push** | Resolution-independent rendering | [GitHub](https://github.com/Ulydev/push) |
| **SUIT** | Simple immediate-mode GUI | [GitHub](https://github.com/vrld/suit) |
| **anim8** | Sprite animation | [GitHub](https://github.com/kikito/anim8) |

### Data & Serialization

| Library | Purpose | Link |
|---------|---------|------|
| **bitser** | Fast binary serialization | [GitHub](https://github.com/gvx/bitser) |
| **json.lua** | JSON encoding/decoding | [GitHub](https://github.com/rxi/json.lua) |

### Advanced (If needed later)

| Library | Purpose | Link |
|---------|---------|------|
| **Concord** | Entity Component System | [GitHub](https://github.com/Tjakka5/Concord) |
| **windfield** | Physics wrapper (Box2D) | [GitHub](https://github.com/a327ex/windfield) |
| **sti** | Tiled map loader | [GitHub](https://github.com/karai17/Simple-Tiled-Implementation) |

### Installing Libraries

1. Download the `.lua` file(s) from the library's GitHub
2. Place them in the `libs/` folder
3. Require them in your code:

```lua
local bump = require("libs.bump")
local lume = require("libs.lume")
```

## Development

### Quick Setup

Run the setup script to configure your development environment:

**Linux/macOS:**
```bash
chmod +x setup.sh
./setup.sh
```

**Windows (PowerShell):**
```powershell
.\setup.ps1
```

This will:
- Install luacheck (if needed)
- Configure Git pre-commit hooks
- Set up VS Code settings (if available)

See [DEVELOPMENT.md](DEVELOPMENT.md) for detailed development instructions.

### Code Style

This project uses:
- 4 spaces for indentation
- [luacheck](https://github.com/mpeterv/luacheck) for linting
- Pre-commit hooks for automatic linting

### Linting

```bash
make lint
# or
luacheck .
```

### Building for Distribution

Create a `.love` file:
```bash
zip -9 -r realms.love . -x "*.git*" -x "*.love"
```

## Resources

- [LÖVE2D Wiki](https://love2d.org/wiki/Main_Page)
- [awesome-love2d](https://github.com/love2d-community/awesome-love2d) - Curated library list
- [Sheepolution's Tutorial](https://sheepolution.com/learn/book/contents) - Beginner-friendly guide

## License

MIT
