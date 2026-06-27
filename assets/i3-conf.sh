set $mod Mod4
set $sound_launcher exec --no-startup-id ~/.dotfiles/assets/scripts/sound-launcher.sh
set $sound_handler exec --no-startup-id ~/.dotfiles/assets/scripts/sound-handler.sh

exec --no-startup-id systemctl --user restart mpd
exec --no-startup-id opensnitch-ui

# class                 border  bground text    indicator child_border
client.focused          #616161 #616161 #f0f0f0 #aaaaaa   #616161
client.focused_inactive #121212 #121212 #626262 #343434   #121212
client.unfocused        #121212 #121212 #626262 #343434   #121212
client.urgent           #E3E3E3 #E3E3E3 #474747 #000000   #E3E3E3
client.placeholder      #000000 #0C0C0C #FFFFFF #000000   #0C0C0C

client.background       #000000

exec_always --no-startup-id feh --bg-scale ~/.dotfiles/assets/wallpaper.png

font pango:0xProto Nerd Font Mono 10

floating_modifier $mod
tiling_drag modifier titlebar

bindsym $mod+Return $sound_handler alacritty
for_window [class="Alacritty"] floating enable

bindsym $mod+Shift+q $sound_handler i3 kill
bindsym $mod+Control+q $sound_handler nuke begin

bindsym $mod+Control+d $sound_handler rofi
bindsym $mod+Control+e exec --no-startup-id alacritty -e bash -lc nnn

bindsym $mod+Shift+e exec --no-startup-id nemo

bindsym $mod+equal $sound_handler i3 lock
bindsym $mod+l $sound_handler clear-notifications
bindsym $mod+Control+v exec --no-startup-id xclip -selection clipboard -out | xdotool selectwindow windowfocus type --delay 1 --clearmodifiers --window %@ --file -
bindsym $mod+Control+s exec --no-startup-id scrot -s -f -o '/dev/stdout' | xclip -selection clipboard -t image/png

bindsym $mod+Control+x exec --no-startup-id flatpak run com.github.dynobo.normcap -l jpn -c "#ffffff"

bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

bindsym $mod+h split h

bindsym $mod+v split v

bindsym $mod+f fullscreen toggle

bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

bindsym $mod+Shift+space $sound_handler i3 tiling

bindsym $mod+space focus mode_toggle

bindsym $mod+a $sound_handler i3 workspace a
bindsym $mod+s $sound_handler i3 workspace s
bindsym $mod+d $sound_handler i3 workspace d

bindsym $mod+z $sound_handler i3 workspace z
bindsym $mod+x $sound_handler i3 workspace x
bindsym $mod+c $sound_handler i3 workspace c

bindsym $mod+p $sound_handler i3 workspace p

bindsym $mod+Shift+a $sound_handler i3 move container to workspace a
bindsym $mod+Shift+s $sound_handler i3 move container to workspace s
bindsym $mod+Shift+d $sound_handler i3 move container to workspace d

bindsym $mod+Shift+z $sound_handler i3 move container to workspace z
bindsym $mod+Shift+x $sound_handler i3 move container to workspace x
bindsym $mod+Shift+c $sound_handler i3 move container to workspace c

bindsym $mod+Shift+p $sound_handler i3 move container to workspace p

bindsym $mod+Shift+r restart
bindsym $mod+Shift+m exec "i3-nagbar -t warning -m 'moo' -B 'yes, moo' 'i3-msg exit'"

exec --no-startup-id i3-msg 'workspace s'

for_window [class="opensnitch-ui"] move to workspace z
for_window [class="steam"] move to workspace z
for_window [class="vscodium"] move to workspace c
for_window [class="vesktop"] move to workspace x
for_window [class="libreoffice"] move to workspace d
