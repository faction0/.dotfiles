#!/bin/bash

# Use i3-msg to query the current layout of the focused window.
SOUND_ROOT=/home/faction/.dotfiles/assets/sounds
ASS=/home/faction/.dotfiles/assets

case "$1" in
  "i3")
    case "$2" in
      "workspace")
        shift
        i3-msg $@ &
        df-sound-launcher 40000 w_switch$(shuf -i 1-4 -n 1).wav &
      ;;

      "move")
        shift
        i3-msg $@ &
        df-sound-launcher 40000 w_move$(shuf -i 1-5 -n 1).wav &
      ;;

      "tiling")
        # what
        floating=$(i3-msg -t get_tree | jq -e '.. | select(.focused? == true).floating')

        if [ $floating = "\"user_off\"" ]; then # we all float down here (will now float)
          df-sound-launcher 42500 window-float.mp3 &

        elif [ $floating = "\"user_on\"" ]; then  # will now tile
          df-sound-launcher 45000 window-tile.mp3 &
        fi

        i3-msg floating toggle &
      ;;

      "kill")
        i3-msg kill &
        df-sound-launcher 40000 close.mp3 &
      ;;

      "lock")
        df-sound-launcher 85000 lock.mp3 &
        i3lock -n -i "${ASS}/wallpaper-locked.png"
        df-sound-launcher 65000 unlock.mp3 &
      ;;

    esac
  ;;

  "ptt")
    case "$2" in
      "on")
        df-sound-launcher 25000 ptt-on.mp3 &
      ;;
      "off")
        df-sound-launcher 25000 ptt-off.mp3 &
      ;;
    esac
  ;;

  "rofi")

    df-sound-launcher 40000 rofi-start.mp3 &

    rofi -show run \
      -on-entry-accepted "df-sound-launcher 41000 open.mp3 &" \
      -on-menu-canceled "df-sound-launcher 50000 back.wav &" \
      -on-menu-error "df-sound-launcher 45000 error-small.wav &" &
  ;;

  "alacritty")
    shift
    alacritty $@ &

    df-sound-launcher 40000 open.mp3 &
  ;;

  "clear-notifications")
    dunstctl close-all &

    df-sound-launcher 40000 clear-notif.mp3 &
  ;;

  "audio-orientation")
    df-sound-launcher 70000 left.wav &
    df-sound-launcher 70000 right.wav &
  ;;

  "nuke")

    case "$2" in
      "begin")
        before=$(wmctrl -l | wc -l)

        df-sound-launcher 42000 nuke-start.wav &
        xkill &
        killpid=$!
        /home/faction/.dotfiles/assets/scripts/sound-handler.sh nuke loop &

        wait $killpid
        after=$(wmctrl -l | wc -l)
        
        if [ "$after" -lt "$before" ]; then

          killall paplay
          pkill -f "sound-handler.sh nuke loop"
          killall paplay

          df-sound-launcher 40000 nuke-finish.mp3 &
          break

        else

          killall paplay
          pkill -f "sound-handler.sh nuke loop"
          killall paplay

          df-sound-launcher 35000 mantle.mp3 &
          break

        fi
      ;;

      "loop")
        sleep 2.6

        while true; do
          df-sound-launcher 40000 nuke-loop.wav &
          sleep 1.07
          
        done
      ;;
    esac
  ;;
esac
