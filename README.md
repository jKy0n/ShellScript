# 🐚 ShellScript 📜

Thats is my scripts collection. (Description below 👇 soon)

![Scripts preview](https://github.com/jKy0n/ShellScript/blob/main/.media/screenshot-2026-06-26.png)


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
├── aliases.sh
├── awesome-WM-widgets
│   ├── DoNotDisturb_widget.lua
│   ├── internet_widget.lua
│   ├── paru_update_checker.lua
│   └── portage_update_checker.lua
├── builder-arch
│   └── fastfetch
│       └── ffetch-builder-arch.jsonc
├── CrisNote
│   ├── scripts
│   │   └── upgrade-kernel-arch
│   │       └── upgrade-kernel-arch.sh
│   ├── startUpApps-CrisNote.sh
│   ├── StatusBar-Scripts
│   │   ├── battery-widget.sh
│   │   ├── CPU-freq-monitor.sh
│   │   ├── CPU-monitor.sh
│   │   ├── CPU-temp-monitor.sh
│   │   ├── CPU-usage-monitor.sh
│   │   ├── RAM-monitor.sh
│   │   └── RAM-usage-monitor.sh
│   ├── StatusBar-Scripts.old
│   │   ├── crisNoteBatteryLevel
│   │   ├── crisNoteCpuTemp
│   │   ├── CrisNoteCPUtemp.sh
│   │   └── CrisNotoBatteryCapacity.sh
│   └── tools
│       └── wake-theseusmachine
│           └── wake-theseusmachine.sh
├── Debian
│   └── tools
│       ├── update-apt.sh
│       └── upgrade-apt.sh
├── fastfetch-scripts
│   ├── fastfetch-awesome-version.sh
│   ├── fastfetch-btrfs+bees-version-pacman.sh
│   ├── fastfetch-btrfs+bees-version-portage.sh
│   ├── fastfetch-btrfs+bees-version.sh
│   ├── fastfetch-MoBo-info.sh
│   ├── fastfetch-packageManager-version.sh
│   ├── fastfetch-sudo+polkit-version.sh
│   └── fastfetch-zsh+tmux-version.sh
├── ffetch.sh
├── Games
│   └── satisfactory-server-update.sh
├── Old-unused-Scripts
│   ├── ananicy-exclude.sh
│   ├── awesome-notify-test.sh
│   ├── backInTime-gpgKeys-backup.sh
│   ├── feh_custom
│   ├── gentoo-addUSEpackage.sh
│   ├── gentoo-sync.sh
│   ├── gentoo-update.sh
│   ├── jkyon-scrub.sh
│   ├── kdeConnect-refresh.sh
│   ├── lockScreen.sh
│   ├── mycompsize.sh
│   ├── myfetch.sh
│   ├── notification-test.sh
│   ├── snapShotsPreview.sh
│   └── StatusBar-Scripts.old
│       ├── awesomeWidget-CPU-freq-monitor.sh
│       ├── awesomeWidget-gpu0freq.sh
│       ├── awesomeWidget-gpu0temp.sh
│       ├── awesomeWidget-gpu0usage-fast.sh
│       ├── awesomeWidget-gpu0usage.sh
│       ├── awesomeWidget-gpu1freq.sh
│       ├── awesomeWidget-gpu1temp.sh
│       ├── awesomeWidget-PSU-monitor.sh
│       ├── awesomeWidget-PSU-temp-monitor.sh
│       ├── awesomeWidget-trackingAwesomeMemoryUse.sh
│       ├── dwmBlocksCpuTemp
│       ├── dwmBlocksCpuUsage
│       ├── dwmBlocksMemUsage
│       ├── dwmBlocksNice
│       ├── dwmBlocksUpdates
│       ├── dwmBlocksVolumeAudio
│       └── memoryUsage-widget.sh
├── poco-c65
│   └── fastfetch
│       └── ffetch-poco-c65.jsonc
├── PortageRsyncDotfiles.sh
├── README.md
├── ssh-test-connection.sh
├── startUpApps.sh
├── systemd
│   ├── backintime-backup-job.service
│   ├── backintime-backup-job.timer
│   ├── backInTime-gpgKeys-Backup.service
│   ├── backInTime-gpgKeys-Backup.timer
│   ├── borgBackup-jkyon.service
│   ├── borgBackup-jkyon.timer
│   ├── gpt4all.service
│   ├── jkyon-picom-memoryUsageMonitor.service
│   ├── jkyon-picom-memoryUsageMonitor.timer
│   ├── jkyon-picom-restartRoutine.service
│   ├── jkyon-picom-restartRoutine.timer
│   ├── jkyon-picom.service
│   ├── jkyon-systemd-notify-send-test.service
│   ├── jkyon-systemd-PortageRsyncDotfiles.service
│   ├── jkyon-systemd-PortageRsyncDotfiles.timer
│   ├── lockScreen.service
│   ├── pipewire-reset.service
│   ├── pipewire-reset.timer
│   ├── pipewire-session-manager.service
│   ├── polkit-gnome-authentication-agent.service
│   └── ShellScripts-git-sync
│       ├── ShellScripts-git-sync.service
│       ├── ShellScripts-git-sync.sh
│       └── ShellScripts-git-sync.timer
├── systemd-picom-memoryMonitor.sh
├── templates
│   └── shellScript-template.sh
├── TheseusMachine
│   ├── etc-dotfiles.sh
│   ├── fastfetch
│   │   ├── ffetch-mini-TheseusMachine.jsonc
│   │   ├── ffetch-ssh-TheseusMachine.jsonc
│   │   └── ffetch-TheseusMachine.jsonc
│   ├── PortageSync.old
│   │   ├── PortageDailyAutomation.sh
│   │   ├── PortageSync.sh
│   │   └── PortageUpdateMirrors.sh
│   ├── portage-tools
│   │   ├── portage-unused-ranker
│   │   │   ├── portage-unused-ranker.sh
│   │   │   └── README.md
│   │   ├── update-portage.sh
│   │   └── upgrade-portage.sh
│   ├── post-backup-snapshot.sh
│   ├── screenshots-scripts
│   │   ├── flameshot-window
│   │   └── main-window-screenshot
│   ├── scripts
│   │   └── auto-idle-suspend
│   │       ├── auto-idle-suspend.sh
│   │       ├── auto-suspend.service
│   │       └── lock-screen.sh
│   ├── startUpApps-TheseusMachine.sh
│   ├── startUpApps-TheseusMachine-with-nice.sh
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
│   ├── systemd
│   │   ├── auto-suspend.service
│   │   ├── etc-dotfiles.service
│   │   ├── etc-dotfiles.timer
│   │   ├── PortageSync
│   │   │   ├── systemd-mirrorselect-update.sh
│   │   │   ├── systemd-notify-PortageSync-finish.sh
│   │   │   └── systemd-notify-PortageSync-start.sh
│   │   ├── rclone-mount-googlephotos.service
│   │   ├── rclone-mount-jkls.service
│   │   └── systemd-monitor
│   │       ├── notify-failed@.service
│   │       ├── systemd-monitor.service
│   │       ├── systemd-monitor.sh
│   │       └── systemd-monitor.timer
│   ├── tmux-quickstart.sh
│   └── tools
│       ├── rambox-cleanup
│       │   └── rambox-cleanup.sh
│       ├── rambox-cleanup.sh
│       └── upgrade-kernel
│           ├── README.md
│           └── upgrade-kernel.sh
├── theseusMachine-core-etc-sync.sh
├── Tools
│   ├── avisoNoTerminal.sh
│   ├── borg_backup-hourlyRoutine.sh
│   ├── bulk-ocr
│   │   ├── bulk-ocr.sh
│   │   └── README.md
│   ├── ephedrine
│   │   ├── ephedrine.sh
│   │   └── README.MD
│   ├── gentoo-unmaskPackage.sh
│   ├── ls-font-char.sh
│   ├── OpenSeeFace.sh
│   ├── picom-restartRoutine.sh
│   ├── pipewire-restart.sh
│   ├── rambox-cleanup
│   │   └── rambox-cleanup.sh
│   ├── rofi-recoll.sh
│   ├── smart-cache-cleanup
│   │   ├── README.md
│   │   └── smart-cache-cleanup.sh
│   ├── watch19.sh
│   └── xclip-output-to-clipboard
│       ├── README.md
│       ├── xclip-output-to-clipboard.sh
│       └── xclip-output-to-clipboard-v1.sh
├── updateDistro.sh
├── upgradeDistro.sh
└── Viamar-PC
    ├── fastfetch
    │   ├── ffetch-mini-viamar-PC.jsonc
    │   └── ffetch-viamar-PC.jsonc
    ├── Scripts
    │   ├── lock-screen
    │   │   ├── lock-screen.sh
    │   │   └── prelock-screenoff.sh
    │   ├── picom-restartRoutine.sh
    │   └── upgrade-kernel-arch
    │       └── upgrade-kernel-arch.sh
    ├── startUpApps-Viamar-PC.sh
    ├── StatusBar-Scripts
    │   ├── cpu_monitor.lua
    │   ├── lib
    │   │   ├── formatters.lua
    │   │   └── monitor.lua
    │   └── ram_monitor.lua
    ├── systemd
    │   ├── borg-ui.service
    │   ├── chromadb.service
    │   ├── gpt4all.service
    │   ├── jkyon-smart-cache-cleanup.service
    │   ├── jkyon-smart-cache-cleanup.timer
    │   ├── picom.service
    │   ├── rclone-mount-jkls.service
    │   ├── restart-picom-if-high-mem.service
    │   ├── restart-picom-if-high-mem.timer
    │   ├── root-level
    │   │   ├── pacman-cache-update.service
    │   │   └── pacman-cache-update.timer
    │   └── xss-lock.service
    ├── updateParu.sh
    └── upgradeParu.sh

53 directories, 194 files
```