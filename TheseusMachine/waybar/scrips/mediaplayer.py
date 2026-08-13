#!/usr/bin/env python3
import json, subprocess, sys, time

PLAYER = sys.argv[1] if len(sys.argv) > 1 else "spotify"

def run(cmd):
    try:
        return subprocess.run(cmd, capture_output=True, text=True, timeout=2).stdout.strip()
    except Exception:
        return ""

def emit():
    status = run(["playerctl", "-p", PLAYER, "status"])
    if not status:
        print(json.dumps({"text": "stopped", "class": "stopped", "alt": "stopped"}), flush=True)
        return
    artist = run(["playerctl", "-p", PLAYER, "metadata", "artist"])
    title = run(["playerctl", "-p", PLAYER, "metadata", "title"])
    text = f"{artist} - {title}" if artist else title
    state = status.lower()
    print(json.dumps({"text": state, "class": state, "alt": state, "tooltip": text}), flush=True)

emit()  # estado inicial ao iniciar

while True:
    proc = subprocess.Popen(
        ["playerctl", "-p", PLAYER, "--follow", "status"],
        stdout=subprocess.PIPE, text=True
    )
    for _ in proc.stdout:
        emit()  # dispara só quando o D-Bus avisa mudança
    # playerctl saiu (player fechou) — espera e tenta reconectar
    emit()
    time.sleep(2)
