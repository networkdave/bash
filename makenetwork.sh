#! /bin/bash
# dave@networkdave.com
#
# Use "bash -x compare.sh" for debugging if desired
echo -e "\nThis script will iterate through a list of networks, creating each in NIOS.\n"
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
echo -e "\nEnter the file name that contains the networks you wish to create:\n"
read FILE
# Take network view name and put in $VIEW
echo -e "\nWhat network view do you want the networks created in:\n"
read VIEW
# Loop through the file, creating each in NIOS
cat $FILE | 
while read LINE
do
	echo -e "\nCreating networks...\n"
	curl -k1 -u $USER:$PW -X POST https://"$GM"/wapi/v1.7.3/network -d network="$LINE" -d network_view="$VIEW" 
done