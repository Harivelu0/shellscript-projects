#!/bin/bash

cpu_num=$(nproc)
echo "cpu num": $cpu_num

mem_total=$(free -h | grep "Mem" |awk '{print $2}')
echo "memory total": $mem_total

mem_free=$(free -h | grep "Mem" |awk '{print $4}')
echo "memory free": $mem_free

disk_size=$(df -h / | grep "/" | awk '{print $2}')
echo "disk size: $disk_size"

system_bit=$(getconf LONG_BIT)
echo "system bit: $system_bit"

process_count=$(ps -e | wc -l)
echo "process: $process_count"
if command -v dpkg-query &> /dev/null; then
    sw_num=$(dpkg-query -f '${binary:Package}\n' -W | wc -l)
else
    sw_num=$(ls /usr/bin | wc -l)
fi
echo "software num: $sw_num"

ip_addr=$(hostname -I | awk '{print $1}')
echo "ip: $ip_addr"