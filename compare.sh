#! /bin/bash
echo -e "\nThis script will conduct a zone transfer against a zone list file, wait for user input, and then conduct another zone transfer again the same list. It will then compare the two files for differences, outputing these results to results.txt\n"
#
echo -e "\nCtrl + Z to escape the script\n"
# Zone list file name goes to $zl
echo -e "\nEnter the zone list file name:\n"
read zl
# Server IP/name goes to $server
echo -e "\nEnter the server to be queried:\n"
read server
# Loop through each line of the zone list, querying each zone, and append the results to output1.txt
cat $zl |
while read line
do
	echo "dig @$server axfr +multiline $line..."
	dig @$server $line axfr +multiline >> output1.txt
done
# Sort the result of output1.txt, remove any line starting with ; or blank lines, save to output1-1.txt
sort output1.txt | grep -v \; | grep -v "^$" | grep -v ")" > output1-1.txt
# Wait for user input to repeat the queries
echo -e "\nPress [Enter] key to repeat the zone transfer after making some change to the data. After the second zone transfer job completes, a comparison will be made and dropped into results.txt"
read
# Loop through each line of the zone list, querying each zone, and append the results to output2.txt
cat $zl |
while read line
do
	echo "dig @$server axfr +multiline $line..."
	dig @$server $line axfr +multiline >> output2.txt
done
# Sort the result of output1.txt, remove any line starting with ; or blank lines, save to output2-1.txt
sort output2.txt | grep -v \; | grep -v "^$" | grep -v ")" > output2-1.txt
# Compare the sorted and cleaned up output files, save to results.txt
echo `comm -3 output1-1.txt output2-1.txt` > results.txt
#
echo "Check results.txt"
# Comment out the lines below if you wish to retain the AXFR files
rm output1.txt 
rm output1-1.txt
rm output2.txt
rm output2-1.txt