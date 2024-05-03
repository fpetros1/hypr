#!/bin/bash

TARGET="$1"
OUTPUT=0

if [[ "$@" == *"-p"* ]]; then
	OUTPUT=1
fi

echo_created() {
	if [[ $OUTPUT -eq 1 ]]; then
		echo "$@" 
	fi
}

if [[ $TARGET == *\/ ]]; then
	mkdir -p "$TARGET"
	echo_created "$TARGET"
	cd "$TARGET"
else
	DIRECTORY=$(dirname "$TARGET")
	mkdir -p "$DIRECTORY"
	touch "$TARGET"
	echo_created "$DIRECTORY"
	cd "$DIRECTORY"
fi


