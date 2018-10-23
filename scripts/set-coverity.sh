#!/bin/bash

COVPATH=/ephemeral/COV
INSTALLDIR=$COVPATH/cov-analysis-linux64-2017.SP1

[[ ! -d $COVPATH ]] && mkdir $COVPATH
cd $COVPATH
wget http://coverityci.es-si-s3-z4.eecloud.nsn-net.net/cov-analysis-linux64-2017.07-SP1.sh -O cov-analysis-linux64-2017.07-SP1.sh
wget http://coverityci.es-si-s3-z4.eecloud.nsn-net.net/license.dat
chmod +x ./cov-analysis-linux64-2017.07-SP1.sh
./cov-analysis-linux64-2017.07-SP1.sh -q \
-dir $INSTALLDIR \
-VlicenseChoice=0 -Vlicense.region=5 -Vlicense.agreement=i.agree.to.the.license \
-Vlicense.dat=$COVPATH/license.dat \
-Vfor.desktop=false -Vcomponent.sa-da=true -Vcomponent.sdk=true

echo 'export PATH=$PATH:'$INSTALLDIR'/bin' >> ~/.bash_profile
source ~/.bash_profile 
