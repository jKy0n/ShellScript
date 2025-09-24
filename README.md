# 🐚 ShellScript 📜

Thats is my scripts collection. (Description below 👇 soon)

![Scripts preview](https://github.com/jKy0n/ShellScript/blob/main/.media/screenshot-2025-06-30.png)


## Scripts List

```
tree ~/ShellScript

/home/jkyon/ShellScript
├── AI-Scripts
│   ├── AI-Shell-SystemInformation.sh
│   ├── deepShell.sh
│   ├── ollama-pretty.sh
│   ├── ollama-read-meta.sh
│   └── ollama-read.sh
├── CrisNote
│   ├── StatusBar-Scripts
│   │   ├── CPU-freq-monitor.sh
│   │   ├── CPU-temp-monitor.sh
│   │   ├── CPU-usage-monitor.sh
│   │   ├── RAM-usage-monitor.sh
│   │   └── battery-widget.sh
│   ├── StatusBar-Scripts.old
│   │   ├── CrisNoteCPUtemp.sh
│   │   ├── CrisNotoBatteryCapacity.sh
│   │   ├── crisNoteBatteryLevel
│   │   └── crisNoteCpuTemp
│   └── startUpApps-CrisNote.sh
├── Games
│   └── satisfactory-server-update.sh
├── Old-unused-Scripts
│   ├── awesome-notify-test.sh
│   ├── backInTime-gpgKeys-backup.sh
│   ├── feh_custom
│   ├── gentoo-addUSEpackage.sh
│   ├── gentoo-update.sh
│   ├── jkyon-scrub.sh
│   ├── kdeConnect-refresh.sh
│   ├── mycompsize.sh
│   ├── myfetch.sh
│   ├── notification-test.sh
│   └── snapShotsPreview.sh
├── PortageRsyncDotfiles.sh
├── README.md
├── StatusBar-Scripts.old
│   ├── awesomeWidget-CPU-freq-monitor.sh
│   ├── awesomeWidget-PSU-monitor.sh
│   ├── awesomeWidget-PSU-temp-monitor.sh
│   ├── awesomeWidget-gpu0freq.sh
│   ├── awesomeWidget-gpu0temp.sh
│   ├── awesomeWidget-gpu0usage-fast.sh
│   ├── awesomeWidget-gpu0usage.sh
│   ├── awesomeWidget-gpu1freq.sh
│   ├── awesomeWidget-gpu1temp.sh
│   ├── awesomeWidget-trackingAwesomeMemoryUse.sh
│   ├── dwmBlocksCpuTemp
│   ├── dwmBlocksCpuUsage
│   ├── dwmBlocksMemUsage
│   ├── dwmBlocksNice
│   ├── dwmBlocksUpdates
│   ├── dwmBlocksVolumeAudio
│   └── memoryUsage-widget.sh
├── TheseusMachine
│   ├── PortageSync.old
│   │   ├── PortageDailyAutomation.sh
│   │   ├── PortageSync.sh
│   │   └── PortageUpdateMirrors.sh
│   ├── StatusBar-Scripts
│   │   ├── CPU-freq-monitor.sh
│   │   ├── CPU-monitor.sh
│   │   ├── CPU-temp-monitor.sh
│   │   ├── CPU-usage-monitor.sh
│   │   ├── GPU-freq-monitor.sh
│   │   ├── GPU-monitor.sh
│   │   ├── GPU-temp-monitor.sh
│   │   ├── GPU-usage-monitor.sh
│   │   ├── PSU-monitor.sh
│   │   ├── PSU-temp-monitor.sh
│   │   ├── PSU-usage-monitor.sh
│   │   ├── RAM-monitor.sh
│   │   └── RAM-usage-monitor.sh
│   ├── etc-dotfiles.sh
│   ├── screenshots-scripts
│   │   ├── flameshot-window
│   │   └── main-window-screenshot
│   ├── startUpApps-TheseusMachine-with-nice.sh
│   ├── startUpApps-TheseusMachine.sh
│   ├── systemd
│   │   ├── PortageSync
│   │   │   ├── systemd-mirrorselect-update.sh
│   │   │   ├── systemd-notify-PortageSync-finish.sh
│   │   │   └── systemd-notify-PortageSync-start.sh
│   │   ├── auto-suspend.service
│   │   ├── etc-dotfiles.service
│   │   └── etc-dotfiles.timer
│   ├── tmux-quickstart.sh
│   └── updatePortage.sh
├── Tools
│   ├── OpenSeeFace.sh
│   ├── ananicy-exclude.sh
│   ├── avisoNoTerminal.sh
│   ├── gentoo-unmaskPackage.sh
│   ├── jkyon-smart-cleanup.sh
│   ├── ls-font-char.sh
│   ├── picom-restartRoutine.sh
│   ├── pipewire-restart.sh
│   ├── rofi-recoll.sh
│   ├── watch19.sh
│   └── xclip-output-to-clipboard.sh
├── Viamar-PC
│   ├── Scripts
│   │   ├── fastfetch-align-box.py
│   │   ├── jkyon-borg-backup_hourly.sh
│   │   └── picom-restartRoutine.sh
│   ├── StatusBar-Scripts
│   │   ├── CPU-freq-monitor.sh
│   │   ├── CPU-monitor.sh
│   │   ├── CPU-temp-monitor.sh
│   │   ├── CPU-usage+temp-monitor.sh
│   │   ├── CPU-usage-monitor.sh
│   │   ├── RAM-monitor.sh
│   │   └── RAM-usage-monitor.sh
│   ├── ananicy-rules
│   │   ├── 10-monitoring
│   │   │   ├── btop.rules
│   │   │   └── htop.rules
│   │   ├── 20-backups
│   │   │   ├── borg.rules
│   │   │   └── snapper.rules
│   │   ├── 20-dedupe
│   │   │   └── bees.rules
│   │   ├── 20-indexers
│   │   │   ├── baloo.rules
│   │   │   └── recoll.rules
│   │   ├── 20-messengers
│   │   │   └── rambox.rules
│   │   └── ananicy.conf
│   ├── startUpApps-Viamar-PC.sh
│   ├── systemd
│   │   ├── chromadb.service
│   │   ├── gpt4all.service
│   │   ├── jkyon-borg-backup.service
│   │   ├── jkyon-borg-backup.timer
│   │   ├── jkyon-smart-cleanup.service
│   │   ├── jkyon-smart-cleanup.timer
│   │   ├── picom.service
│   │   ├── restart-picom-if-high-mem.service
│   │   ├── restart-picom-if-high-mem.timer
│   │   ├── root-level
│   │   │   ├── pacman-cache-update.service
│   │   │   └── pacman-cache-update.timer
│   │   └── xss-lock.service
│   └── updateParu.sh
├── aliases.sh
├── awesome-WM-widgets
│   ├── DoNotDisturb_widget.lua
│   ├── internet_widget.lua
│   ├── paru_update_checker.lua
│   └── portage_update_checker.lua
├── awesome-startUp.lua
├── borg_backup-hourlyRoutine.sh
├── fastfetch-scripts
│   ├── fastfetch-MoBo-info.sh
│   ├── fastfetch-awesome-version.sh
│   ├── fastfetch-btrfs+bees-version.sh
│   ├── fastfetch-sudo+polkit-version.sh
│   └── fastfetch-zsh+tmux-version.sh
├── ffetch.sh
├── gentoo-sync.sh
├── lockScreen.sh
├── shellScript-header.sh
├── startUpApps.sh
├── systemd
│   ├── backInTime-gpgKeys-Backup.service
│   ├── backInTime-gpgKeys-Backup.timer
│   ├── backintime-backup-job.service
│   ├── backintime-backup-job.timer
│   ├── borgBackup-jkyon.service
│   ├── borgBackup-jkyon.timer
│   ├── gpt4all.service
│   ├── jkyon-picom-memoryUsageMonitor.service
│   ├── jkyon-picom-memoryUsageMonitor.timer
│   ├── jkyon-picom-restartRoutine.service
│   ├── jkyon-picom-restartRoutine.timer
│   ├── jkyon-picom.service
│   ├── jkyon-systemd-PortageRsyncDotfiles.service
│   ├── jkyon-systemd-PortageRsyncDotfiles.timer
│   ├── jkyon-systemd-notify-send-test.service
│   ├── lockScreen.service
│   ├── pipewire-reset.service
│   ├── pipewire-reset.timer
│   ├── pipewire-session-manager.service
│   └── polkit-gnome-authentication-agent.service
├── systemd-picom-memoryMonitor.sh
├── theseusMachine-core-etc-sync.sh
└── updateDistro.sh

29 directories, 159 files
```