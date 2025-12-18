# Realms - Makefile
# Simple commands for development

.PHONY: run clean lint build help

# Default target
help:
	@echo "Available commands:"
	@echo "  make run    - Run the game with LÖVE2D"
	@echo "  make lint   - Run luacheck linter"
	@echo "  make build  - Create .love distribution file"
	@echo "  make clean  - Remove build artifacts"

# Run the game
run:
	love .

# Lint the code
lint:
	luacheck . --no-color

# Build .love file for distribution
build:
	zip -9 -r realms.love . -x "*.git*" -x "Makefile" -x "*.love" -x ".editorconfig" -x ".luacheckrc"

# Clean build artifacts
clean:
	rm -f *.love
	rm -f *.log
