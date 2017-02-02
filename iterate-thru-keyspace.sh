#!/bin/bash
# AUTHOR: Joey Stevens
# Description: Iterates thru every possible permutation of a keyspace using GNU parallel

export length=$1
export keyspace=$2
export threads=$3

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

function buildCodeToIterateThroughEntireKeySpace() {
	keyspace=$(defKeySpace "$keyspace")
	for i in $(seq 1 $length); do
		y+="::: $keyspace "
	done
	echo "$y"
}

function iterateThroughKeySpace() {
	y=$(buildCodeToIterateThroughEntireKeySpace)
	code="parallel -j $threads echo $y"
	`echo $code` | tr -d ' '
}

defKeySpace
case "$keyspace" in 
	combined)
		keyspace=$combined
		;;
	upper)
		keyspace=$upper
		;;
	lower)
		keyspace=$lower
		;;
	number)
		keyspace=$number
		;;
	special)
		keyspace=$special
		;;
	alphanum)
		keyspace=$alphanum

esac
export -f defKeySpace
export -f buildCodeToIterateThroughEntireKeySpace
export -f iterateThroughKeySpace

iterateThroughKeySpace | parallel -j $threads echo "Do something with the keyspace: {}"

