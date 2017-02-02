#!/bin/bash

function defKeySpace() {
	# Expects $upper, $lower, $number, $special, $combined
	upper="A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
	lower="a b c d e f g h i j k l m n o p q r s t u v w x y z"
	number="0 1 2 3 4 5 6 7 8 9"
	special="@ ! # % ^ & ( ) _ - + = } { [ ] | \ / ? > < . ,"
	combined="$upper $lower $number $special"
	alphanum="$upper $lower $number"
	toReturn=$1
    if [ -n "$toReturn" ]; then 
    	echo -e "$toReturn"
    fi
}

function randomCharacterFromKeySpace() {
	X=$(defKeySpace "$combined" | tr ' ' '\n' | sort -R)
	length=$(echo -e "$X" | wc -l)
	num=$((RANDOM%$length+1))
	echo -e "$X" | sed $num"q;d"
}

function buildRandomSets() {
	for i in $(seq 1 $1); do
		b+=" `randomCharacterFromKeySpace` "
	done
	echo "$b"
}


function buildCodeForLength() {
	for i in $(seq 1 $1); do  # each character here causes an exponential slow down as well as theoretically  
		a+="::: `buildRandomSets $sets`  "   # a greater chance of randomness
	done # for a 5 character password you're really generating 5 sets of random X characters and calculating all of the
	echo "$a" # possible outcomes of those sets (e.g. 1 2 ::: c d would return 1 c|1 d|2 c|2 d but not 1 2)
}

function passwordGeneration() {
	code=$(buildCodeForLength $length)
	code="parallel -j $threads echo $code"
	#echo $code
	password=$(`echo -e "$code"` | tr -d ' ')
	echo -e "$password"
}
function displayHelp() {
	cat << helpcontent
$0 --length=[option] --threads=[option] --sets=[option] --num=[option]
	-l |--length	the length of the password to generate (default 7)
	-s |--sets		the number of sets to use (WARNING: SLOW) (default 1)
					WARNING: Using sets with large passowrds can take a long time
	-n | --num		the number of passwords from the set to display (default 1)
	-t |--threads	the number of threads to use
	-h | --help     displays this page
helpcontent
exit 1
}

function argParse() {
	for i in "$@"; do
	case $i in
		-l=*|--length=*)
			length="${i#*=}"
			shift # past argument=value
             ;;
		-t=*|--threads=*)
    		threads="${i#*=}"
    		shift # past argument=value
    		;;
		-s=*|--sets=*)
    		sets="${i#*=}"
    		shift # past argument=value
    		;;
		-n=*|--num=*)
    		numPasswords="${i#*=}"
    		shift # past argument=value
    		;;
        -h|--help=*)
    		help=true
            shift # past argument=value
        	;;
    	*)
	       	help=true # unknown option
    		;;
	esac
	done
	if [ -z "$numPasswords" ]; then numPasswords=1; fi
	if [ -z "$threads" ]; then threads=2; fi
	if [ -z "$length" ]; then length=7; fi
	if [ -z "$sets" ]; then sets=1; fi
	if [ "$help" == true ]; then displayHelp; fi

	defKeySpace
	passwordGeneration $length | parallel -j $threads echo {} | shuf -n$numPasswords # Choose a random set
}


export -f defKeySpace
export -f randomCharacterFromKeySpace
export -f buildCodeForLength
export -f buildRandomSets
argParse "$@"