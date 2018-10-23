#!/usr/bin/env bash

alias ll='ls -lh --color=auto'
alias setsee='. /opt/EE_LinSEE/bin/seesetenv WBTS-CB-BASE_0.1; . /opt/EE_LinSEE/bin/seesetenv WBTS-CB-MINIMAL_0.1'

txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Rese

function set-proxy-out {
    export http_proxy=http://87.254.212.120:8080/
    export ftp_proxy=ftp://87.254.212.120:8080/
    export https_proxy=https://87.254.212.120:8080/
    export no_proxy="localhost,127.0.0.1,.nsn-net.net,.nsn-intra.net,.nokiasiemensnetworks.com,.nokia.com"
    echo -e "\nProxy environment variable set."
}

function unset-proxy-out {
    unset http_proxy
    unset ftp_proxy
    unset https_proxy
    unset no_proxy
    echo -e "\nProxy environment variable removed."
}

function source_prod_tools {
   source ~/tools/env/bin/activate
}

function bknife {
    WBTS=$(basename $PWD)
    [ -n "$1" ] && suffix=$1 || suffix=T0
    REL=${WBTS/00_env/$suffix}
    CODE=KNIF$(date +%m%d)
    echo -e "$bldred$REL$txtrst" && sleep 3
    make -j 1 FSMD REL=$REL CODE=$CODE
    make TBD RND REL=$REL CODE=$CODE
    cp D_Build/Release/WBTS/$REL.zip /mnt/ROTTA/HetRAN/WCDMA_CB/knives/
    echo -e "$bldred"
    echo "Knife is ready at:"
    echo '\\eseefsn50.emea.nsn-net.net\rotta4internal\HetRAN\WCDMA_CB\knives\'$REL'.zip'
    echo -e "$txtrst"
}
