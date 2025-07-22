#!/bin/env fish

# touchpadctl
# Author: LiAlH4

set -g APP_NAME "touchpadctl" #: "touchpadctl"
set -g APP_VERSION "v0.2.0" #: string
set -g SETTING_PATH "org.gnome.desktop.peripherals.touchpad" "send-events" #: string[2]

# Args
# - subCommand: string
function touchpadctl -a subCommand #: void
    switch $subCommand
        case "enable" "disable" "toggle"
            changeTouchpadState $subCommand
        case "help"
            showHelpMessage
        case "*"
            showInvalidSubCommandError $subCommand
    end
end

# Args
function showHelpMessage #: void
    printf "%s %s\n" $APP_NAME $APP_VERSION
    printf "Usage: %s <sub command>\n" $APP_NAME
    printf "Sub commands:\n"
    printf "help: display this message\n"
    printf "toggle: toggle the touchpad\n"
    printf "enable: enable the touchpad\n"
    printf "disable: disable the touchpad\n"
end

# Args
# - subCommand: string
function showInvalidSubCommandError -a subCommand #: void
    # Easter egg!
    if [ -z $subCommand ]
        set -f subCommand "<undefined>"
    end
    printf "Invalid sub command: %s\n" $subCommand
    printf "Use: %s help for help.\n" $APP_NAME
end

# Args
function showLogicalFatal #:void
    printf "Code has a logical fatel error, some statement should never be reached, exiting!"
    exit 2147483647
end

# Args
# - subCommand: string
function changeTouchpadState -a subCommand #: void
    switch $subCommand
        case "enable"
            setTouchpadState "enabled"
            sendTouchpadStateChangeDesktopNotification "<undefined>" "enabled"
        case "disable"
            setTouchpadState "disabled"
            sendTouchpadStateChangeDesktopNotification "<undefined>" "disabled"
        case "toggle"
            invertTouchpadState
        case "*"
            showLogicalFatel
    end
end

# Args
function invertTouchpadState #: void
    set -l currentState (getTouchpadState) #: "enabled" | "disabled"
    switch $currentState
        case "enabled"
            setTouchpadState "disabled"
            sendTouchpadStateChangeDesktopNotification "$currentState" "disabled"
        case "disabled"
            setTouchpadState "enabled"
            sendTouchpadStateChangeDesktopNotification "$currentState" "enabled"
        case "*"
            showLogicalFatel
    end
end

# Args
function getTouchpadState #: "enabled" | "disabled"
    set -l queryCommand "gsettings" "get" $SETTING_PATH #: string[3]
    set -l rawResult (runExternalCommand $queryCommand) #: string
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
# - newState: "enabled" | "disabled"
function setTouchpadState -a newState #:void
    set -l setCommand "gsettings" "set" $SETTING_PATH $newState #: string[4]
    runExternalCommand $setCommand
end

# Args
# - oldState: "enabled" | "disabled" | "<undefined>"
# - newState: "enabled" | "disabled"
function sendTouchpadStateChangeDesktopNotification -a oldState newState #: void
    switch $newState
        case "enabled"
            set newState "ON"
        case "disabled"
            set newState "OFF"
        case "*"
            showLogicalFatal
    end
    set -l stateChangeText ""
    switch $oldState
        case "<undefined>"
            set stateChangeText "Turned $newState unconditionally."
        case "enabled"
            set stateChangeText "ON → $newState"
        case "disabled"
            set stateChangeText "OFF → $newState"
    end
    sendDesktopNotification "Touchpad" "$stateChangeText"
end

# Args
# - title: string
# - content: string
function sendDesktopNotification -a title content #: void
    set -l sendNotificationCommand "notify-send" "-ea" "\"$APP_NAME\"" "\"$title\"" "\"$content\"" #: string[]
    runExternalCommand $sendNotificationCommand
end

# Args
# - externalCommand: string[]
function runExternalCommand #: string
    # Function args
    set -l externalCommand $argv

    eval $externalCommand
end

touchpadctl $argv