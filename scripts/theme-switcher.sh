#!/bin/bash
while :
do
        HOUR=$(date -u +%H)
        if [ "$HOUR" -gt "20" ] || [ "$HOUR" -lt "8" ]
                then
                gsettings set org.gnome.desktop.interface gtk-theme 'Kali-Light'
        else
                gsettings set org.gnome.desktop.interface gtk-theme 'Kali-Dark'
        fi
 
        sleep 5m
done
