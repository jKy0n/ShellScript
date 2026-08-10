#!/usr/bin/env python3
import json
import subprocess

PLAYER = "spotify"

def run(cmd):
    try:
        out = subprocess.run(cmd, capture_output=True, text=True, timeout=2)
        return out.stdout.strip()
    except Exception:
        return ""

status = run(["playerctl", "-p", PLAYER, "status"])

if not status:
    print(json.dumps({"text": "", "class": "stopped", "alt": "stopped"}))
else:
    artist = run(["playerctl", "-p", PLAYER, "metadata", "artist"])
    title = run(["playerctl", "-p", PLAYER, "metadata", "title"])
    text = f"{artist} - {title}" if artist else title
    state = status.lower()  # "playing" ou "paused"
    print(json.dumps({
        "text": state,
        "class": state,
        "alt": state,
        "tooltip": text
    }))