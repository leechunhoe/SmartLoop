#!/bin/bash

# SmartLoop
# Is a program to loop your music playlist smartly
# Created by Lee Chun Hoe 21.9.2015

cd;
metadata="Music/.metadata_magicplayer";

if [ ! -f $metadata ]; then
    touch $metadata
    echo "0" >> $metadata;
    echo "0" >> $metadata;
fi

i=0;

while read name
do
	if [ "$i" -eq "0" ]
	then
		cycle="$name";
	elif [ "$i" -eq "1" ]
	then
		order="$name";
	fi
	let "i++";
done < $metadata

musicFiles=(~/Music/*.{mp3,wav});
musicFilesSize=${#musicFiles[@]}; 

loopSize=10;

while true
do
	if [ "$order" -eq "$(($loopSize + 1))" ]
	then
		let "order=0";
		let "cycle++";
	fi

	let "orderInArray=$cycle+$order";

	if [ "$orderInArray" -ge "$musicFilesSize" ]
	then
		let "orderInArray=$orderInArray-$musicFilesSize";
	fi

	echo "$orderInArray : ${musicFiles[$orderInArray]}";
	afplay "${musicFiles[$orderInArray]}";
	let "order++";

	echo "$cycle" > $metadata;
    echo "$order" >> $metadata;
done
