#!/bin/bash
# Note: only js and html and excluding /widgets dir. Preserve the original modif. and access timestamp:
# The next regex delete (separated by ;):
# s/\/\/.*// - Comments on .js 
# /^$/d - blank lines
# s/<!--.*// - Comments on .html
#
find . -type f ! -path "./widgets/*" -regex ".*\.\(js\|html\)" | while read file; do
        ORIG_DATE=$(stat -c %z $file)
        sed -i 's/\/\/.*//;/^$/d;s/<!--.*//' $file
        touch -d "${ORIG_DATE}" $file
done

Echo "Done!"
