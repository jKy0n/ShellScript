# 🐚 ShellScript 📜

Thats is my scripts collection. (Description below 👇 soon)

![Scripts preview](https://github.com/jKy0n/ShellScript/blob/main/.media/screenshot-2025-06-30.png)


## Scripts List

```
tree ~/ShellScript/

/home/jkyon/ShellScript/
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
│   │   ├── CPU-temp-monitor.sh
│   │   ├── CPU-usage-monitor.sh
│   │   ├── GPU-freq-monitor.sh
│   │   ├── GPU-temp-monitor.sh
│   │   ├── GPU-usage-monitor.sh
│   │   ├── PSU-temp-monitor.sh
│   │   ├── PSU-usage-monitor.sh
│   │   └── RAM-usage-monitor.sh
│   ├── etc-dotfiles.sh
│   ├── startUpApps-TheseusMachine-with-nice.sh
│   ├── startUpApps-TheseusMachine.sh
│   ├── systemd
│   │   ├── PortageSync
│   │   │   ├── systemd-mirrorselect-update.sh
│   │   │   ├── systemd-notify-PortageSync-finish.sh
│   │   │   └── systemd-notify-PortageSync-start.sh
│   │   ├── etc-dotfiles.service
│   │   └── etc-dotfiles.timer
│   └── tmux-quickstart.sh
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
│   │   ├── CPU-temp-monitor.sh
│   │   ├── CPU-usage-monitor.sh
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
│   └── systemd
│       ├── chromadb.service
│       ├── gpt4all.service
│       ├── jkyon-borg-backup.service
│       ├── jkyon-borg-backup.timer
│       ├── jkyon-smart-cleanup.service
│       ├── jkyon-smart-cleanup.timer
│       ├── picom.service
│       ├── restart-picom-if-high-mem.service
│       ├── restart-picom-if-high-mem.timer
│       ├── root-level
│       │   ├── pacman-cache-update.service
│       │   └── pacman-cache-update.timer
│       └── xss-lock.service
├── aliases.sh
├── awesome-WM-widgets
│   ├── DoNotDisturb_widget.lua
│   ├── internet_widget.lua
│   ├── paru_update_checker.lua
│   └── portage_update_checker.lua
├── awesome-startUp.lua
├── borg_backup-hourlyRoutine.sh
├── btrfs-scripts
│   ├── btrfs-slow-balance-home.sh
│   ├── btrfs-slow-balance-timeshift.sh
│   ├── btrfs-slow-balance.sh
│   └── filesystem-show-script.sh
├── fastfetch-scripts
│   ├── fastfetch-MoBo-info.sh
│   ├── fastfetch-btrfs+bees-version.sh
│   └── fastfetch-zsh+tmux-version.sh
├── gentoo-sync.sh
├── lockScreen.sh
├── satisfactory-server-update.sh
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
└── theseusMachine-core-etc-sync.sh

28 directories, 145 files
```

<!-- <details>
    <summary>AI-Scripts</summary>
        <ul>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/AI-Scripts/AI-Shell-SystemInformation.sh">AI-Shell-SystemInformation.sh</a>: Script to make AI better response system info.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/AI-Scripts/deepShell.sh">deepShell.sh</a>: Script to interact with Ollama and format the output.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/AI-Scripts/ollama-pretty.sh">ollama-pretty.sh</a>: makes AI output more pretty. (ex. using glow)</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/AI-Scripts/ollama-read-meta.sh">ollama-read-meta.sh</a>: Allow AI to read metadata and bring more details.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/AI-Scripts/ollama-read.sh">ollama-read.sh</a>: Allow AI to read some data and bring more details.</li>
        </ul>
</details>
<details>
    <summary>awesome-WM-widgets</summary>
        <ul>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/awesome-WM-widgets/DoNotDisturb_widget.lua">DoNotDisturb_widget.lua</a>: widget to stop/disable notifications (naughty awesome module).</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/awesome-WM-widgets/internet_widget.lua">internet_widget.lua</a>: widget to check internet status and show on the wibar if down.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/awesome-WM-widgets/paru_update_checker.lua">paru_update_checker.lua</a>: widget uses "paru -Qu" every hour to check for new updates.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/awesome-WM-widgets/portage_update_checker.lua">portage_update_checker.lua</a>: widget uses "emerge -pvuND @world" every hour to check for new updates. </li>
        </ul>
</details>
<details>
    <summary>BtrFS-Script</summary>
        <ul>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/btrfs-scripts/btrfs-slow-balance-home.sh">btrfs-slow-balance-home.sh</a>: (do NOT use) Worst way to balance a volume.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/btrfs-scripts/btrfs-slow-balance-timeshift.sh">btrfs-slow-balance-timeshift.sh</a>: (do NOT use) Worst way to balance a volume.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/btrfs-scripts/btrfs-slow-balance.sh">btrfs-slow-balance.sh</a>: (do NOT use) Worst way to balance a volume.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/btrfs-scripts/filesystem-show-script.sh">Filesystem-show-script.sh</a>: For better view filesystem at all.</li>
        </ul>
</details>
<details>
    <summary>CrisNote: A ArchLinux Laptop</summary>
        <ul>
            <details>
                <summary>StatusBar-Script</summary>
                    <ul>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/CrisNote/StatusBar-Scripts/battery-widget.sh">battery-widget.sh</a>: StatusBar script to extract battery level</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/CrisNote/StatusBar-Scripts/CPU-freq-monitor.sh">CPU-freq-monitor.sh</a>: StatusBar script to extract CPU frequency in GHz</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/CrisNote/StatusBar-Scripts/CPU-temp-monitor.sh">CPU-temp-monitor.sh</a>: StatusBar script to extract CPU temperature in ºC</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/CrisNote/StatusBar-Scripts/CPU-usage-monitor.sh">CPU-usage-monitor.sh</a>: StatusBar script to extract CPU usage in %</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/CrisNote/StatusBar-Scripts/RAM-usage-monitor.sh">RAM-usage-monitor.sh</a>: StatusBar script to extract RAM usage in %</li>
                    </ul>
            </details>
            <details>
                <summary>StatusBar-Script.old</summary>
                    <ul>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/CrisNote/StatusBar-Scripts.old/crisNoteBatteryLevel">crisNoteBatteryLevel</a>: StatusBar script to extract battery level</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/CrisNote/StatusBar-Scripts.old/crisNoteCpuTemp">crisNoteCpuTemp</a>: (old) StatusBar script to extract CPU temperature in ºC</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/CrisNote/StatusBar-Scripts.old/CrisNoteCPUtemp.sh">CrisNoteCPUtemp.sh</a>: StatusBar script to extract CPU temperature in ºC</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/CrisNote/StatusBar-Scripts.old/CrisNotoBatteryCapacity.sh">CrisNotoBatteryCapacity.sh</a>: StatusBar script to extract battery level</li>
                    </ul>
            </details>
                <li><a href="https://github.com/jKy0n/ShellScript/blob/main/CrisNote/startUpApps-CrisNote.sh">startUpApps-CrisNote</a>: Script to autostart apps on CrisNote.</li>
        </ul>
</details>
<details>
    <summary>fastfetch-scripts</summary>
        <ul>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/fastfetch-scripts/fastfetch-MoBo-info.sh">fastfetch-MoBo-info.sh</a>: Extract only MoBo info necessary</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/fastfetch-scripts/fastfetch-btrfs%2Bbees-version.sh">fastfetch-btrfs+bees-version.sh</a>: Extract btrfs and bees version at same time</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/fastfetch-scripts/fastfetch-zsh%2Btmux-version.sh">fastfetch-zsh+tmux-version.sh</a>: Extract zsh and tmux version at same time</li>
        </ul>
</details>
<details>
    <summary>Old-unused-Script</summary>
        <ul>
            <li><a href= "https://github.com/jKy0n/ShellScript/blob/main/Old-unused-Scripts/awesome-notify-test.sh">awesome-notify-test.sh</a>: Just a test for awesomeWM notifications.</li>
            <li><a href= "https://github.com/jKy0n/ShellScript/blob/main/Old-unused-Scripts/backInTime-gpgKeys-backup.sh">backInTime-gpgKeys-backup.sh</a>: Automation for encryptation GPG keys.</li>
            <li><a href= "https://github.com/jKy0n/ShellScript/blob/main/Old-unused-Scripts/feh_custom">feh_custom</a>: Script to fix feh (app) window size.</li>
            <li><a href= "https://github.com/jKy0n/ShellScript/blob/main/Old-unused-Scripts/gentoo-addUSEpackage.sh">gentoo-addUSEpackage.sh</a>: (won't work) Script to add package and flags to portage use packages.</li>
            <li><a href= "https://github.com/jKy0n/ShellScript/blob/main/Old-unused-Scripts/gentoo-update.sh">gentoo-update.sh</a>: Fast way to update portage - substitute by better systemd automation.</li>
            <li><a href= "https://github.com/jKy0n/ShellScript/blob/main/Old-unused-Scripts/jkyon-scrub.sh">jkyon-scrub.sh</a>: scrub all my disks at same time, or close to this.</li>
            <li><a href= "https://github.com/jKy0n/ShellScript/blob/main/Old-unused-Scripts/kdeConnect-refresh.sh">kdeConnect-refresh.sh</a>: script to refesh KDEconnect - not needed anymore.</li>
            <li><a href= "https://github.com/jKy0n/ShellScript/blob/main/Old-unused-Scripts/mycompsize.sh">mycompsize.sh</a>: Script to emule compsize app, but worse.</li>
            <li><a href= "https://github.com/jKy0n/ShellScript/blob/main/Old-unused-Scripts/myfetch.sh">myfetch.sh</a>: When I used neofech and not have (don't know how) storage support.</li>
            <li><a href= "https://github.com/jKy0n/ShellScript/blob/main/Old-unused-Scripts/notification-test.sh">notification-test.sh</a>: Just a script to test libnnotify.</li>
            <li><a href= "https://github.com/jKy0n/ShellScript/blob/main/Old-unused-Scripts/snapShotsPreview.sh">snapShotsPreview.sh</a>: Script to view btrfs snapshots disk usage.</li>
        </ul>
</details>
<details>
    <summary>StatusBar-Script.old</summary>
        <ul>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/awesomeWidget-CPU-freq-monitor.sh">awesomeWidget-CPU-freq-monitor.sh</a>: Extract CPU frequency in MHz to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/awesomeWidget-gpu0freq.sh">awesomeWidget-gpu0freq.sh</a>: Extract GPU0 frequency in MHz to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/awesomeWidget-gpu0temp.sh">awesomeWidget-gpu0temp.sh</a>: Extract GPU0 temperature in ºC to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/awesomeWidget-gpu0usage-fast.sh">awesomeWidget-gpu0usage-fast.sh</a>: Fast way to extract GPU0 usage in % to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/awesomeWidget-gpu1freq.sh">awesomeWidget-gpu1freq.sh</a>: Extract GPU1 frequency in MHz to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/awesomeWidget-gpu1temp.sh">awesomeWidget-gpu1temp.sh</a>: Extract GPU1 temperature in ºC to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/awesomeWidget-PSU-monitor.sh">awesomeWidget-PSU-monitor.sh</a>: Extract PSU power in W to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/awesomeWidget-PSU-temp-monitor.sh">awesomeWidget-PSU-temp-monitor.sh</a>: Extract PSU VRM temperature in ºC to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/awesomeWidget-trackingAwesomeMemoryUse.sh">awesomeWidget-trackingAwesomeMemoryUse</a>: Extract amount of awesomeWM memory in GB to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/dwmBlocksCpuTemp">dwmBlocksCpuTemp</a>: Extract CPU temperature in ºC to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/dwmBlocksCpuUsage">dwmBlocksCpuUsage</a>: Extract CPU usage in % to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/dwmBlocksMemUsage">dwmBlocksMemUsage</a>: Extract RAM usage in % to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/dwmBlocksNice">dwmBlocksNice</a>: Extract Nice number to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/dwmBlocksUpdates">dwmBlocksUpdates</a>: Extract numeber of portage packages to update to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/dwmBlocksVolumeAudio">dwmBlocksVolumeAudio</a>: Extract Volume level from pactl to statusBar.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/StatusBar-Scripts.old/memoryUsage-widget.sh">memoryUsage-widget.sh</a>: Another way to extract RAM usage in GB to statusBar.</li>
        </ul>
</details>
<details>
    <summary>systemd</summary>
        <ul>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/backInTime-gpgKeys-Backup.service">backInTime-gpgKeys-Backup.service</a>: systemd service to encrypt GPG keys before backup.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/backInTime-gpgKeys-Backup.timer">backInTime-gpgKeys-Backup.timer</a>: systemd timer to encrypt GPG keys before backup.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/backintime-backup-job.service"> backintime-backup-job.service</a>: systemd service for BackInTime backup job.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/backintime-backup-job.timer"> backintime-backup-job.timer</a>: systemd timer for BackInTime backup job.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/borgBackup-jkyon.service"> borgBackup-jkyon.service</a>: systemd service for Borg backup job. (my actual backup service)</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/borgBackup-jkyon.timer"> borgBackup-jkyon.timer</a>: systemd timer for Borg backup job. (my actual backup service)</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/gpt4all.service"> gpt4all.service</a>: Just a service to limit GPT4all resources using systemd.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/jkyon-picom-memoryUsageMonitor.service"> jkyon-picom-memoryUsageMonitor.service</a>: Service to monitoring memory usage of picom (compositor).</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/jkyon-picom-memoryUsageMonitor.timer"> jkyon-picom-memoryUsageMonitor.timer</a>: Timer from monitoring memory usage of picom (compositor).</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/jkyon-picom.service"> jkyon-picom.service</a>: Service to restart picom (compositor) service.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/jkyon-systemd-PortageRsyncDotfiles.service"> jkyon-systemd-PortageRsyncDotfiles.service</a>: Service to do rsync from /etc to ~/.theseusMachine-core </li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/jkyon-systemd-PortageRsyncDotfiles.timer"> jkyon-systemd-PortageRsyncDotfiles.timer</a>: Timer to do rsync from /etc to ~/.theseusMachine-core</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/jkyon-systemd-notify-test.service"> jkyon-systemd-notify-test.service</a>: Just a service to test libnotify (notifications).</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/jkyon-systemd-notify-test.timer"> jkyon-systemd-notify-test.timer</a>: Just a service (timer) to test libnotify (notifications).</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/lockScreen.service"> lockScreen.service</a>: A service to call <a href ="https://github.com/jKy0n/ShellScript/blob/main/lockScreen.sh"> lockScreen.sh</a>. </li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/pipewire-reset.service"> pipewire-reset.service</a>: Service to restart pipewire after hours to avoid odd noises.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/pipewire-reset.timer"> pipewire-reset.timer</a>: Service (timer) to restart pipewire after hours to avoid odd noises.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/pipewire-session-manager.service"> pipewire-session-manager.service</a>: Service to start pipewire and wireplumber with user/system.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd/polkit-gnome-authentication-agent.service"> polkit-gnome-authentication-agent.service</a>: Service to start Gnome Polkit with user or system. </li>
        </ul>
</details>
<details>
    <summary>TheseusMachine: my beloved PC</summary>
        <ul>
            <details>
                <summary>StatusBar-Scripts</summary>
                    <ul>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/TheseusMachine/StatusBar-Scripts/CPU-freq-monitor.sh">CPU-freq-monitor.sh</a>: Better way to extract CPU frequency in GHz to statusBar.</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/TheseusMachine/StatusBar-Scripts/CPU-temp-monitor.sh">CPU-temp-monitor.sh</a>: Better way to extract CPU temperature in ºC to statusBar.</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/TheseusMachine/StatusBar-Scripts/CPU-usage-monitor.sh">CPU-usage-monitor.sh</a>: Better way to extract CPU usage in % to statusBar.</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/TheseusMachine/StatusBar-Scripts/GPU-freq-monitor.sh">GPU-freq-monitor.sh</a>: Better way to extract GPU frequency in MHz to statusBar.</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/TheseusMachine/StatusBar-Scripts/GPU-temp-monitor.sh">GPU-temp-monitor.sh</a>: Better way to extract GPU temperature in ºC to statusBar.</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/TheseusMachine/StatusBar-Scripts/GPU-usage-monitor.sh">GPU-usage-monitor.sh</a>: Better way to extract GPU usage in % to statusBar.</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/TheseusMachine/StatusBar-Scripts/PSU-temp-monitor.sh">PSU-temp-monitor.sh</a>: Script to extract PSU VRM temperature in ºC to statusBar.</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/TheseusMachine/StatusBar-Scripts/RAM-usage-monitor.sh">RAM-usage-monitor.sh</a>: Better way to extract RAM usage in % to statusBar.</li>
                    </ul>
            </details>
                <li><a href="https://github.com/jKy0n/ShellScript/blob/main/TheseusMachine/startUpApps-TheseusMachine.sh"> startUpApps-TheseusMachine.sh</a>: Script to autostart apps on TheseusMachine. </li>
                <li><a href="https://github.com/jKy0n/ShellScript/blob/main/TheseusMachine/tmux-quickstart.sh"> tmux-quickstart.sh</a>: Script to start tmux with panels pre-config . </li>
        </ul>
</details>
<details>
    <summary>Tools</summary>
        <ul>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Tools/OpenSeeFace.sh">OpenSeeFace.sh</a>: OpenSeeFace automation script.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Tools/ananicy-exclude.sh">ananicy-exclude.sh</a>: Script to quick add exclude program on Ananicy.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Tools/avisoNoTerminal.sh">avisoNoTerminal.sh</a>: This script alert when a command finished</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Tools/gentoo-unmaskPackage.sh">gentoo-unmaskPackage.sh</a>: Quick add a package on Portage umaskpackes list </li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Tools/ls-font-char.sh">ls-font-char.sh</a>: List system fonts available.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Tools/picom-restartRoutine.sh">picom-restartRoutine.sh</a>: Script to restart Picom when memory limit (defined) overflows.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Tools/pipewire-restart.sh">pipewire-restart.sh</a>: Script to restart Pipewire and Wireplumber to avoid odd noises</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Tools/watch19.sh">watch19.sh</a>: Script to monitoring (watch) with low impact and diferences highlighted.</li>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Tools/xclip-output-to-clipboard.sh">xclip-output-to-clipboard.sh</a>: Super handy script made to copy output from a command, good for log analysis with AI. </li>
        </ul>
</details>
<details>
    <summary>Viamar-PC</summary>
        <ul>
            <details>
                <summary>Scripts</summary>
                    <ul>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Viamar-PC/Scripts/fastfetch-align-box.py">fastfetch-align-box.py</a>: (DON'T WORK) Script to generate a fastfetch config with textbox.</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Viamar-PC/Scripts/jkyon-borg-backup_hourly.sh">jkyon-borg-backup_hourly.sh</a>: Script to do a backup hourly with Borg.</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Viamar-PC/Scripts/screen-lock.sh">screen-lock.sh</a>: (DON'T WORK PROPERLY) script use light-locker to lock session on screensaver.</li>
                    </ul>
            </details>
            <details>
                <summary>StatusBar-Scripts</summary>
                    <ul>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Viamar-PC/StatusBar-Scripts/CPU-freq-monitor.sh">CPU-freq-monitor.sh</a>: Better way to extract CPU frequency in GHz to statusBar.</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Viamar-PC/StatusBar-Scripts/CPU-temp-monitor.sh">CPU-temp-monitor.sh</a>: Better way to extract CPU temperature in ºC to statusBar.</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Viamar-PC/StatusBar-Scripts/CPU-usage-monitor.sh">CPU-usage-monitor.sh</a>: Better way to extract CPU usage in % to statusBar.</li>
                        <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Viamar-PC/StatusBar-Scripts/RAM-usage-monitor.sh">RAM-usage-monitor.sh</a>: Better way to extract RAM usage in % to statusBar.</li>
                    </ul>
            </details>
            <details>
                <summary>systemd</summary>
                    <ul>
                        <details>
                            <summary>root-level</summary>
                                <ul>
                                    <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Viamar-PC/systemd/root-level/pacman-cache-update.service">pacman-cache-update.service</a>: Service to update pacman/paru cache, work with: <a href="https://github.com/jKy0n/Viamar-dotfiles/blob/master/.config/awesome/jkyon-widgets/paru_update_checker.lua">paru_update_checker.lua</a>, a awesomeWM widget.</li>
                                    <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Viamar-PC/systemd/root-level/pacman-cache-update.timer">pacman-cache-update.timer</a>: Timer to update pacman/paru cache, work with: <a href="https://github.com/jKy0n/Viamar-dotfiles/blob/master/.config/awesome/jkyon-widgets/paru_update_checker.lua">paru_update_checker.lua</a>, a awesomeWM widget..</li>
                                </ul>
                        </details>
                            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Viamar-PC/systemd/gpt4all.service">gpt4all.service</a>: Just a systemd service to limit resources for GPT4All.</li>
                            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Viamar-PC/systemd/jkyon-borg-backup.service">jkyon-borg-backup.service</a>: systemd service for Borg backup job. (my actual backup service)</li>
                            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Viamar-PC/systemd/jkyon-borg-backup.timer">jkyon-borg-backup.timer</a>: systemd timer for Borg backup job. (my actual backup service)</li>
                    </ul>
            </details>
            <li><a href="https://github.com/jKy0n/ShellScript/blob/main/Viamar-PC/startUpApps-Viamar-PC.sh">startUpApps-Viamar-PC.sh</a>: Script to autostart apps on Viamar-PC.</li>
        </ul>
</details>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/PortageDailyAutomation.sh">PortageDailyAutomation.sh</a>:Daily portage automation, show packages to update with <a href="https://github.com/jKy0n/TheseusMachine-dotfiles/blob/main/.config/awesome/jkyon-widgets/portage_update_checker.lua">portage_update_checker.lua</a>.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/PortageRsyncDotfiles.sh">PortageRsyncDotfiles.sh</a>: OLD script to automate .dotfiles.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/PortageSync.sh">PortageSync.sh</a>: OLD script to automate Portage synchronization.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/PortageUpdateMirrors.sh">PortageUpdateMirrors.sh</a>: Automation for MirrorSelect Portage.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/aliases.sh">aliases.sh</a>: My collection of aliases to use with zsh.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/awesome-startUp.lua">awesome-startUp.lua</a>: (NOT WORKING) Attempting to create a startUp Script for AwesomeWM</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/borg_backup-hourlyRoutine.sh">borg_backup-hourlyRoutine.sh</a>: Automation for Borg backup, work with systemd or Cron.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/gentoo-sync.sh">gentoo-sync.sh</a>:NEW script to automate Portage synchronization.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/lockScreen.sh">lockScreen.sh</a>: Activate light-locker to lock screen.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/satisfactory-server-update.sh">satisfactory-server-update.sh</a>: Automation to update and start Satisfactory game server.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/shellScript-header.sh">shellScript-header.sh</a>: Just a header for Shell Script.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/startUpApps.sh">startUpApps.sh</a>: Script to detect and autostart apps on a PC.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd-PortageRsyncDotfiles.sh">systemd-PortageRsyncDotfiles.sh</a>: New script automate /etc .dotfiles.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd-mirrorselect-update.sh">systemd-mirrorselect-update.sh</a> Script to refresh MirrorSelect.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd-notify-PortageSync-finish.sh">systemd-notify-PortageSync-finish.sh</a>: Script to libnotify when finish a sync automation.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd-notify-PortageSync-start.sh">systemd-notify-PortageSync-start.sh</a>: Script to libnotify when start a sync automation.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/systemd-picom-memoryMonitor.sh">systemd-picom-memoryMonitor.sh</a>: Script to monitor RAM usage and restart picom when defined overflow.</li>
<li><a href="https://github.com/jKy0n/ShellScript/blob/main/theseusMachine-core-etc-sync.sh">theseusMachine-core-etc-sync.sh</a> Script to rsync full /etc to ~/.TheseusMachine-core </li> -->
