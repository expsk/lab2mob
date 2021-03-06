#!/bin/sh
if [ "--help" = "$1" ]
	then
	echo "weather [options]"
	echo "current weather in Minsk"
	echo "messages timeout was set in config.ini"
	echo "options:"
	echo "\t--help,\tshow help"
else
	timeout=$(sed -n 's/.*interval *= *\([^ ]*.*\)/\1/p' < ./config.ini)
	if ping -c1 informer.gismeteo.ru > /dev/null
		then
		rm -rf ./temp
		mkdir ./temp
		cd temp
		while true
			do
			rm -rf 26850.xml
			wget --no-proxy -q informer.gismeteo.ru/rss/26850.xml

			TIME=`cat ./26850.xml | grep -m1 "Минск:" | tail -n 1`
			TIME=$(echo $TIME | sed 's/<title>//')
			TIME=$(echo $TIME | sed 's/<\/title>//')
			WEATHER=`cat ./26850.xml | grep -m1 -A2 "Минск:" | tail -n 1`
			WEATHER=$(echo $WEATHER | sed 's/<description>//')
			WEATHER=$(echo $WEATHER | sed 's/<\/description>//')
			echo "$TIME"
			echo "$WEATHER"
			echo "---------------------------------------------------------"

			sleep $timeout
		done
	else
		echo "Connection problem"
	fi
fi
return 0
