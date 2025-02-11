#!/bin/bash

# load arguements to variable

fname=$1
todebug=$2

# Creates log directory if it does not exsisits

compileErr="log/compileTimeErr.txt"
linkErr="log/linkingTImeErr.txt"
runErr="log/runTimeErr.txt"

if [[ ! -d "log" ]]; then
  mkdir log
  touch $compileErr
  touch $linkErr
  touch $runErr
fi

# command to compile the program and outputs the error to a log file

nasm -f elf -o "$fname".o "$fname".s 2>$compileErr

# checks if object file has been created or not

if [[ ! -f ./$fname.o ]]; then

  bat $compileErr
  exit 0

else

  # links the object file

  ld -m elf_i386 -o "$fname" "$fname".o 2>$linkErr

  #checks if executeable has been made or not

  if [[ ! -f ./$fname ]]; then

    bat $linkErr
    exit 0

  else
    # running the executeable
    echo Output of the program:
    ./"$fname"
    exitCode=$?
    echo exit code of program is $exitCode
    sleep 1

    # debugger section
    if [[ $todebug == 'y' ]]; then
      gdb "$fname" -x commands.gdb
    else
      exit 0
    fi
  fi
fi
