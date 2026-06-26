# Ephedrine
Just another caffeine-like tool to block suspend.
Based in systemd-inhibit and a bit KISS/UNIX philosophy.

## Commands

|       commands      |                 description                 |
|--------------------:|:--------------------------------------------|
| `ephedrine help`    | show help and commands list                 |
| `ephedrine version` | print current version                       |
| `ephedrine status`  | show if is active or deactivate             |
| `ephedrine on`      | turn ephedrine on (suspend blocked)         |
| `ephedrine off`     | turn ephedrine off (suspend rules normally) |


## Heart of the project
it's, simple

**Active:**
``` bash
systemd-run --user --unit="ephedrine-lock" \
        --description="Manual block suspension" \
        systemd-inhibit --what=sleep --why="ephedrine manual" --mode=block sleep infinity
```

**Deactive:**
``` bash
systemctl --user stop "ephedrine-lock"
```
---

## awesome (window manager)

description soon ⏳

---
### Autory:
---
Developed with 🖤 by John Kennedy a.k.a. **jKyon**