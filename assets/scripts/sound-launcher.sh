#!/bin/bash

SOUND_ROOT=/home/faction/.dotfiles/assets/sounds

paplay --volume=$1 ${SOUND_ROOT}/$2
