#!/bin/bash
# 🌿 All-in-One i3 Bonsai + Interactive Bar Setup for Arch Linux
# Run as your normal user (not root)

set -e

# ───────────────────────────────
# 🍃 Create i3blocks config
# ───────────────────────────────
cat > ~/.config/i3blocks/config <<'EOF'
# ~/.config/i3blocks/config — Clickable i3bar blocks 🌿

[network]
label=
command=nmcli -t -f active,ssid dev wifi | grep yes | cut -d: -f2
interval=10
click-left=nm-connection-editor
click-right=alacritty -e nmtui

[time]
label=
command=date '+%a %d %b %H:%M'
interval=60
click-left=gsimplecal

[battery]
label=🔋
command=acpi | cut -d, -f 2
interval=30

[volume]
label=
command=pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n 1
interval=2
click-left=pactl set-sink-mute @DEFAULT_SINK@ toggle
click-right=alacritty -e alsamixer

[music]
label=
command=mpc current || echo "⏹ Stopped"
interval=5
click-left=mpc toggle
click-right=mpc next
click-middle=mpc prev
EOF


# ───────────────────────────────
# 🍃 Finish up
# ───────────────────────────────

cat <<'EOF'

🌿 DONE!

Features installed:
  • Slow-growing bonsai lock screen → Mod+Shift+L
  • Clickable i3bar using i3blocks:
      - Click Wi-Fi → Network Manager or nmtui
      - Click Clock → Calendar (gsimplecal)
      - Click Volume → Toggle mute / open alsamixer
      - Battery indicator

Tip: You may need to log out/in once for Nerd Fonts to load in i3bar.

EOF
