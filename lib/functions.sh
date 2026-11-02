#!/bin/bash
# lib/functions.sh – all functions for Tic-Tac-Toe CLI
DATA="data/results.csv"

LOG="logs/activity.log"

# write one line to the activity log
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $*" >> "$LOG"
}

# check the data file / folder exists before using it
check_data() {
    if [ ! -e "$DATA" ]; then
        echo "Data not found: $DATA"
        return 1
    fi
}

show_help() {
    echo "Usage: ./main.sh            -> open the menu"
    echo "       ./main.sh --help     -> show this help"
    echo "       ./main.sh --backup   -> backup data/ now"
    echo "       ./main.sh --cron     -> run the scheduled (crontab) task"
}

view_data() {
    check_data || return
    if [ -d "$DATA" ]; then ls -l "$DATA"; else cat -n "$DATA" | more; fi
}

do_backup() {
    f="backups/data_$(date +%Y%m%d_%H%M%S).tar.gz"
    tar -czf "$f" data/
    echo "Backup saved: $f ($(du -h "$f" | cut -f1))"
    log "backup created $f"
}

view_log() {
    if [ -f "$LOG" ]; then tail -n 15 "$LOG"; else echo "No activity yet."; fi
}

# ------------------------------------------------------------
# FEATURE 1: Draw the 3×3 board from an array
# Commands you can use: arrays, nested loops, functions, case, awk
# ------------------------------------------------------------
feature_1() {
    echo "== Draw the 3x3 board from an array =="

    board=("1" "2" "3" "4" "5" "6" "7" "8" "9")

    for ((i=0; i<9; i++)); do
        printf " %s " "${board[$i]}"

        if (( (i + 1) % 3 == 0 )); then
            echo
            if (( i < 8 )); then
                echo "---+---+---"
            fi
        else
            printf "|"
        fi
    done

    log "feature_1 used"
}
#------------------------------------------------------------
# FEATURE 2: Take moves and reject filled cells
# Commands you can use: arrays, nested loops, functions, case, awk
# ------------------------------------------------------------

feature_2() {
    echo "== Take moves and reject filled cells =="

    board=("1" "2" "3" "4" "5" "6" "7" "8" "9")
    player="X"
    moves=0

    while (( moves < 9 )); do
        echo
        for ((i=0; i<9; i++)); do
            printf " %s " "${board[$i]}"
            if (( (i+1) % 3 == 0 )); then
                echo
                if (( i < 8 )); then
                    echo "---+---+---"
                fi
            else
                printf "|"
            fi
        done

        read -p "Player $player, choose cell (1-9): " cell

        if ! [[ "$cell" =~ ^[1-9]$ ]]; then
            echo "Invalid choice! Enter a number from 1 to 9."
            continue
        fi

        index=$((cell-1))

        if [[ "${board[$index]}" == "X" || "${board[$index]}" == "O" ]]; then
            echo "Cell already filled! Choose another cell."
            continue
        fi

        board[$index]=$player
        ((moves++))

        winner=$(check_winner "${board[@]}")

        if [[ "$winner" == "X" || "$winner" == "O" ]]; then
            LAST_RESULT="$winner"
            echo
            echo "Final board:"
            for ((i=0; i<9; i++)); do
                printf " %s " "${board[$i]}"
                if (( (i+1) % 3 == 0 )); then
                    echo
                    if (( i < 8 )); then
                        echo "---+---+---"
                    fi
                else
                    printf "|"
                fi
            done

            echo "Player $winner wins! Game Over."
            log "feature_2 used - Player $winner won"
            return
        fi

        if (( moves == 9 )); then
	    LAST_RESULT="DRAW"
            echo
            echo "Game is a Draw!"
            log "feature_2 used - Draw"
            return
        fi

        if [[ "$player" == "X" ]]; then
            player="O"
        else
            player="X"
        fi
    done
}

# ------------------------------------------------------------
# FEATURE 3: Check rows, columns and diagonals for a winner (function)
# Commands you can use: arrays, nested loops, functions, case, awk
# ------------------------------------------------------------

feature_3() {
    echo "== Check winner =="

    if [[ "$LAST_RESULT" == "X" || "$LAST_RESULT" == "O" ]]; then
        echo "Winner: Player $LAST_RESULT"
    elif [[ "$LAST_RESULT" == "DRAW" ]]; then
        echo "Game ended in a Draw. No winner."
    else
        echo "No game played yet. Choose option 2 first."
    fi

    log "feature_3 used"
}

# ------------------------------------------------------------
# feature 4: Detect a draw
# Commands you can use: arrays, nested loops, functions, case, awk
# ------------------------------------------------------------

feature_4() {
    echo "== Detect a draw =="

    if [[ "$LAST_RESULT" == "DRAW" ]]; then
        echo "Game is a Draw!"
    elif [[ "$LAST_RESULT" == "X" || "$LAST_RESULT" == "O" ]]; then
        echo "Player $LAST_RESULT won. It is not a draw."
    else
        echo "No game played yet. Choose option 2 first."
    fi

    log "feature_4 used"
}

check_winner() {
    local b=("$@")

    # Check rows
    for ((i=0; i<9; i+=3)); do
        if [[ "${b[$i]}" == "${b[$((i+1))]}" &&
              "${b[$i]}" == "${b[$((i+2))]}" &&
              ( "${b[$i]}" == "X" || "${b[$i]}" == "O" ) ]]; then
            echo "${b[$i]}"
            return
        fi
    done

    # Check columns
    for ((i=0; i<3; i++)); do
        if [[ "${b[$i]}" == "${b[$((i+3))]}" &&
              "${b[$i]}" == "${b[$((i+6))]}" &&
              ( "${b[$i]}" == "X" || "${b[$i]}" == "O" ) ]]; then
            echo "${b[$i]}"
            return
        fi
    done

    # Check diagonals
    if [[ "${b[0]}" == "${b[4]}" &&
          "${b[0]}" == "${b[8]}" &&
          ( "${b[0]}" == "X" || "${b[0]}" == "O" ) ]]; then
        echo "${b[0]}"
        return
    fi

    if [[ "${b[2]}" == "${b[4]}" &&
          "${b[2]}" == "${b[6]}" &&
          ( "${b[2]}" == "X" || "${b[2]}" == "O" ) ]]; then
        echo "${b[2]}"
        return
    fi

    echo "NONE"
}

# ------------------------------------------------------------
# FEATURE 5: Save results and show win counts per player
# Commands you can use: arrays, nested loops, functions, case, awk
# ------------------------------------------------------------

feature_5() {
    echo "== Save results and show win counts =="

    if [[ -z "$LAST_RESULT" ]]; then
        echo "Please play a game using Option 2 first."
        return
    fi

    read -p "Enter first player name (X): " player1
    read -p "Enter second player name (O): " player2

    if [[ "$LAST_RESULT" == "X" ]]; then
        winner="$player1"
        echo "Winner: $player1 (Player X)"
    elif [[ "$LAST_RESULT" == "O" ]]; then
        winner="$player2"
        echo "Winner: $player2 (Player O)"
    elif [[ "$LAST_RESULT" == "DRAW" ]]; then
        winner="draw"
        echo "Game is a Draw!"
    else
        echo "Invalid game result."
        return
    fi

    mkdir -p data

    if [[ ! -f "$DATA" ]]; then
        echo "date,player1,player2,winner" > "$DATA"
    fi

    echo "$(date +%Y-%m-%d),$player1,$player2,$winner" >> "$DATA"

    echo
    echo "Result saved successfully!"
    echo
    echo "Win counts:"
	awk -F',' -v p1="$player1" -v p2="$player2" '
	    NR > 1 {
        	if (tolower($4) == "draw") {
            	draws++
        	} else if ($4 == p1) {
        	    wins1++
        	} else if ($4 == p2) {
        	    wins2++
        	}
    	}
    	END {
        	print p1 " wins: " wins1+0
        	print p2 " wins: " wins2+0
        	print "Draws: " draws+0
	    }
	' "$DATA"

    log "feature_5 used - Result saved"
}
# ------------------------------------------------------------
# Crontab every Sunday at 9 PM, save the weekly win table to reports/
# Runs when crontab calls:  ./main.sh --cron
# ------------------------------------------------------------

cron_task() {
    report="reports/weekly_report_$(date +%Y%m%d_%H%M%S).txt"

    echo "WEEKLY TIC-TAC-TOE REPORT" > "$report"
    echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')" >> "$report"
    echo "=========================" >> "$report"

    if [ -f "$DATA" ]; then
        awk -F',' '
            NR > 1 {
                if (tolower($4) == "draw")
                    draws++
                else if ($4 != "")
                    wins[$4]++
            }
            END {
                print "Win counts:"
                for (player in wins)
                    print player ": " wins[player]
                print "Draws: " draws+0
            }
        ' "$DATA" >> "$report"
    else
        echo "No results data found." >> "$report"
    fi

    echo "Weekly report saved: $report"
    log "weekly report created $report"
}
