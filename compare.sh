#! /bin/bash
# dave@networkdave.com
#
# Declare some variables for file names, so I can change them later if I feel like it
before="output1.txt"
before_clean="output1-1.txt"
after="output2.txt"
after_clean="output2-1.txt"
# Add today's Julian date, hour, minute, and second appended the results file
now=`date +%j%I%M%S`
results="results_$now.txt"
#
echo -e "\nThis script will conduct a zone transfer against a zone list file, wait for user input, and then conduct another zone transfer again the same list. It will then compare the two files for differences, outputing these results to $results\n"
echo -e "\nCtrl + Z to escape the script\n"
# Zone list file name goes to $zl
echo -e "\nEnter the zone list file name:\n"
read zl
# Server IP/name goes to $server
echo -e "\nEnter the server to be queried:\n"
read server
# Loop through each line of the zone list, querying each zone, and append the results to $before
cat $zl |
while read line
do
	echo "dig @$server axfr +multiline $line..."
	dig @$server $line axfr +multiline >> $before
done
# Sort $before, remove unneeded lines, save to $before_clean
sort $before | grep -v \; | grep -v "^$" | grep -v ")" > $before_clean
# Wait for user input to repeat the queries
echo -e "\nPress [Enter] key to repeat the zone transfer after making some change to the data. After the second zone transfer job completes, a comparison will be made and dropped into $results"
read
# Loop through each line of the zone list, querying each zone, and append the results to $after
cat $zl |
while read line
do
	echo "dig @$server axfr +multiline $line..."
	dig @$server $line axfr +multiline >> $after
done
# Sort $after, remove unneeded lines, save to $after_clean
sort $after | grep -v \; | grep -v "^$" | grep -v ")" > $after_clean
# Compare the sorted and cleaned up output files, saves to $results 
echo `diff $before_clean $after_clean` | tr '<' '\n' > $results
#
echo -e "\nCheck $results (a blank file indicate no difference between AXFR batches)\n"
# Comment out the lines below if you wish to retain the AXFR files
rm $before 
rm $before_clean
rm $after
rm $after_clean
