#!/bin/bash
set -x

if [ -z $2 ];then
    echo "Usage: $0 <RCP_VERSION> <GCC_VERSION>"
    echo "eg. $0 RCP_BTS_15.37.0 gcc-4.8.5-distro-v1.10"
    exit 1
fi

RCP_VERSION=$1
GCC_VERSION=$2
RCP_HOME=/build/rcp
GNU_HOME=$RCP_HOME/gnu
GNU_REPO=https://svne1.access.nsn.com/isource/svnroot/ut_mrdxtTest/vrnc/gnu/
#RCP_HOME=/var/fpwork/guiljin/temp
cd $RCP_HOME

if [ -d $RCP_VERSION ];then
    echo "Error: Directory $RCP_VERSION already exist. Please remove it manually."
    exit 1
fi
mkdir $RCP_VERSION

source /opt/svn/linux64/ix86/svn_1.7.5/interface/startup/svn_1.7.5_64.env 1>/dev/null
if [ ! -d $GNU_HOME ];then
    mkdir -p $GNU_HOME
else
    for sub_dir in $(svn ls $GNU_REPO | grep '/$')
    do
        sub_dir_path=$GNU_HOME/$sub_dir
        if [ ! -d $sub_dir_path ];then
            svn co $GNU_REPO/$sub_dir $sub_dir_path
        fi
    done
fi

cd $RCP_VERSION

if [[ $RCP_VERSION =~ "RCP_COMMON_[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" ]];then
	RCP_FOLDER=rcp_cbts${RCP_VERSION:11:4}
else
	RCP_FOLDER=rcp_common
fi
# expect -c '
# set timeout 180
# spawn scp -r cbts@rcp.dynamic.nsn-net.net:/build/rcp/release/'$RCP_VERSION'/{ReleaseNotes.txt,*crosscompiler/*.tar*} .
# expect {
# "(yes/no)?" {send "yes\r"; exp_continue }
# "password:" {send "cbts\r" }
# }
# expect eof
# catch wait result
# exit [lindex $result 3]'

# expect -c '
# set timeout 180
# spawn scp -r cbts@rcp.dynamic.nsn-net.net:/build/rcp/release/'$RCP_VERSION'/images/{system-release,rcp_common_*.md5sum,rcp_common_*.qcow2} .
# expect {
# "(yes/no)?" {send "yes\r"; exp_continue }
# "password:" {send "cbts\r" }
# }
# expect eof
# catch wait result
# exit [lindex $result 3]'

for site in {10.56.118.71,halebopp.tre.noklab.net:8080}
do
	if [ ! -f ReleaseNotes.txt ];then
		wget -t 3 http://$site/pilivee/RCP/$RCP_FOLDER/release/$RCP_VERSION/ReleaseNotes.txt
	fi
	if [ ! -f system-release ];then
        	wget -t 3 http://$site/pilivee/RCP/$RCP_FOLDER/release/$RCP_VERSION/images/system-release
	fi
	if [ ! -f rcp_*-devel*.tar.[gx]z ];then
		wget -rc -nd -np -A 'rcp_common-devel*.tar.[gx]z' http://$site/pilivee/RCP/$RCP_FOLDER/release/$RCP_VERSION/cbts_crosscompiler/
	fi
	if [ ! -f rcp_common_*.qcow2 ];then
		wget -rc -nd -np -A rcp_common_r*.qcow2 http://$site/pilivee/RCP/$RCP_FOLDER/release/$RCP_VERSION/images/
	fi
	if [ ! -f rcp_common_*.md5sum ];then
		wget -rc -nd -np -A rcp_common_r*.md5sum http://$site/pilivee/RCP/$RCP_FOLDER/release/$RCP_VERSION/images/
	fi
	if [ ! -f rcp_swm_tool.tgz ];then
        	wget http://$site/pilivee/RCP/$RCP_FOLDER/release/$RCP_VERSION/tools/rcp_swm_tool.tgz
	fi
done


if [ -f rcp_*-devel*.tar.xz ];then
    xz -d rcp_*-devel*.tar.xz
    tar xf rcp_*-devel*.tar
fi

if [ -f rcp_*-devel*.tar.gz ];then
    tar xzf rcp_*-devel*.tar.gz
fi

#Redefine gcc version
if [ $RCP_FOLDER == "rcp_common" ];then
    GCC_VERSION="gcc-5.4.0-cross"
elif [ -f ReleaseNotes.txt ];then
    dos2unix ReleaseNotes.txt
    gcc_raw=$(sed -n 's#.*Distro version: \(v[^ ]\+\).*#\1#p' ReleaseNotes.txt)
    gcc_version=$(ls -1 $GNU_HOME | fgrep $gcc_raw | tail -1)   #use vgp version first
    if [ $gcc_version ];then
        GCC_VERSION=$gcc_version
        echo "Reset the gcc version to $GCC_VERSION from ReleaseNotes.txt"
    fi
elif [ -f system-release ];then
    dos2unix system-release
    gcc_raw=$(grep OS_DISTRO_VERSION system-release | cut -d= -f2)
    gcc_version=$(ls -1 $GNU_HOME | fgrep $gcc_raw | tail -1)
    if [ $gcc_version ];then
        GCC_VERSION=$gcc_version
        echo "Reset the gcc version to $GCC_VERSION from system-release"
    fi
fi
 
#sysroot_name=$(ls -d rcp_cbts-devel*sysroot)
ln -s rcp_*-devel*sysroot sys-root
if expr $GCC_VERSION : gcc-4\.9\.2;then
    ln -sf $RCP_HOME/$RCP_VERSION/sys-root/usr/lib64/libstdc++.so.6.0.20 $RCP_HOME/$RCP_VERSION/sys-root/usr/lib64/libstdc++.so
    ln -sf $RCP_HOME/$RCP_VERSION/sys-root/usr/lib64/libstdc++.so.6.0.20 $RCP_HOME/$RCP_VERSION/sys-root/usr/lib64/libstdc++.so.6
fi

ln -s ../gnu/$GCC_VERSION $GCC_VERSION

mkdir sdk
ln -s ../$GCC_VERSION/bin sdk/bin

#chmod -R 777 $RCP_HOME/$RCP_VERSION
tree -L 2 $RCP_HOME

## Usability testing
md5sum -c rcp_common_*.md5sum || (echo "Error: qcow2 image file md5 check failed." && exit 1)

for name in CCS_ENV Definitions MCUHWAPI_ENV Messages UPHWAPI_ENV #DSPHWAPI_ENV
do
    if [ ! -e $RCP_HOME/$RCP_VERSION/sys-root/opt/nokia/I_Interface/Platform_Env/$name ];then
        echo "Error: Missing Env $RCP_HOME/$RCP_VERSION/sys-root/opt/nokia/I_Interface/Platform_Env/$name"
        Platform_Env_Check=failed
    fi
done
if [ "_$Platform_Env_Check" == "_failed" ];then
    echo "Error: Platform_Env Check failed."
    exit 1
fi

echo "New RCP version $RCP_VERSION/$GCC_VERSION is ready now."
exit 0
