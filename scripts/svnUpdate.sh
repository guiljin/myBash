#!/bin/bash

help(){
echo "Usage: $0 && $0 <Revision> && $0 -r <Revision>"
}

Rev=HEAD
while [ -n "$1" ];do
    case $1 in
        -r|-R) shift; Rev=$1; break;;
        [0-9]*) Rev=$1; break;;
        *) help; exit 1; break;;
    esac
done

if [ $Rev != "HEAD" ] && [ $Rev -lt 60549 ];then
    echo "Can't use $0 for revision before $Rev"
    help
    exit 1
fi

echo -e "\033[31;2mUpdating svn code to revision: $Rev\033[0m"

set -e
svn pg -r $Rev svn:externals . | tee external.tmp
sed -i.bak 's!^/isource/svnroot/.*/tags/.*!#&!' external.tmp
svn ps svn:externals . -F external.tmp
svn up -r $Rev --accept mine-full .
./dsp.sh update_ext
svn revert .

echo -e "\033[31;2mDone. Please use $0 to take place of svn update afterwards.\033[0m"
