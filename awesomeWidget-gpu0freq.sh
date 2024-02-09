#!/usr/bin/env bash
#
#!/usr/bin/env bash
#
    cat /sys/class/hwmon/hwmon4/freq1_input | \
        sed -e 's/......$//' | \
        awk '{sub("$", " MHz", $1)}; 1'
