#!/bin/zsh
# =============================================================================
# Script Name:  restart_notification.zsh
# Description:  Displays the user's last boot time via jamfHelper and prompts
#               them to restart. If the user chooses to restart, a Jamf Pro
#               policy is triggered via a custom event.
#
# Requirements:
#   - Jamf Pro with jamfHelper installed
#   - A Jamf Pro policy configured with the custom trigger defined below
#
# Usage:
#   Deploy via Jamf Pro policy triggered by recurring check-in.
#   Scope to computers with a last boot time exceeding your threshold.
#
# Author:       Your Name
# Date:         2026
# =============================================================================

# -----------------------------------------------------------------------------
# CONFIGURATION — edit these variables for your environment
# -----------------------------------------------------------------------------

# The custom event trigger name configured in your Jamf Pro restart policy
CUSTOM_TRIGGER="restart"

# jamfHelper window type: hud, utility, or fs (full screen)
WINDOW_TYPE="hud"

# Title shown in the jamfHelper window
WINDOW_TITLE="Restart Required"

# Button labels
BUTTON_RESTART="Restart"
BUTTON_CANCEL="Cancel"

# Path to jamfHelper — standard Jamf Pro install path
JAMF_HELPER="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Path to Jamf binary
JAMF_BINARY="/usr/local/jamf/bin/jamf"

# -----------------------------------------------------------------------------
# MAIN SCRIPT
# -----------------------------------------------------------------------------

# Get the last boot time from the system
lastBoot=$(who -b | awk '{print $3, $4}')

# Display jamfHelper prompt to the user
userChoice=$("$JAMF_HELPER" \
    -windowType "$WINDOW_TYPE" \
    -title "$WINDOW_TITLE" \
    -description "Your computer was last restarted on: $lastBoot.

Regular restarts help maintain performance and stability. Would you like to restart now?" \
    -button1 "$BUTTON_RESTART" \
    -button2 "$BUTTON_CANCEL" \
    -defaultButton 1)

# If user clicked Restart (button1 returns 0), trigger the restart policy
if [[ "$userChoice" == "0" ]]; then
    "$JAMF_BINARY" policy -event "$CUSTOM_TRIGGER"
fi

exit 0
