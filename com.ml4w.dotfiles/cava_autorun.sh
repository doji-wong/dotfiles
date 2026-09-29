#!/bin/bash

# This script automatically starts and stops cava when a browser is playing audio.

# Function to check for running browser audio streams
function browser_is_running() {
    pactl list sink-inputs | grep -q -E 'application.process.binary = "(firefox|chrome|microsoft-edge)"'
}

# Function to start cava
function start_cava() {
    if ! pgrep -x "cava" > /dev/null
    then
        kitty -e cava &
    fi
}

# Function to stop cava
function stop_cava() {
    if pgrep -x "cava" > /dev/null
    then
        killall cava
    fi
}

# Main loop
pactl subscribe | while read -r event; do
    if echo "$event" | grep -q "new sink-input"; then
        if browser_is_running; then
            start_cava
        fi
    fi

    if echo "$event" | grep -q "remove sink-input"; then
        # Give PulseAudio some time to update the list of sink-inputs
        sleep 1
        if ! browser_is_running; then
            stop_cava
        fi
    fi
done
