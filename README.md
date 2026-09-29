Jamf Pro Scripts

A collection of reusable zsh scripts for macOS device management with Jamf Pro. These scripts are designed to be deployed via Jamf Pro policies and work alongside configuration profiles and blueprints.

Scripts
1. restart_notification.zsh

Prompts users to restart their computer when their last boot time exceeds a defined threshold.

How it works:

Retrieves the computer's last boot time from the system
Displays a jamfHelper notification showing the last boot time
Gives the user the option to restart or cancel
If the user chooses to restart, triggers a Jamf Pro policy via a custom event

Jamf Pro Setup:

Create a policy with a custom trigger (e.g. restart) that restarts the computer
Deploy this script via a second policy triggered by recurring check-in
Scope both policies to a smart group where last boot time exceeds your threshold (e.g. 14 days)
Set frequency to Once every day

Requirements:

Jamf Pro with jamfHelper installed
A restart policy configured with a matching custom trigger
Smart group based on last boot time extension attribute
2. disk_management_override.zsh

Allows privileged users to remove a disk management restriction policy via Self Service.

How it works:

Prompts the user to confirm they want to remove the disk restriction
If confirmed, creates a hidden flag file on the computer
Triggers a Jamf inventory update so Jamf Pro immediately re-evaluates scope
A blueprint scoped to computers WITHOUT the flag file removes itself automatically

Jamf Pro Setup:

Create an extension attribute that checks whether the flag file exists
Create a blueprint with a Disk Management Policy component scoped to computers where the flag file does NOT exist
Deploy this script via a Self Service policy
Limit the policy to a privileged LDAP group (e.g. IT department)
Set frequency to Ongoing

Requirements:

Jamf Pro with jamfHelper installed
Extension attribute reporting flag file existence
Blueprint with Disk Management Policy component
Privileged LDAP group for scoping
Requirements
macOS 12.0+
Jamf Pro 11.0+
jamfHelper installed on managed computers
Scripts deployed via Jamf Pro policies
Usage
Download the script you need
Edit the configuration variables at the top of the script for your environment
Upload to Jamf Pro → Computer Management → Scripts
Deploy via a Jamf Pro policy with appropriate trigger, frequency and scope
Author

Nicholas Miller github.com/DevNicholaas
