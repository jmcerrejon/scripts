#!/bin/bash
#
# Description: Remove comments in files from current directory recursively.
#
# Note: only js and html and excluding /widgets dir. Preserve the original modif. and access timestamp:
# The next regex delete (separated by ;):
# s/\/\/.*// - Comments on .js 
# /^$/d - blank lines
# s/<!--.*// - Comments on .html
#
if [ "$1" != "" ]; then
    find $1 -type f ! -path "./widgets/*" -regex ".*\.\(js\|html\)" | while read file; do
        ORIG_DATE=$(stat -c %y $file)
        sed -i 's/[^:]\/\/.*//;s/^\/\/.*//;s/<!--.*//;/^$/d' $file
        touch -d "${ORIG_DATE}" $file
    done
    echo "Done!"
else
    echo -e "Please, you must specify a directory. Example: $0 project_dir/\n"
fi
