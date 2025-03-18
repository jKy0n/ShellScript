#!/usr/bin/env bash
#
sudo chown jkyon:configEdit ~/.dotfiles/portage/savedconfig/x11-wm/dwm-6.3 &&
sudo chown jkyon:configEdit ~/.dotfiles/portage/savedconfig/x11-wm/dwm-6.3.h &&
echo "dwm config changed owner" &&
sudo chown jkyon:configEdit ~/.dotfiles/portage/savedconfig/x11-terms/st-0.9 &&
sudo chown jkyon:configEdit ~/.dotfiles/portage/savedconfig/x11-terms/st-0.9.h &&
echo "st config changed owner" &&
sudo chown jkyon:configEdit ~/.dotfiles/portage/savedconfig/x11-misc/dmenu-5.0 &&
sudo chown jkyon:configEdit ~/.dotfiles/portage/savedconfig/x11-misc/dmenu-5.0.h &&
echo "dmenu config changed owner" &&
sudo chown jkyon:configEdit ~/.dotfiles/portage/savedconfig/x11-misc/dwmblocks-0.2 &&
sudo chown jkyon:configEdit ~/.dotfiles/portage/savedconfig/x11-misc/dwmblocks-0.2.h &&
echo "dwmBlocks config changed owner" &&
echo " --- All files had changed owner --- " &&
sudo chmod 664 /home/jkyon/.dotfiles/portage/savedconfig/x11-wm/dwm-6.3 &&
sudo chmod 664 /home/jkyon/.dotfiles/portage/savedconfig/x11-wm/dwm-6.3.h &&
echo "dwm config able to write" &&
sudo chmod 664 /home/jkyon/.dotfiles/portage/savedconfig/x11-terms/st-0.9 &&
sudo chmod 664 /home/jkyon/.dotfiles/portage/savedconfig/x11-terms/st-0.9.h &&
echo "st config able to write" &&
sudo chmod 664 /home/jkyon/.dotfiles/portage/savedconfig/x11-misc/dmenu-5.0 &&
sudo chmod 664 /home/jkyon/.dotfiles/portage/savedconfig/x11-misc/dmenu-5.0.h &&
echo "dmenu config able to write" &&
sudo chmod 664 /home/jkyon/.dotfiles/portage/savedconfig/x11-misc/dwmblocks-0.2 &&
sudo chmod 664 /home/jkyon/.dotfiles/portage/savedconfig/x11-misc/dwmblocks-0.2.h
echo "dwmBlock config able to write" &&
echo " --- All files are able to edit --- " &&
echo "Done. dwm stuffs already to edit! =)"