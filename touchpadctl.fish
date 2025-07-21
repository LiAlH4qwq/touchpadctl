#!/bin/env fish

# touchpadctl
# Author: LiAlH4

# Args
# - subCommand: string
function touchpadctl -a subCommand #: string
    set -l appName "touchpadctl" #: "touchpadctl"
    set -l appVersion "v0.2.0" #: string
    switch $subCommand
        case "enable" "disable" "toggle"
            changeTouchpadState $subCommand
        case "help"
            showHelpMessage $appName $appVersion
        case "*"
            showInvalidSubCommandError $appName $subCommand
    end
end

# Args
# - appName: "touchpadctl"
# - appVersion: string
function showHelpMessage -a appName appVersion #: string
    printf "%s %s\n" $appName $appVersion
    printf "Usage: %s <sub command>\n" $appName
    printf "Sub commands:\n"
    printf "help: display this message\n"
    printf "toggle: toggle the touchpad\n"
    printf "enable: enable the touchpad\n"
    printf "disable: disable the touchpad\n"
end

# Args
# - appName: "touchpadctl"
# - subCommand: string
function showInvalidSubCommandError -a appName subCommand #: string
    # Easter egg!
    if [ -z $subCommand ]
        set -f subCommand "<undefined>"
    end
    printf "Invalid sub command: %s\n" $subCommand
    printf "Use: %s help for help.\n" $appName
end

# Args
# - subCommand: string
function changeTouchpadState -a subCommand #: string
    set -l settingPath "org.gnome.desktop.peripherals.touchpad" "send-events" #: string[2]
    switch $subCommand
        case "enable"
            setTouchpadState $settingPath "enabled"
        case "disable"
            setTouchpadState $settingPath "disabled"
        case "toggle"
            invertTouchpadState $settingPath
        case "*"
            showLogicalFatel
    end
end

# Args
# - settingPath: string[2]
function invertTouchpadState #: string
    set -l settingPath $argv
    set -l currentState (getTouchpadState $settingPath) #: "enabled" | "disabled"
    switch $currentState
        case "enabled"
            setTouchpadState $settingPath "disabled"
        case "disabled"
            setTouchpadState $settingPath "enabled"
        case "*"
            showLogicalFatel
    end
end

# Args
# - settingPath: string[2]
function getTouchpadState #: "enabled" | "disabled"
    set -l settingPath $argv
    set -l rawResult (gsettings get $settingPath) #: string
    set -l quoteRemovedResult (string replace "'" "" $rawResult) #:string
    # May be there's a fish's bug, we have to repeat once again to remove another quote.
    set -l reallyQuoteRemovedResult (string replace "'" "" $quoteRemovedResult) #:string
    switch $reallyQuoteRemovedResult
        case "enabled" "disabled"
            printf $reallyQuoteRemovedResult #return
        case "*"
            echo "An error has been encountered during getting touchpad state:"
            echo "Current state:" $reallyQuoteRemovedResult "is invalid."
            exit 1
    end
end

# Args
# - settingPath: string[2]
# - newState: "enabled" | "disabled"
function setTouchpadState #:void
    set -l settingPath $argv[1..2]
    set -l newState $argv[3]
    gsettings set $settingPath $newState
end

# Args
function showLogicalFatal
    printf "Code has a logical fatel error, some statement should never be reached, exiting!"
    exit 2147483647
end

touchpadctl $argv
