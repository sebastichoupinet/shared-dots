# shared-dots
Some scripts and other things


##wallpaper switcher module




```
[module/wallpaper]
type = custom/script
exec = ~/.config/polybar/scripts/wallpaper-switcher.sh --get_speed
label = %{T7}%output%%{T-}
interval = 1
format-padding = ${paddings.outer}
format-background = ${colors.blurred}
click-left = "sh ~/.config/polybar/scripts/wallpaper-switcher.sh --increase"
click-right = "sh ~/.config/polybar/scripts/wallpaper-switcher.sh --switch"
double-click-right = "sh ~/.config/polybar/scripts/wallpaper-switcher.sh --randomize"
```
