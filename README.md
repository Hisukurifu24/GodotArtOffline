# RPG Survival

A turn-based combat RPG game built with Godot Engine 4.4.

## Technologies

- **Godot Engine 4.4** - Game engine
- **GDScript** - Primary programming language

## Features

- **Turn-Based Combat System** - Strategic combat with speed-based turn order
- **Ability System** - Multiple ability types (physical, magical, healing)
- **Character Stats** - HP, MP, armor, magic resistance, and speed attributes
- **Combat AI** - Enemy decision-making system for ability selection
- **Damage Calculation** - Stat scaling and damage type resistances
- **Run Away Mechanic** - Speed-based escape system
- **Combat GUI** - User interface for combat interactions
- **Scene Management** - Transition between combat and main game scenes

## What I Learned

- Implementing turn-based combat systems in Godot
- Managing game state across different scenes
- Creating flexible ability systems with inheritance (AttackAbility, HealingAbility)
- Using signals for event-driven architecture (trying_to_run, used_ability)
- Working with resource files (.tres) for game data
- Implementing AI decision-making for enemy behavior
- Async/await patterns in GDScript for timing and animation
- Character stat systems and damage calculation formulas

## What Could Be Improved

- **Error Handling** - Add validation for null references and edge cases
- **Code Organization** - Separate damage calculation and turn logic into dedicated classes
- **Magic Numbers** - Move hardcoded values (timeouts, damage formulas) to constants or configuration files
- **Save System** - Implement save/load functionality for player progress
- **More Abilities** - Expand the ability pool with diverse effects (buffs, debuffs, status effects)
- **Animation System** - Add more polished visual feedback for abilities and damage
- **Combat Variety** - Support for multiple enemies and party members
- **UI/UX** - Improve visual feedback and player information display
- **Testing Mode** - Remove or toggle the hardcoded testing setup in `_ready()`
- **Audio** - Add sound effects and music for combat

## How to Run

1. **Install Godot 4.4**
   - Download from [https://godotengine.org/](https://godotengine.org/)
   - Install to `e:\Godot\` or update the path in `.vscode\settings.json`

2. **Open the Project**
   - Launch Godot Engine
   - Click "Import"
   - Navigate to the project folder
   - Select `project.godot`

3. **Run the Game**
   - Press `F5` or click the "Play" button in Godot
   - The game will start in the main scene

4. **Development with VSCode** (Optional)
   - Install the "godot-tools" extension
   - Open the project folder in VSCode
   - The extension will provide GDScript syntax highlighting and LSP support

## Project Structure

```
GodotArtOffline/
├── Scripts/
│   └── Combat/
│       └── combat_manager.gd    # Main combat logic
├── Resources/
│   └── Abilities/               # Ability resource files
├── Scenes/                      # Game scenes
└── .vscode/
    └── settings.json            # VSCode configuration
```

