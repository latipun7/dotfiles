#!/usr/bin/env bash
# shellcheck disable=2016

swayidle -w \
  before-sleep "bash $XDG_CONFIG_HOME/hypr/scripts/lock" \
  timeout 300 'temp=$(brightnessctl g); brightnessctl set $((temp / 2))' \
  resume 'temp=$(brightnessctl g); brightnessctl set $((temp * 2))' \
  timeout 600 "bash $XDG_CONFIG_HOME/hypr/scripts/lock & sleep 0.1 && hyprctl dispatch dpms off" \
  resume 'hyprctl dispatch dpms on'
