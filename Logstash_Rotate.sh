#!/bin/bash

#Variables
#Logstash log directory - Default:/var/log/logstash
logDir="/var/log/logstash" 

#Read the contents of the directory specified above
if [ -d $logDir ]; then
	declare -a logFiles
	for file in $logDir/*.log; do
		if [ "$file" != "$logDir/logstash-plain.log" ]; then
			logFiles=(${logFiles[@]} $file)
		fi
	done
else
	#Show error message if the logDir is invalid
	echo "-----------Error: logDir Not Found-----------"
	echo "logDir = $logDir"
	echo -e "Please update the logDir variable in the script and try again\n"
	exit 1
fi

#Display the contents of the variable with the filenames
echo "-----------Logstash Log Rotate-----------"
if [ ${#logFiles} -gt 0 ]; then
	for item in "${logFiles[@]}"; do
		echo ${item:${#logDir}+1}
	done
else
	echo "No log files to rotate"
fi
echo "-----------------------------------------"

#Begin the log rotation process
if [ ${#logFiles} -gt 0 ]; then
	for file in "${logFiles[@]}"; do
		echo "Rotating ${file:${#logDir}+1}"
		tar -czvf ${file:0:-4}.tar.gz -C / ${file:1} && rm -f $file
		echo -e "\n"
	done
fi