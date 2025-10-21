#!/bin/bash

echo "✅ Setup complete!"
echo "Reloading i3..."
i3-msg reload >/dev/null 2>&1 || true
i3-msg restart >/dev/null 2>&1 || true

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
