#! /bin/bash
# dave@networkdave.com
#
echo -e "\nThis script will iterate through a list of zones, creating each in NIOS.\n"
# $GM to be used in the Curl commands
echo -e "\nEnter the Grid Master address:\n"
read GM
# $USER to be used in Curl authentication
echo -e "\nEnter your NIOS username:\n"
read USER
# $PW to be used in Curl authentication, won't be echo'd into the terminal when typed
echo -e "\nEnter your NIOS password:\n"
read -s PW
# List of network to create goes to $FILE
echo -e "\nEnter the file name that contains the zones you wish to create:\n"
read FILE
# Take DNS view name and put in $VIEW
echo -e "\nWhat DNS view do you want the zones created in:\n"
read VIEW
# Loop through the file, creating each in NIOS
cat $FILE | 
while read LINE
	do
	echo -e "Creating zone $LINE..."
	curl -k1 -u $USER:$PW -X POST https://"$GM"/wapi/v1.7.3/zone_auth -d fqdn="$LINE" -d view="$VIEW"
	echo -e "\n"
done