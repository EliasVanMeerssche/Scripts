#!/bin/bash

sudo pacman -S --noconfirm mpd mpc rmpc
mkdir -p ~/.config/mpd
cp /usr/share/doc/mpd/mpdconf.example ~/.config/mpd/mpd.conf
mkdir ~/music
sudo systemctl enable mpd
sudo systemctl start mpd
mpc update