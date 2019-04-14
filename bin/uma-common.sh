#!/bin/false

debug() {
   "${VERBOSE}" && outmsg "${@}"
}

outmsg() {
    echo "${@}"
}

##
# Removes all (DEVPATH, MOUNTPOINT) pairs from MOUNTS_FILE that match a provided
# pattern, which is usually just the device path.
#
# Globals:
#   MOUNTS_FILE
# Arguments:
#   pattern -   regex pattern string to use as filter. Forward slashes will be
#               escaped so a device path is valid.
# Returns: None
remove_mounts_file_entry()
{
    pattern="${1}"
    escaped_pattern=$(echo "$pattern" | sed -e 's/[\/&]/\\&/g')
    sed -i '/'$escaped_pattern'/d' $MOUNTS_FILE
}
