#! /bin/bash
# dave@networkdave.com
now=`date +%j%I%M%S`
#
echo -e "\nThis script will conduct Grid backups appended with a time stamp and comment.\n"
# $gm to be used in the Curl commands
echo -e "\nEnter the Grid Master address:\n"
read gm
# $user to be used in Curl authentication
echo -e "\nEnter your NIOS username:\n"
read user
# $pw to be used in Curl authentication
echo -e "\nEnter your NIOS password:\n"
read pw
# $comment and $now will be combined into the backup name
echo -e "\nEnter a short description of this backup, use A-Z, 1-9, and underscores only\n"
read comment
#
echo -e "\nConnecting to the Grid Master on address: $gm...\n"
# Curl logs into GM, requests backup, response is posted to response.txt
curl -k1 -u $user:$pw -X POST 'https://'"$gm"'/wapi/v1.7.3/fileop?_function=getgriddata' -H "Content-Type: application/json" -d '{"type": "BACKUP"}' -# > response.txt
# The file token is saved to $token, to be used in the download complete message
token=`cut -f 4 -d '"' response.txt | grep -v } | grep -v { | head -n 1`
# The download URL is saved to $url
url=`cut -f 4 -d '"' response.txt | grep -v } | grep -v { | tail -n 1`
# Curl downloads the backup
echo -e "\nDownloading from: $url\n"
curl -k1 -u $user:$pw -H "Content-type:application/force-download" -O '"$url"' -#
#
echo -e "\nYour backup is located at $bak\n"
#
echo -e "\nCleaning up...\n"
# Curl lets the GM know the download is compelete
curl -k1 -u $user:$pw -X POST 'https://'"$gm"'/wapi/v1.7.3/fileop?_function=downloadcomplete' -H "Content-Type: application/json" -d '{ "token": '"$token"'}' -#
# Save the backup using $now and $comment
bak="$now"_"$comment.bak"
#cp backup.bak $bak
# Clean up the logistic files
#rm backup.bak
#rm response.txt