#!/bin/bash
find . -type f ! -path "./widgets/*" -regex ".*\.\(js\|html\)" | while read file; do
        ORIG_DATE=$(stat $file | grep ^Mod | awk '{print $2,$3,$4}')
        sed -i 's/\/\/.*//;/^$/d;s/<!--.*//' $file
        touch -d "${ORIG_DATE}" $file
done

