#!/bin/bash

# Make sure random usage patterns can't be determined.

echo "Using haveged to write random data to the drive..."
haveged -n 32G -o tba8c -f - > /dev/sda
echo "Shredding contents of drive with one iteration..."
shred --verbose --random-source=/dev/urandom --iterations=3 /dev/sda
echo "Write some zeros to make life more complicated..."
dd if=/dev/zero of=/dev/sda
echo "Might seem pointless but this pass makes forensic patter analysis even more difficult..." 
haveged -n 32G -o tba8c -f - > /dev/sda
exit 0
