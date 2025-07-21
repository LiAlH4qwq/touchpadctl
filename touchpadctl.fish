#!/bin/env fish

function touchpadctl 
    set -l settingPath "org.gnome.desktop.peripherals.touchpad" "send-events" #: string[]
    set -l currentSetting (gsettings get $settingPath) #: "'enabled'" | "'disabled'"
    switch $currentSetting
        case "'enabled'"
            gsettings set $settingPath "disabled"
            echo "Touchpad: ON -> OFF"
            notify-send -ea "touchpadctl" "Touchpad" "ON → OFF"
        case "'disabled'"
            gsettings set $settingPath "enabled"
            echo "Touchpad: OFF -> ON"
            notify-send -ea "touchpadctl" "Touchpad" "OFF → ON"
        case "*"
            echo "An error has been encountered during toggle touchpad state:"
            echo "Current state:" $currentSetting "is invalid."
    end
end

touchpadctl
