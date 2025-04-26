#!/bin/bash

# Terminal control codes and colors
ESC=$(printf "\033")
RESET="${ESC}[0m"
BOLD="${ESC}[1m"
RED="${ESC}[31m"
GREEN="${ESC}[32m"
YELLOW="${ESC}[33m"
BLUE="${ESC}[34m"
MAGENTA="${ESC}[35m"
CYAN="${ESC}[36m"
WHITE="${ESC}[37m"
BG_BLACK="${ESC}[40m"
BG_BLUE="${ESC}[44m"

# Game configuration variables
score=0
total_chars=0
game_duration=60  # Game duration in seconds
char_display_time=3  # Time a character is displayed before changing (in seconds)
difficulty_level=1  # Default: 1=Easy, 2=Medium, 3=Hard
category=1         # Default: 1=Letters, 2=Numbers, 3=Mixed, 4=Custom Words
custom_words=""

# Function to clear the screen
clear_screen() {
    clear
}

# Function to handle exit
graceful_exit() {
    clear_screen
    tput cnorm  # Show cursor
    tput rmcup  # Restore terminal content
    echo -e "${GREEN}Thanks for playing the Typing Game!${RESET}"
    exit 0
}

# Trap SIGINT (Ctrl+C) and SIGTERM signals
trap graceful_exit SIGINT SIGTERM

# Function to display welcome screen
display_welcome() {
    clear_screen
    echo -e "${BOLD}${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                                                            ║"
    echo "║                   BASH TYPING GAME                         ║"
    echo "║                                                            ║"
    echo "║  Improve your typing skills with this simple typing game!  ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo -e "${CYAN}Press Enter to continue...${RESET}"
    read
}

# Function to select difficulty level
select_difficulty() {
    clear_screen
    echo -e "${BOLD}${YELLOW}Select Difficulty Level:${RESET}"
    echo -e "${CYAN}1. Easy${RESET} (Characters change every 3 seconds)"
    echo -e "${CYAN}2. Medium${RESET} (Characters change every 2 seconds)"
    echo -e "${CYAN}3. Hard${RESET} (Characters change every 1 second)"
    echo
    echo -n "Enter your choice [1-3]: "
    read choice

    case $choice in
        1) difficulty_level=1; char_display_time=3 ;;
        2) difficulty_level=2; char_display_time=2 ;;
        3) difficulty_level=3; char_display_time=1 ;;
        *) echo -e "${RED}Invalid choice. Defaulting to Easy.${RESET}"; sleep 1; difficulty_level=1; char_display_time=3 ;;
    esac
}

# Function to select typing category
select_category() {
    clear_screen
    echo -e "${BOLD}${YELLOW}Select Typing Category:${RESET}"
    echo -e "${CYAN}1. Letters${RESET} (Practice typing alphabets A-Z, a-z)"
    echo -e "${CYAN}2. Numbers${RESET} (Practice typing digits 0-9)"
    echo -e "${CYAN}3. Mixed${RESET} (Practice typing both letters and numbers)"
    echo -e "${CYAN}4. Custom Words${RESET} (Practice typing your own custom words)"
    echo
    echo -n "Enter your choice [1-4]: "
    read choice

    case $choice in
        1) category=1 ;;
        2) category=2 ;;
        3) category=3 ;;
        4) category=4 
           echo -n "Enter custom words (separated by spaces): "
           read custom_words
           ;;
        *) echo -e "${RED}Invalid choice. Defaulting to Letters.${RESET}"; sleep 1; category=1 ;;
    esac
}

# Function to draw border
draw_border() {
    local width=$1
    local height=$2
    local x=$3
    local y=$4

    # Draw top border
    tput cup $y $x
    echo -n "╔"
    for ((i=1; i<width-1; i++)); do
        echo -n "═"
    done
    echo "╗"

    # Draw sides
    for ((i=1; i<height-1; i++)); do
        tput cup $((y+i)) $x
        echo -n "║"
        tput cup $((y+i)) $((x+width-1))
        echo "║"
    done

    # Draw bottom border
    tput cup $((y+height-1)) $x
    echo -n "╚"
    for ((i=1; i<width-1; i++)); do
        echo -n "═"
    done
    echo "╝"
}

# Function to fill background color
fill_background() {
    local width=$1
    local height=$2
    local x=$3
    local y=$4
    local color=$5

    for ((i=1; i<height-1; i++)); do
        tput cup $((y+i)) $((x+1))
        echo -ne "$color"
        for ((j=1; j<width-1; j++)); do
            echo -n " "
        done
        echo -ne "${RESET}"
    done
}

# Function to generate a random character based on category
generate_random_char() {
    case $category in
        1) # Letters
            chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
            echo "${chars:RANDOM%52:1}"
            ;;
        2) # Numbers
            echo $((RANDOM % 10))
            ;;
        3) # Mixed
            chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            echo "${chars:RANDOM%62:1}"
            ;;
        4) # Custom Words
            if [ -z "$custom_words" ]; then
                chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                echo "${chars:RANDOM%52:1}"
            else
                IFS=' ' read -ra words <<< "$custom_words"
                selected_word=${words[RANDOM % ${#words[@]}]}
                echo "${selected_word:RANDOM%${#selected_word}:1}"
            fi
            ;;
    esac
}

# Function to display game instructions
display_instructions() {
    clear_screen
    echo -e "${BOLD}${YELLOW}Game Instructions:${RESET}"
    echo -e "1. Random characters will appear on the screen."
    echo -e "2. Type each character before it disappears."
    echo -e "3. Each correct character earns you a point."
    echo -e "4. The game will run for ${game_duration} seconds."
    echo -e "5. Press ${BOLD}Ctrl+C${RESET} at any time to exit the game."
    echo
    echo -e "${CYAN}Difficulty:${RESET} $([ $difficulty_level -eq 1 ] && echo "Easy" || [ $difficulty_level -eq 2 ] && echo "Medium" || echo "Hard")"
    echo -e "${CYAN}Category:${RESET} $([ $category -eq 1 ] && echo "Letters" || [ $category -eq 2 ] && echo "Numbers" || [ $category -eq 3 ] && echo "Mixed" || echo "Custom Words")"
    echo
    echo -e "${GREEN}Press Enter to start the game...${RESET}"
    read
}

# Main game function
play_game() {
    local terminal_width=$(tput cols)
    local terminal_height=$(tput lines)
    local game_width=50
    local game_height=10
    local start_x=$(( (terminal_width - game_width) / 2 ))
    local start_y=$(( (terminal_height - game_height) / 2 ))

    # Set up terminal for the game
    tput smcup  # Save terminal content
    tput civis  # Hide cursor
    stty -echo  # Don't echo typed characters

    clear_screen
    
    # Draw game UI
    draw_border $game_width $game_height $start_x $start_y
    fill_background $game_width $game_height $start_x $start_y "$BG_BLACK"

    # Display score area
    tput cup $((start_y+game_height+1)) $start_x
    echo -e "${YELLOW}Score: ${score}   Accuracy: 0%   Time Left: ${game_duration}s${RESET}"

    # Character display position
    local char_x=$(( start_x + (game_width / 2) ))
    local char_y=$(( start_y + (game_height / 2) ))

    # Game loop variables
    local start_time=$(date +%s)
    local current_char=""
    local input_char=""
    local last_update=0
    local correct_chars=0

    # Non-blocking input setup
    exec 3<&0
    while true; do
        # Get current time
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        
        # Check if game time is up
        if [ $elapsed -ge $game_duration ]; then
            break
        fi

        # Update time left display
        local time_left=$((game_duration - elapsed))
        tput cup $((start_y+game_height+1)) $((start_x + 39))
        echo -e "${time_left}s"

        # Generate a new character if needed
        if [ $((current_time - last_update)) -ge $char_display_time ] || [ -z "$current_char" ]; then
            current_char=$(generate_random_char)
            tput cup $char_y $char_x
            echo -e "${BOLD}${MAGENTA}${current_char}${RESET}"
            last_update=$current_time
        fi

        # Check if user input is available (non-blocking)
        if read -t 0.1 -n 1 input_char <&3; then
            # Increment total characters typed
            ((total_chars++))
            
            # Check if input matches the current character
            if [ "$input_char" = "$current_char" ]; then
                ((score++))
                ((correct_chars++))
                tput cup $char_y $char_x
                echo -e "${BOLD}${GREEN}${current_char}${RESET}"
                sleep 0.2
                current_char=""  # Clear current char to generate a new one
            else
                tput cup $char_y $char_x
                echo -e "${BOLD}${RED}${current_char}${RESET}"
                sleep 0.2
            fi

            # Update score and accuracy
            local accuracy=0
            if [ $total_chars -gt 0 ]; then
                accuracy=$(( (correct_chars * 100) / total_chars ))
            fi
            tput cup $((start_y+game_height+1)) $start_x
            echo -e "${YELLOW}Score: ${score}   Accuracy: ${accuracy}%   Time Left: ${time_left}s${RESET}"
        fi
    done

    # Clean up
    exec 3<&-
    stty echo   # Restore echo
    
    # Show final results
    tput cup $((start_y+game_height/2)) $((start_x+5))
    echo -e "${BOLD}${GREEN}Game Over!${RESET}"
    tput cup $((start_y+game_height/2+1)) $((start_x+5))
    
    local accuracy=0
    if [ $total_chars -gt 0 ]; then
        accuracy=$(( (correct_chars * 100) / total_chars ))
    fi
    
    echo -e "${BOLD}Final Score: ${score}   Accuracy: ${accuracy}%${RESET}"
    tput cup $((start_y+game_height/2+2)) $((start_x+5))
    echo -e "${CYAN}Press any key to continue...${RESET}"
    
    tput cnorm  # Show cursor
    read -n 1
    tput rmcup  # Restore terminal content
}

# Main menu function
main_menu() {
    while true; do
        clear_screen
        echo -e "${BOLD}${BLUE}"
        echo "╔════════════════════════════════════════════════════════════╗"
        echo "║                     BASH TYPING GAME                       ║"
        echo "╚════════════════════════════════════════════════════════════╝"
        echo -e "${RESET}"
        echo -e "${CYAN}1. Play Game${RESET}"
        echo -e "${CYAN}2. Select Difficulty${RESET}"
        echo -e "${CYAN}3. Select Category${RESET}"
        echo -e "${CYAN}4. Instructions${RESET}"
        echo -e "${CYAN}5. Exit${RESET}"
        echo
        echo -n "Enter your choice [1-5]: "
        read choice

        case $choice in
            1) play_game ;;
            2) select_difficulty ;;
            3) select_category ;;
            4) display_instructions ;;
            5) graceful_exit ;;
            *) echo -e "${RED}Invalid choice. Please try again.${RESET}"; sleep 1 ;;
        esac
    done
}

# Initialize the game
tput init     # Initialize terminal
display_welcome
main_menu