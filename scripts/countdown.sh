#!/bin/bash

date_at_birth=$(($(date --utc --date "1989-10-16T23:30:00" +%s)/86400))
today=$(($(date --utc +%s)/86400))
life_expectancy_in_days=$((75*365))
days_left=$(($life_expectancy_in_days - $today + $date_at_birth));
years_left=$(($days_left / 365))

echo "####################################"
echo "####################################"

echo "######## days left to live #########"
echo "############   $days_left   #############"

echo "####################################"

echo "That is  $years_left years and $(($days_left % 365)) days left."   

echo "####################################"
echo "#####  DON'T WASTE YOUR TIME!  #####"
echo "####################################"
echo "####################################"
