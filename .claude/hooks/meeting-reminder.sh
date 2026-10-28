#!/usr/bin/env bash
# Meeting reminder hook.
#   SessionStart     -> records when the session began.
#   UserPromptSubmit -> once the session is more than 10s old, shows the
#                       reminder to the user (a single time per session).
set -euo pipefail

DELAY_SECS=10
MESSAGE="Reminder: IT project management meeting next Wednesday at 10:00 AM in Room 123."

input=$(cat)
event=$(jq -r '.hook_event_name' <<<"$input")
session=$(jq -r '.session_id' <<<"$input")
state_dir="${TMPDIR:-/tmp}/meeting-reminder"
start_file="$state_dir/$session.start"
shown_file="$state_dir/$session.shown"
mkdir -p "$state_dir"

case "$event" in
  SessionStart)
    date +%s >"$start_file"
    ;;
  UserPromptSubmit)
    [ -f "$shown_file" ] && exit 0
    start=$(cat "$start_file" 2>/dev/null || date +%s)
    if [ $(( $(date +%s) - start )) -gt "$DELAY_SECS" ]; then
      touch "$shown_file"
      jq -n --arg m "$MESSAGE" '{systemMessage: $m, hookSpecificOutput: {hookEventName: "UserPromptSubmit", additionalContext: ("Tell the user briefly: " + $m)}}'
    fi
    ;;
esac
