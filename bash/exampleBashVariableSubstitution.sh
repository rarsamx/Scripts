#!/bin/bash
#
# Sample parameter substitutions
# https://tldp.org/LDP/abs/html/parameter-substitution.html
#
# Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0


TST1="/some/thing.xx/else.txt"
echo "TST1="${TST1}

echo "If var not assigned use alt value. Should print '/some/thing.xx/else.txt' followed by changed"
echo ${TST1:-changed}
echo ${TST2:-changed}

unset TST2
echo "If var not assigned, assign alt value. Should print 'variableSet', and TST2 should be set to that value"
echo ${TST2:=variableSet}
echo "TST2="${TST2}

echo "If var assigned use alt value. Should print alt_value"
echo ${TST1:+alt_value} 
echo "TST1="${TST1}

unset TST2
echo "If var not assigned return null. Shouldn't print anything"
echo ${TST2:+alt_value}

echo "Give the lengt of a variable, Should be 23"
echo "Lenght of TST1="${#TST1}

echo "Remove up to the first dot. Should print xx/else.txt"
echo ${TST1#*.}

echo "Remove up to the last dot. Should print txt"
echo ${TST1##*.}

echo "Remove from the last dot on. Should print /some/thing.xx/else"
echo ${TST1%.*}

echo "Remove from the first dot on. Should print /some/thing"
echo ${TST1%%.*}

echo "Extract a substring starting at a position. Should print ing.xx/else.txt"
echo ${TST1:8}

echo "Extract a substring. Should print e/thing"
echo ${TST1:4:7}

echo "Replace a portion of the variable. Should print /some/fuss.xx/else.txt"
echo ${TST1/th?ng/fuss}

echo "Replace all occurrences of a pattern. Should print /tome/thing.xx.elte.txt"
echo ${TST1//s/t}

echo "Replace the prefix. Should print fuss/thing.xx/else.txt" 
echo ${TST1/#\/some/fuss}

echo "Replace the sufix. Should print /some/thing.xx/elton" 
echo ${TST1/%se.txt/ton}

TST2=
echo "Expand to the name of the variables beginning with the prefix"
echo ${!TST*}


unset TST2
echo "The following line should be an error line and end the script"
: ${TST2?"is undefined, ending script"}
