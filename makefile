# Makefile for building the trayslate Lazarus project in Release mode

# Path to lazbuild
LAZBUILD = lazbuild

# Lazarus project file
PROJECT = trayslate.lpi

# Target build mode
MODE = Release

# Default target
all:
	@echo "Building project in $(MODE) mode..."
	$(LAZBUILD) --build-mode=$(MODE) $(PROJECT)

# Clean target
clean:
	@echo "Cleaning up compiled units..."
	find . -type f \( -name "*.o" -o -name "*.ppu" -o -name "*.compiled" \) -delete
	rm -f trayslate

