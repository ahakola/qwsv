#!/bin/sh

quakedir="/home/antti/equakesv"
process=`ps auxw | grep mvdsv | grep -v grep | awk '{print $11}'`

if [ -z "$process" ]; then

  echo "Couldn't find MVDSV running, restarting it."
  cd "$quakedir"
  ./mvdsv +gamedir fortress -d -ip 1.2.3.4 &
#  ./mvdsv +gamedir fortress -d &
  echo ""

fi

