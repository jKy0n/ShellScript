# 🐚 ShellScript 📜

Thats is my scripts collection.

![Scripts preview](https://github.com/jKy0n/ShellScript/blob/main/.media/screenshot-2025-06-30.png)


## Scripts List 

<details>
    <summary>AI-Scripts</summary>
        <ul>
            <li>AI-Shell-SystemInformation.sh: Script to make AI better response system info</li>
            <li>deepShell.sh: Script to interact with Ollama and format the output</li>
            <li>ollama-pretty.sh: makes AI output more pretty (ex. using glow) </li>
            <li>ollama-read-meta.sh: Allow AI to read metadata and bring more details</li>
            <li>ollama-read.sh: Allow AI to read some data and bring more details</li>
        </ul>
</details>
<details>
    <summary>BtrFS-Script</summary>
        <ul>
            <li>btrfs-slow-balance-home.sh: (do NOT use) Worst way to balance a volume</li>
            <li>btrfs-slow-balance-timeshift.sh: (do NOT use) Worst way to balance a volume</li>
            <li>btrfs-slow-balance.sh: (do NOT use) Worst way to balance a volume</li>
            <li>Filesystem-show-script.sh: For better view filesystem at all</li>
        </ul>
</details>
<details>
    <summary>CrisNote: A ArchLinux Laptop</summary>
        <ul>
            <details>
                <summary>StatusBar-Script</summary>
                    <ul>
                        <li>battery-widget.sh: StatusBar script to extract battery level</li>
                        <li>CPU-freq-monitor.sh: StatusBar script to extract CPU frequency in GHz</li>
                        <li>CPU-temp-monitor.sh: StatusBar script to extract CPU temperature in ºC</li>
                        <li>CPU-usage-monitor.sh: StatusBar script to extract CPU usage in %</li>
                        <li>RAM-usage-monitor.sh: StatusBar script to extract RAM usage in %</li>
                    </ul>
            </details>
            <details>
                <summary>StatusBar-Script.old</summary>
                    <ul>
                        <li>crisNoteBatteryLevel: StatusBar script to extract battery level</li>
                        <li>crisNoteCpuTemp: (old) StatusBar script to extract CPU temperature in ºC</li>
                        <li>CrisNoteCPUtemp.sh: StatusBar script to extract CPU temperature in ºC</li>
                        <li>CrisNotoBatteryCapacity.sh: StatusBar script to extract battery level</li>
                    </ul>
            </details>
                <li>startUpApps-CrisNote: List of app to start with</li>
        </ul>
</details>
<details>
    <summary>fastfetch-scripts</summary>
        <ul>
            <li>fastfetch-btrfs+bees-version.sh: Extract btrfs and bees version at same time</li>
            <li>fastfetch-MoBo-info.sh: Extract only MoBo info necessary</li>
            <li>fastfetch-zsh+tmux-version.sh: Extract zsh and tmux version at same time</li>
        </ul>
</details>
<details>
    <summary>Old-unused</summary>
        <ul>
            <li>awesome-notify-test.sh: Just a test for awesomeWM notifications</li>
            <li>backInTime-gpgKeys-backup.sh: Automation for encryptation GPG keys</li>
            <li>feh_custom: Script to fix feh (app) window size</li>
            <li>gentoo-addUSEpackage.sh: (won't work) Script to add package and flags to portage use packages</li>
            <li>gentoo-update.sh: Fast way to update portage - substitute by better systemd automation</li>
            <li>jkyon-scrub.sh: scrub all my disks at same time, or close to this</li>
            <li>kdeConnect-refresh.sh: script to refesh KDEconnect - not needed anymore</li>
            <li>mycompsize.sh: Script to emule compsize app, but worse</li>
            <li>myfetch.sh: When I used neofech and not have (don't know how) storage support</li>
            <li>notification-test.sh: Just a script to test libnnotify</li>
            <li>snapShotsPreview.sh: Script to view btrfs snapshots disk usage </li>
        </ul>
</details>
<details>
    <summary>StatusBar-Script.old</summary>
        <ul>
            <li>awesomeWidget-CPU-freq-monitor.sh: Extract CPU frequency in MHz to statusBar</li>
            <li>awesomeWidget-gpu0freq.sh: Extract GPU0 frequency in MHz to statusBar</li>
            <li>awesomeWidget-gpu0temp.sh: Extract GPU0 temperature in ºC to statusBar</li>
            <li>awesomeWidget-gpu0usage-fast.sh: Fast way to extract GPU0 usage in % to statusBar</li>
            <li>awesomeWidget-gpu0usage-fast.sh: Extract GPU0 usage in % to statusBar</li>
            <li>awesomeWidget-gpu1freq.sh: Extract GPU1 frequency in MHz to statusBar</li>
            <li>awesomeWidget-gpu1temp.sh: Extract GPU1 temperature in ºC to statusBar</li>
            <li>awesomeWidget-PSU-monitor.sh: Extract PSU power in W to statusBar< /li>
            <li>awesomeWidget-PSU-temp-monitor.sh: Extract PSU VRM temperature in ºC to statusBar</li>
            <li>awesomeWidget-trackingAwesomeMemoryUse: Extract amount of awesomeWM memory in GB to statusBar</li>
            <li>dwmBlocksCpuTemp: Extract CPU temperature in ºC to statusBar</li>
            <li>dwmBlocksCpuUsage: Extract CPU usage in % to statusBar</li>
            <li>dwmBlocksMemUsage: Extract RAM usage in % to statusBar</li>
            <li>dwmBlocksNice: Extract Nice number to statusBar</li>
            <li>dwmBlocksUpdates: Extract numeber of portage packages to update to statusBar</li>
            <li>dwmBlocksVolumeAudio: Extract Volume level from pactl to statusBar</li>
            <li>memoryUsage-widget.sh: Another way to extract RAM usage in GB to statusBar</li>
        </ul>
</details>
<details>
    <summary>systemd</summary>
        <ul>
            <details>
                <summary>backInTime-gpgKeys-Backup.service:</summary>
                        
```systemd
# ~/.config/systemd/user/backintime-backup-job.service
    [Unit]
    Description=Run backintime snapshot generation
    
    [Service]
    Type=oneshot
    ExecStart=/usr/bin/nice -n19 /usr/bin/ionice -c2 -n7 /usr/bin/backintime backup-job
```
\
            </details>
            <li>backInTime-gpgKeys-Backup.timer: </li>
            <li>backintime-backup-job.service: </li>
            <li>backintime-backup-job.timer: </li>
            <li>borgBackup-jkyon.service: </li>
            <li>borgBackup-jkyon.timer: </li>
            <li>gpt4all.service: </li>
            <li>jkyon-picom-memoryUsageMonitor.service: </li>
            <li>jkyon-picom-memoryUsageMonitor.timer: </li>
            <li>jkyon-picom.service: </li>
            <li>jkyon-systemd-PortageRsyncDotfiles.service: </li>
            <li>jkyon-systemd-PortageRsyncDotfiles.timer: </li>
            <li>jkyon-systemd-notify-test.service: </li>
            <li>jkyon-systemd-notify-test.timer: </li>
            <li>lockScreen.service: </li>
            <li>pipewire-reset.service: </li>
            <li>pipewire-reset.timer: </li>
            <li>pipewire-session-manager.service: </li>
            <li>polkit-gnome-authentication-agent.service: </li>
        </ul>
</details>