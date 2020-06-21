#!/bin/bash

if [ -z "$1" ]
then
        echo "Usage: ./recon.sh <IP>"
        exit 1
fi

printf "\n----- NMAP -----\n\n" > results

echo "Running Nmap..."
nmap $1 | tail -n +5 | head -n -3 >> results

while read line
do
        if [[ $line == *open* ]] && [[ $line == *http* ]]
        then
                echo "Running Gobuster..."
                gobuster dir -u $1 -w /usr/share/wordlists/dirb/common.txt -qz > oxds1

        echo "Running WhatWeb..."
        whatweb $1 -v > oxds2
        fi
done < results

if [ -e oxds1 ]
then
        printf "\n----- DIRS -----\n\n" >> results
        cat oxds1 >> results
        rm oxds1
fi

if [ -e oxds2 ]
then
    printf "\n----- WEB -----\n\n" >> results
        cat oxds2 >> results
        rm oxds2
fi

cat results
