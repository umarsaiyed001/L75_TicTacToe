# L75 – Tic-Tac-Toe CLI

**Student:** MOHAMMAD UMAR SAIYED | **Roll:** F39 | **Division:** G | **Enrollment:** 24004501210377

## Problem
Build a two-player tic-tac-toe game with a board array, winner check and match history.

## Who will use it
Friends who want a quick game in the lab.

## Folder structure
- main.sh – menu (run with ./main.sh)
- lib/functions.sh – all functions
- data/ – data files
- reports/ – reports created by the script
- backups/ – tar.gz backups
- logs/ – activity.log and cron.log


## Features
1. Draw the 3×3 board from an array
2. Take moves and reject filled cells
3. Check rows, columns and diagonals for a winner
4. Detect a draw
5. Save results and show win counts per player
6. View saved match data
7. Create compressed data backups using tar.gz
8. View the activity log
9. Generate weekly reports using Crontab

## How to run
    cd ~/linux_project/tictactoe
    ./main.sh
    ./main.sh --help

## Crontab task
Every Sunday at 9 PM, save the weekly win table to reports/

    0 21 * * 0 /home/umar/linux_project/tictactoe/main.sh --cron

## Commands used
arrays, nested loops, functions, case, awk

## What I learned

- Learned to create and display a 3×3 Tic-Tac-Toe board using Bash arrays and loops.
- Used functions to check winners across rows, columns and diagonals.
- Practiced input validation and rejecting already-filled cells.
- Saved match results in a CSV file and calculated win counts using `awk`.
- Created compressed backups using `tar.gz` and maintained activity logs.
- Scheduled automatic weekly reports using Crontab.

cat README.md
ls -R ~/linux_project/tictactoe
