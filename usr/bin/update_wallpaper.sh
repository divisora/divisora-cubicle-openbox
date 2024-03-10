#!/bin/bash

# https://superuser.com/questions/984180/how-to-execute-a-command-when-screen-resolution-changes-in-linux

program=/usr/bin/screen_resolution

resolution=$($program)

while true; do {
        newResolution=$($program)
        if [ "$newResolution" != "$resolution" ]; then {
                echo "Resolution change: $newResolution"
                resolution=$newResolution
                feh --bg-scale /usr/share/wallpapers/background-benzoix.jpg
        } fi

        sleep 2
} done
