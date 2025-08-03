#!/bin/sh
set -eu

NOTIFICATION_TITLE="Clipboard Contents Changed"

send_notification() {
  content="$1"
  notify-send --transient "$NOTIFICATION_TITLE" "$content"
}

previous_content=""

while true; do
  current_content=$(wl-paste || printf "")

  if [ "$current_content" != "$previous_content" ]; then
    if [ -n "$current_content" ]; then
      #send_notification "$current_content"
      send_notification ""
      previous_content=$current_content
    fi
  fi

  sleep 0.25
done
