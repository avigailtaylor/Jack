#!/bin/bash

A=3
B=5
C=7

echo "monkey $A $B $C" | awk -F' ' '{printf "%s %.2f %.1f\n" , $1, $2/$3, $3/$4 }'
