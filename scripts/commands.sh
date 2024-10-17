#!/bin/bash

# Function to colorize echo messages
echocc() {
    local level="$1"
    local message="$2"
    local color_code
    case "$level" in
        info)
            color_code="90"  # Gray
            ;;
        warn)
            color_code="33"  # Yellow
            ;;
        error)
            color_code="31"  # Red
            ;;
        *)
            color_code="0"   # Default
            ;;
    esac
    echo "\033[${color_code}m${message}\033[0m"
}

alias po='echocc info'
alias pe='echocc error'
alias pw='echocc warn'
