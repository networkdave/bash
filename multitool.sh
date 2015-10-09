#! /bin/bash
# dave@networkdave.com
#
# User chooses function
echo -e "\nWhat would you like to do?"
echo -e "----------------------------\n"
echo -e "Create networks - 1"
echo -e "Create zones - 2"
read OPTION
# Follow the user choice
case $OPTION in
	1) 
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
			echo -e "\nCreating network $LINE..."
			curl -k1 -u $USER:$PW -X POST https://"$GM"/wapi/v1.7.3/network -d network="$LINE" -d network_view="$VIEW"
		done
	;;
	2) 
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
			echo -e "\nCreating zone $LINE..."
			curl -k1 -u $USER:$PW -X POST https://"$GM"/wapi/v1.7.3/zone_auth -d fqdn="$LINE" -d view="$VIEW"
		done
	;;
	*) 
		echo -e "\nYou didn't pick a valid option";;
esac