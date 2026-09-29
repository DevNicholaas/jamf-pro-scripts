#!/bin/zsh
# =============================================================================
# Script Name:  disk_management_override.zsh
# Description:  Prompts a privileged user via jamfHelper to confirm removal of
#               a disk management restriction policy. If confirmed, creates a
#               hidden flag file that signals Jamf Pro to remove the restriction
#               blueprint from scope, then triggers an inventory update.
#
# How it works:
#   1. Script is scoped to privileged users via an LDAP group limitation
#   2. User is prompted to confirm they want to remove the restriction
#   3. If confirmed, a hidden flag file is created
#   4. Jamf inventory updates, moving the computer out of the restricted scope
#   5. The blueprint targeting computers WITHOUT the flag file no longer applies
#
# Requirements:
#   - Jamf Pro with jamfHelper installed
#   - A blueprint scoped to computers where the flag file does NOT exist
#   - An extension attribute reporting whether the flag file exists
#   - Policy limited to a privileged LDAP group (e.g. IT department)
#
# Author:       Your Name
# Date:         2026
# =============================================================================

# -----------------------------------------------------------------------------
# CONFIGURATION — edit these variables for your environment
# -----------------------------------------------------------------------------

# Path and name of the hidden flag file
# When this file exists, the restriction blueprint removes itself from scope
FLAG_FILE="/var/db/.mgmt_override.txt"

# jamfHelper settings
JAMF_HELPER="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
WINDOW_TYPE="hud"
WINDOW_TITLE="Policy Override"

# Confirmation prompt shown to the user
PROMPT_MESSAGE="Are you sure you want to remove the disk management restriction policy?

This will allow access to external and network storage devices.
Contact IT if you have any questions."

# Button labels
BUTTON_YES="Yes"
BUTTON_NO="No"

# Path to Jamf binary
JAMF_BINARY="/usr/local/jamf/bin/jamf"

# -----------------------------------------------------------------------------
# MAIN SCRIPT
# -----------------------------------------------------------------------------

# Prompt the user for confirmation
userChoice=$("$JAMF_HELPER" \
    -windowType "$WINDOW_TYPE" \
    -title "$WINDOW_TITLE" \
    -description "$PROMPT_MESSAGE" \
    -button1 "$BUTTON_YES" \
    -button2 "$BUTTON_NO" \
    -defaultButton 2)

# If user clicked Yes (button1 returns 0)
if [[ "$userChoice" == "0" ]]; then

    # Create the hidden flag file
    touch "$FLAG_FILE"

    if [[ -e "$FLAG_FILE" ]]; then
        echo "Flag file created at $FLAG_FILE. Updating inventory..."
        # Trigger inventory update so Jamf Pro re-evaluates scope immediately
        "$JAMF_BINARY" recon
    else
        echo "ERROR: Failed to create flag file at $FLAG_FILE"
        exit 1
    fi

else
    echo "User cancelled. No changes made."
fi

exit 0
