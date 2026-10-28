#!/usr/bin/env bash
# Meeting reminder hook (SessionStart).
# Spawns a detached background process that waits 10 seconds and then shows a
# desktop dialog. Uses osascript (macOS), zenity/kdialog (Linux) or PowerShell
# (Windows / WSL / Git Bash), whichever is available.

DELAY_SECS=10
TITLE="IT Project Management Meeting"
MESSAGE="IT project management meeting next Wednesday at 10:00 AM in Room 123."

popup() {
  if command -v osascript >/dev/null 2>&1; then
    osascript -e "display dialog \"$MESSAGE\" with title \"$TITLE\" buttons {\"OK\"} default button \"OK\" with icon note"
  elif command -v zenity >/dev/null 2>&1; then
    zenity --info --title="$TITLE" --text="$MESSAGE"
  elif command -v kdialog >/dev/null 2>&1; then
    kdialog --title "$TITLE" --msgbox "$MESSAGE"
  elif command -v powershell.exe >/dev/null 2>&1; then
    powershell.exe -NoProfile -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('$MESSAGE','$TITLE') | Out-Null"
  elif command -v notify-send >/dev/null 2>&1; then
    notify-send "$TITLE" "$MESSAGE"
  fi
}

# Detach fully so Claude Code doesn't wait on the hook.
( sleep "$DELAY_SECS"; popup ) </dev/null >/dev/null 2>&1 &
disown
exit 0
