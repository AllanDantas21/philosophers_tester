#!/bin/bash

## COLORS
GREEN="\033[32m"
RESET="\033[0m"
YELLOW="\033[33m"
RED="\033[31m"
BLINK="\033[5m"

run_header() {
	echo -e ${GREEN}" / ***************************************** \ "
	echo -e ${GREEN}" *           Philosophers Tester             * "
	echo -e ${GREEN}" *                              by: aldantas * "
	echo -e ${GREEN}" \ ***************************************** / " ${RESET}
}

#NOME DO EXECUTAVEL
BIN_PATH=./philo

## PATH VARS
SCRIPT_DIR=$(dirname "$0")
MAKEFILE_PATH="$SCRIPT_DIR"

## TEST PARAMETERS - CHANGE AS NEEDED
NB_OF_TESTS=1
RESULTS_FOLDER='results'

## FUNÇAO
run_test_case() {
    CASE_NO=$1
    CASE=$2
    EXPECTED_OUTCOME=$3
    FONT_COLOUR_BG=''
    DIED_FLAG=''

    i=1
    time=0.1

    if [[ $EXPECTED_OUTCOME == "should die" ]]; then
        COLOUR_BG="\e[1;31mTest:"
        FONT_COLOUR_BG="\e[41;30m"
	D_FLAG="TRUE"
    else
        COLOUR_BG="\e[1;32mTest:"
        FONT_COLOUR_BG="\e[42;30m"
	D_FLAG="FALSE"
    fi

    mkdir -p "$RESULTS_FOLDER/$CASE_NO"
    echo -e "$FONT_COLOUR_BG $CASE_NO: $CASE $EXPECTED_OUTCOME       \e[0m"
    while [ $i -le $NB_OF_TESTS ]; do
        echo -e "$COLOUR_BG $i\e[0m"
        echo -e "${BLINK} ${YELLOW}Testing ${RESET}"
        $BIN_PATH $CASE > "$RESULTS_FOLDER/$CASE_NO/test$i"

        die_count=$(grep -c 'die' "$RESULTS_FOLDER/$CASE_NO/test$i")

        if [ "$D_FLAG" == "TRUE" ] && [ "$die_count" -eq 1 ]; then
            echo -e "${GREEN}✅ Success: One philosopher died as expected.${RESET}"
   	elif [ "$D_FLAG" == "TRUE" ]; then
            echo -e "${RED}❌ Failure: No philosopher died. (${die_count}).${RESET}"
        fi

	if [ "$D_FLAG" == "FALSE" ] && [ "$die_count" -eq 0 ]; then
            echo -e "${GREEN}✅ Success: No philosopher died.${RESET}"
    	elif [ "$D_FLAG" == "FALSE" ]; then
            echo -e "${RED}❌ Failure: One philosopher died (${die_count}).${RESET}"
        fi

        sleep $time
        i=$((i + 1))
    done
    echo
}

## RUN SCRIPT
make -C $MAKEFILE_PATH && clear
run_header
mkdir -p $RESULTS_FOLDER

if   [ "$1" = "c" ] || [ "$1" = "C" ]; then
	rm -rf $RESULTS_FOLDER
elif [ "$1" = "M" ] || [ "$1" = "m" ]; then
	run_test_case "Mandatory_01" "1 800 200 200" "should die"
	run_test_case "Mandatory_02" "4 310 200 100" "should die"
	run_test_case "Mandatory_03" "5 800 200 200 7" "not die"
	run_test_case "Mandatory_04" "5 800 200 200 25" "not die"
	run_test_case "Mandatory_05" "4 410 200 200 25" "not die"
else
	run_test_case "case_01" "1 400 100 100 7" "should die"
	run_test_case "case_02" "1 800 200 200 7" "should die"
	run_test_case "case_03" "2 100 200 200" "should die"
	run_test_case "case_04" "2 150 200 100" "should die"
	run_test_case "case_05" "2 150 360 100" "should die"
	run_test_case "case_06" "3 200 100 100 7" "should die"
	run_test_case "case_07" "4 310 200 100 7" "should die"
	run_test_case "case_08" "4 399 200 200 7" "should die"
	run_test_case "case_09" "5 200 100 100 7" "should die"
	run_test_case "case_10" "3 400 100 100 7" "not die"
	run_test_case "case_11" "4 210 100 100 7" "not die"
	run_test_case "case_12" "4 410 200 200 7" "not die"
	run_test_case "case_13" "5 400 100 100 7" "not die"
	run_test_case "case_14" "5 800 200 200 7" "not die"
fi

make -C $MAKEFILE_PATH fclean
