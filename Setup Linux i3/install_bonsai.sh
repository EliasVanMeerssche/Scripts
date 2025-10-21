#!/bin/bash
# 🌿 All-in-One i3 Bonsai + Interactive Bar Setup for Arch Linux
# Run as your normal user (not root)

set -e

# sudo pacman -S --needed git base-devel
# git clone https://aur.archlinux.org/yay.git
# cd yay
# makepkg -si
# yay -S cbonsai
# yay -S i3lock-color

echo "🌿 Installing required packages..."
sudo pacman -S --noconfirm i3blocks alacritty networkmanager gsimplecal dunst imagemagick ttf-nerd-fonts-symbols

echo "🌿 Creating directories..."
mkdir -p ~/.config/i3blocks ~/.local/bin

# ───────────────────────────────
# 🍃 Create the bonsai lock script
# ───────────────────────────────
cat > ~/.local/bin/bonsai-lock <<'EOF'
#!/bin/bash
# 🌳 Slow Bonsai Lock Script

# Close any previous bonsai
pkill -f cbonsai || true

# Launch fullscreen Alacritty with slow bonsai animation
alacritty --title "bonsai-lock" -o window.startup_mode=Fullscreen -e \
  bash -c 'cbonsai -l -t 10000 -T unicode --bonsai-speed 0.02' &

# Wait for keypress to lock
read -n 1 -s -r -p "Press any key to lock..."

# Lock with i3lock-color
i3lock-color -c 000000 --inside-color=00000000 --ring-color=00ff00 \
  --keyhl-color=00ff00 --bshl-color=00ff00 --separator-color=00000000 \
  --verif-text="Growing..." --wrong-text="Not your tree." \
  --clock --indicator --timestr="%H:%M" --datestr="%A, %d %B"

# Kill the bonsai terminal after unlocking
pkill -f "alacritty.*bonsai-lock"
EOF
chmod +x ~/.local/bin/bonsai-lock

