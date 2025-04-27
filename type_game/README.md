# Bash Typing Game

A feature-rich terminal-based typing game built entirely in Bash that helps users improve their typing skills through an engaging, interactive experience.

## Features

- Interactive terminal-based UI with colorful graphics
- Multiple difficulty levels (Easy, Medium, Hard)
- Various typing categories:
  - Letters (A-Z, a-z)
  - Numbers (0-9)
  - Mixed (alphanumeric)
  - Custom words (user-defined)
- Real-time scoring and accuracy tracking
- Timed gameplay (60-second challenges)
- Attractive terminal UI with borders and color highlighting

## Requirements

- Bash shell (version 4.0 or higher recommended)
- Unix-based terminal with color support
- Standard Unix utilities

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/bash-typing-game.git
   ```

2. Make the script executable:
   ```bash
   chmod +x typing-game.sh
   ```

3. Run the game:
   ```bash
   ./typing-game.sh
   ```

## How to Play

1. From the main menu, select "Play Game" or customize settings first
2. Type each character that appears before it disappears
3. Score points for each correct character you type
4. Try to achieve the highest score and accuracy within the time limit

### Game Controls

- Type the displayed characters to score points
- Press `Ctrl+C` at any time to exit the game

## Game Settings

### Difficulty Levels

- **Easy**: Characters change every 3 seconds
- **Medium**: Characters change every 2 seconds
- **Hard**: Characters change every 1 second

### Typing Categories

- **Letters**: Practice typing alphabets (A-Z, a-z)
- **Numbers**: Practice typing digits (0-9)
- **Mixed**: Practice typing both letters and numbers
- **Custom Words**: Practice with your own custom words

## Technical Details

The game uses:
- ANSI terminal control sequences for colors and positioning
- Bash's built-in timing and random number generation
- Non-blocking input for smooth gameplay
- Terminal manipulation for a full-screen gaming experience

## Customization

You can modify the following variables in the script to customize your experience:
- `game_duration`: Change the length of each game (default: 60 seconds)
- `char_display_time`: Adjust default character display duration
- Add new categories by modifying the `select_category` function

