set $mod Mod4

# class                 border  bground text    indicator child_border
client.focused          #616161 #616161 #f0f0f0 #aaaaaa   #616161
client.focused_inactive #121212 #121212 #626262 #343434   #121212
client.unfocused        #121212 #121212 #626262 #343434   #121212
client.urgent           #7F58D3 #7F58D3 #FFFFFF #900000   #7F58D3
client.placeholder      #000000 #0C0C0C #FFFFFF #000000   #0C0C0C

client.background       #000000

exec_always --no-startup-id feh --bg-scale ~/.dotfiles/assets/wallpaper.png

exec setxkbmap us -variant intl
exec xrandr --output HDMI-0 --mode 2560x1080 --rate 74.99

font pango:0xProto Nerd Font Mono 10

# evil
floating_modifier $mod
tiling_drag modifier titlebar

# start a terminal
bindsym $mod+Return exec alacritty

# kill focused window
bindsym $mod+Shift+q kill
bindsym $mod+Control+q exec --no-startup-id xkill

bindsym $mod+Control+d exec --no-startup-id rofi -show run
bindsym $mod+Control+e exec --no-startup-id alacritty -e nnn

bindsym $mod+equal exec --no-startup-id i3lock -fei ~/.dotfiles/assets/wallpaper-locked.png
bindsym $mod+l exec --no-startup-id dunstctl close-all
bindsym $mod+Control+v exec --no-startup-id xclip -selection clipboard -out | xdotool selectwindow windowfocus type --delay 1 --clearmodifiers --window %@ --file -
bindsym $mod+Control+s exec --no-startup-id flameshot gui

bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+h split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# switch to workspace
bindsym $mod+a workspace a
bindsym $mod+s workspace s
bindsym $mod+d workspace d

bindsym $mod+z workspace z
bindsym $mod+x workspace x
bindsym $mod+c workspace c

# move focused container to workspace
bindsym $mod+Shift+a move container to workspace a
bindsym $mod+Shift+s move container to workspace s
bindsym $mod+Shift+d move container to workspace d

bindsym $mod+Shift+z move container to workspace z
bindsym $mod+Shift+x move container to workspace x
bindsym $mod+Shift+c move container to workspace c

# music
bindsym $mod+p workspace p
bindsym $mod+Shift+p move container to workspace p

# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart

# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'moo' -B 'yes, moo' 'i3-msg exit'"
