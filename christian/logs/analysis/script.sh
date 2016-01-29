#!/bin/bash

INPUT="$1"

cd "analysis"
mkdir "$INPUT"
tshark -r "../$INPUT" -2R 'usb.data_len == 18 && usb.transfer_type == 0x01 && usb.endpoint_number == 0x81' -T fields -e usb.capdata >"$INPUT/cap-data"
cd "$INPUT"
cat cap-data | sed 's/^02://' | sed 's/:00:00:00:00:00:00:00:00:00:00:00//' >six-bytes
cat six-bytes | sed '$!N; /^\(.*\)\n\1$/!P; D' >six-bytes-unique
cat six-bytes | grep -v c3:00:61:80:00:22 >six-bytes-active

