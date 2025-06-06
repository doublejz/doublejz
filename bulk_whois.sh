#!/bin/bash
# Bulk Whois Lookup
# Generates a CSV of Whois lookups from a list of IP addresses.

# File name/path of domain list:
ip_list='ips.txt' # One IP per line in file.

# Makes sure theres not hidden chars
dos2unix $ip_list

# Seconds to wait between lookups:
loop_wait='1' # Is set to 1 second.

echo 'IP Address, Org Name' # Start CSV
for ip in $(cat $ip_list) # Start looping through IPs
do

result=$(whois $ip | grep -i -m 1 OrgName: | awk -F ":        " '{print $2}')

if [ -z ${result+x} ]; then
    echo "true"
    result=$(whois $ip | grep -i -m 1 NetName: | awk -F ":        " '{print $2}')
else
    # Org Name was found and is set.
    echo "all" >/dev/null
fi

# Output the IP address and organization name
echo "$ip*$result"

sleep $loop_wait # Pause before the next lookup to avoid flooding NS

done
