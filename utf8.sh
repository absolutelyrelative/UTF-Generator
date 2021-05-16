#!/bin/bash
usage() { echo "Usage: utf8.sh [-s {0,...,6}] [-v [0,1]] "; exit; }

DO_ALL=1	#Perform all calculations, disable with -s NUM={0,...,6}
PRINT_RESULT=1	#Print non-necessary output, disable with -v 0, enable with -v 1

#ARGUMENT CHECK
while getopts s:v: opts; do
	case ${opts} in
		s) WHICH_PRINT=${OPTARG}
		if [ $WHICH_PRINT -gt 6 ]
		then
			usage
		fi
		if [ $WHICH_PRINT -lt 0 ]
		then
			usage
		fi
		;;
		v) PRINT_RESULT=${OPTARG}
		if [ $PRINT_RESULT -gt 1 ]
		then
			usage
		fi
		if [ $PRINT_RESULT -lt 0 ]
		then
			usage
		fi
		;;
		*)
		usage
		;;
	esac
done

if [ "$(uname)" == Linux ] #Should probably work on Darwin / MacOS too
#BEGIN PRINTING
then
	#1 BYTE
	#Primo Byte - (0XXX XXXX -> 0111 1111)
	for((ctr1=0; ctr1 < 127 + 1; ctr1++))
	do
		B_1=$(echo "ibase=10; obase=16; $ctr1" | bc)

		if [ $PRINT_RESULT == 1 ]
		then
			echo Char \#$B_1 - UTF-8 Byte 1:
		fi
		printf "\x$B_1 \n"
	done

	#2 BYTE
	#Primo Byte - (110X XXXX -> 1101 1111)
	for((ctr1=192; ctr1 < 223 + 1; ctr1++))
	do
		#Secondo Byte - (10XX XXXX -> 1011 1111)
		for((ctr2=128; ctr2 < 191 + 1; ctr2++))
		do
			B_1=$(echo "ibase=10; obase=16; $ctr1" | bc)
			B_2=$(echo "ibase=10; obase=16; $ctr2" | bc)
			if [ $PRINT_RESULT == 1 ]
			then
				echo Char \#$B_1 \#$B_2 - UTF-8 Byte 2:
			fi
			printf "\x$B_1\x$B_2 \n"
		done
	done

	#3 BYTE
	#Primo Byte - (1110 XXXX -> 1110 1111)
	for ((ctr1=224; ctr1 < 239 + 1; ctr1++))
	do
		#Secondo Byte - (10XX XXXX -> 1011 1111)
		for((ctr2=128; ctr2 < 191 + 1; ctr2++))
		do
			#Terzo Byte - (10XX XXXX -> 1011 1111)
			for((ctr3=128; ctr3 < 191 + 1; ctr3++))
			do
				B_1=$(echo "ibase=10; obase=16; $ctr1" | bc)
				B_2=$(echo "ibase=10; obase=16; $ctr2" | bc)
				B_3=$(echo "ibase=10; obase=16; $ctr3" | bc)
				if [ $PRINT_RESULT == 1 ]
				then
					echo Char \#$B_1 \#$B_2 \#$B_3 - UTF-8 Byte 3:
				fi
				printf "\x$B_1\x$B_2\x$B_3 \n"
			done
		done
	done
else
	echo "Oops"
fi
