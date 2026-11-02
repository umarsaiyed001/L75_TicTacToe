#!/bin/bash
# main.sh – L75 Tic-Tac-Toe CLI
# Menu-driven shell script (while loop + case)
cd "$(dirname "$0")" || exit 1
source lib/functions.sh
LAST_RESULT=""

case "$1" in
    --help)   show_help; exit 0 ;;
    --backup) do_backup; exit 0 ;;
    --cron)   cron_task; exit 0 ;;
esac

while true; do
    echo
    echo '========== TIC-TAC-TOE CLI =========='
    echo '1) Draw the 3×3 board from an array'
    echo '2) Take moves and reject filled cells'
    echo '3) Check rows, columns and diagonals for a winner (function)'
    echo '4) Detect a draw'
    echo '5) Save results and show win counts per player'
    echo "6) View data"
    echo "7) Backup data (tar.gz)"
    echo "8) View activity log"
    echo "0) Exit"
    read -p "Choose an option: " ch
    case "$ch" in
        1) feature_1 ;;
        2) feature_2 ;;
        3) feature_3 ;;
        4) feature_4 ;;
        5) feature_5 ;;
        6) view_data ;;
        7) do_backup ;;
        8) view_log ;;
        0) echo "Bye!"; break ;;
        *) echo "Invalid choice, try again." ;;
    esac
done
