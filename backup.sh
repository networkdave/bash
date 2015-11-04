#! /bin/bash
# dave@networkdave.com
#
# Use "bash -x compare.sh" for debugging if desired
echo -e "\nThis script will conduct Grid backups appended with a time stamp and comment.\n"
echo -e "\nCtrl + C to escape the script, it will loop until escaped.\n"
# $GM to be used in the Curl commands
echo -e "\nEnter the Grid Master address:\n"
read GM
# $USER to be used in Curl authentication
echo -e "\nEnter your NIOS username:\n"
read USER
# $PW to be used in Curl authentication, won't be echo'd into the terminal when typed
echo -e "\nEnter your NIOS password:\n"
read -s PW
# Script will loop until the user escapes the script, intended to be left up throughout the day of a migration
I=1
while [ $I -le 1000 ]
do
# $COMMENT and $NOW will be combined into the backup name
echo -e "\nEnter a short description of this backup, use A-Z, 1-9, and underscores only\n"
read COMMENT
NOW=`date +%j%I%M%S`
BAK="$NOW"_"$COMMENT.bak"
#
echo -e "\nConnecting to the Grid Master on address: $GM...\n"
# Curl logs into GM, requests backup, response is posted to response.txt
curl -k1 -u $USER:$PW -X POST 'https://'"$GM"'/wapi/v1.7.3/fileop?_function=getgriddata' -H "Content-Type: application/json" -d '{"type": "BACKUP"}' -# > response.txt
# The file token is saved to $TOKEN, to be used in the download complete message
TOKEN=`cut -f 4 -d '"' response.txt | grep -v } | grep -v { | head -n 1`
# The download URL is saved to $URL
URL=`cut -f 4 -d '"' response.txt | grep -v } | grep -v { | tail -n 1`
# Curl downloads the backup
echo -e "\nDownloading from: $URL\n"
curl -k1 -u $USER:$PW -H "Content-type:application/force-download" -O "{$URL}" -#
#
echo -e "\nYour backup is located at $BAK\n"
#
echo -e "\nCleaning up...\n"
# Curl lets the GM know the download is compelete
curl -k1 -u $USER:$PW -X POST 'https://'"$GM"'/wapi/v1.7.3/fileop?_function=downloadcomplete' -H "Content-Type: application/json" -d '{ "token": "'"$TOKEN"'"}' -#
# Save the backup using $BAK from above
cp database.bak $BAK
# Clean up the script files, comment out if you wish to retain
rm database.bak
rm response.txt
echo -e "\nCtrl + C to escape\n"
I=$(($I + 1))
done