#!/bin/bash

echo "===== FOR LOOP EXAMPLES ====="
echo "Basic for loop:"
for fruit in apple banana orange grape
do
    echo "- $fruit"
done

echo -e "\nNumeric range loop:"
for num in {1..5}
do
    echo "Number: $num"
done

echo -e "\nC-style for loop:"
for ((i=0; i<3; i++))
do
    echo "Index: $i"
done

echo -e "\n===== WHILE LOOP EXAMPLES ====="
echo "Simple counter:"
count=1
while [ $count -le 3 ]
do
    echo "Count: $count"
    ((count++))
done

echo -e "\nFile processing example (create a temp file):"
echo "line 1" > temp_file.txt
echo "line 2" >> temp_file.txt
echo "line 3" >> temp_file.txt

echo "Reading file line by line:"
while read line
do
    echo "> $line"
done < temp_file.txt

echo -e "\n===== UNTIL LOOP EXAMPLE ====="
value=5
until [ $value -le 0 ]
do
    echo "Counting down: $value"
    ((value--))
done

echo -e "\n===== BREAK AND CONTINUE EXAMPLES ====="
echo "Break example:"
for number in {1..10}
do
    if [ $number -eq 6 ]
    then
        echo "Found 6 - breaking out!"
        break
    fi
    echo "Number: $number"
done

echo -e "\nContinue example:"
for number in {1..5}
do
    if [ $number -eq 3 ]
    then
        echo "Skipping 3..."
        continue
    fi
    echo "Processing: $number"
done

echo -e "\n===== NESTED LOOPS EXAMPLE ====="
for i in {1..3}
do
    echo "Outer loop: $i"
    for j in {A..C}
    do
        echo "  Inner loop: $j"
    done
done

# Clean up
rm temp_file.txt
echo -e "\nExamples complete!"