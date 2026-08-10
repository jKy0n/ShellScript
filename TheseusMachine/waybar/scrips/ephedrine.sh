#!/bin/bash
if ephedrine status >/dev/null 2>&1; then
    CLASS="active"
    TOOLTIP="ephedrine ativo"
else
    CLASS=""
    TOOLTIP="ephedrine desligado"
fi

echo "{\"text\": \"<span font_desc='Font Awesome 6 Free Solid 12'>tablets</span>\", \"class\": \"$CLASS\", \"tooltip\": \"$TOOLTIP\"}"
