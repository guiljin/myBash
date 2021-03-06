# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

# User specific environment and startup programs
. /home/guiljin/bash_completion/etc/profile.d/bash_completion.sh

PATH=$PATH:$HOME/usr/colordiff-1.0.18/usr/local/bin:$HOME/pssh-1.4.3/bin

export PATH
export PS1="\[\e[35;1m\][\A \u@\h \W]\$\[\e[0m\]"

source /home/guiljin/scripts/functions.sh
source /home/hzbtsscm_c_cn/ENV/SCM_ENV
export SVN_EDITOR=vim
export GREP_OPTIONS='--color=auto'
export http_proxy=http://10.144.1.10:8080/
export https_proxy=https://10.144.1.10:8080/
export HISTSIZE=10000
export MANPATH=
export PYTHONSTARTUP=/home/guiljin/.pythonstartup
export AWS_ACCESS_KEY_ID=OSHA06WDOCOU0D_IP_V_
export AWS_SECRET_ACCESS_KEY=grx7Zw4HzMgsYmjlBilFZ1ZS2ztFwNxGFLNfvw==

alias h='history 20'
alias ll='ls -trl'
alias la='ls -Al'
alias cdh='cd /var/fpwork/guiljin'
alias mark='grep -C 10000'
alias svn_clean='svn st . | egrep "^\?" | cut -d\? -f2 | xargs rm -rf \{}'
alias svn_pe='svn pe svn:externals '
alias svn_pg='svn pg svn:externals '

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

svn_ls(){
V=${1/*isource/https://svne1.access.nsn.com/isource}
V=${V%/}
svn info $V &>/dev/null
if [ "$?" -ne 0 ]; then
    echo -e "$bakred[ERROR]: invalid svn url $txtrst"
    unset V
    return
fi
echo -e "$txtred${V/*isource/https://svne1.access.nsn.com/isource}"
echo -e "$txtgrn${V/*isource/https://beisop60.china.nsn-net.net/isource}"
echo -e "$txtylw${V/*isource/https://wrscmi.inside.nsn.com/isource}$txtrst"
svn ls -v $V
}

svn_stop_on_copy(){
[ -z "$V" ] && echo -e "${bakred}[ERROR]: run svn_ls first ${txtrst}" && return
[[ "$V" != *tag* ]] && echo -e "${bakred}[ERROR]: not a tag branch ${txtrst}" && return
from_line=$(svn log -v --stop-on-copy $V | sed -n '4p')
tag=$(echo $from_line | cut -d' ' -f2)
[ -n "$1" ] && suffix="/$1" || suffix=${V/*$tag/}
branch_raw=$(echo $from_line | cut -d' ' -f4 | tr -d ')')
branch=$(echo $branch_raw | cut -d: -f1)
revision=$(echo $branch_raw | cut -d: -f2)
echo
echo -e "${V/$tag/}${txtgrn}$tag${txtrst}$suffix"
echo -e "${V/$tag/}${txtylw}$branch${txtrst}$suffix${txtylw}@$revision"
echo
}

SVNROOT=https://svne1.access.nsn.com/isource/svnroot/
SVNPARAMS=' --no-auth-cache --non-interactive --trust-server-cert --username hzbtsscm_c_cn --password 8f2c2b5d'
BRANCHS=(   BTS_SC_DSP/branches/FZP_Trunk/                  #WZ9.1_0000
            BTS_SC_DSP/branches/development/FZP_Trunk_PSI/
            BTS_SC_DSP/branches/development/FZP_PreFlight
            BTS_SC_DSP/branches/p_nyquist/                  #WBTS_Trunk
            BTS_SC_DSP/branches/development/psi_nyquist/
            BTS_SC_DSP/branches/development/Nyquist_PRIT/   #WBTS16_7404
            BTS_SC_DSP/trunk/workarea/                      #WBTS_Trunk
            BTS_SC_DSP/branches/development/psi/
            BTS_SC_DSP/branches/WN9.1r3_1407/               #WN9.1_0000
            BTS_SC_DSP/branches/development//WN9.1r3_1407_PSI/
            BTS_SC_DSP/branches/WN9.1r3_1.0_1407_P7/        #WN9.1_1000_0756
            BTS_SC_DSP/branches/WN9.1r3_2733/               #1407_PD
            BTS_SC_DSP/branches/WN9.1r3_1407_PD4/
            BTS_SC_DSP/branches/WN8.0_1308/                 #WN8.0_1308
            BTS_SC_DSP/branches/development/psi_1308r3/
            BTS_SC_DSP_LRC_DCM/Sourcecode_LRC/Trunk/
        )

commitKey(){
for REPO in BTS_SC_DSP BTS_SC_DSP_DCM BTS_SC_DSP_LRC_DCM
do
    cmd="svn pg svn:dsp_passkey --revprop -r0 $SVNROOT$REPO"
    echo -e "\033[32;2m$cmd\033[0m"
    $cmd
done
}

branches(){
for branch in ${BRANCHS[*]}
do
    case $branch in
        *[Pp][Ss][Ii]*)
            echo -e "\033[35;2m$SVNROOT$branch\033[0m"
            ;;
        *[Tt]runk*|*p_nyquist*)
            echo -e "\033[32;2m$SVNROOT$branch\033[0m"
            ;;
        *)
            echo $SVNROOT$branch
            ;;
    esac
done
}

branchrun(){
select branch in ${BRANCHS[*]}
do
    echo -e "\033[31;1mPlease enter the svn command you want to run on this branch:\033[0m"
    echo -ne "\033[32;1m"; read CMD; echo -ne "\033[0m"
    echo -ne "\033[31;1mPlease enter the Revision:\033[0m"
    echo -ne "\033[32;1m"; read REV; echo -ne "\033[0m"
    echo -ne "\033[31;1mPlease enter the subfix/Pipe:\033[0m"
    echo -ne "\033[32;1m"; read SUB; echo -ne "\033[0m"
    echo -e "\033[33;1m$CMD ${SVNROOT}$branch@${REV:-HEAD} ${SUB}\033[0m"
    eval $CMD ${SVNROOT}$branch@${REV:-HEAD} $SVNPARAMS ${SUB}
    break
done
}

diffexternals(){
echo -e "\033[31;1mPlease select two branches you want to vimdiff:\033[0m"
select branch1 in ${BRANCHS[*]}
do
    echo -ne "\033[31;1mPlease enter the Revision:\033[0m"
    echo -ne "\033[32;1m"; read REV1; REV1=`echo $REV1 | tr -d 'rR '`; echo -ne "\033[0m"
    select branch2 in ${BRANCHS[*]}
    do
        echo -ne "\033[31;1mPlease enter the Revision:\033[0m"
        echo -ne "\033[32;1m"; read REV2; REV2=`echo $REV2 | tr -d 'rR '`; echo -ne "\033[0m"
        colordiff <(svn pg svn:externals ${SVNROOT}$branch1@${REV1:-HEAD} $SVNPARAMS) <(svn pg svn:externals ${SVNROOT}$branch2@${REV2:-HEAD} $SVNPARAMS)
        if [ $? -eq 0 ];then
            echo -e "\033[35;1mNo difference\033[0m"
        fi
        break
    done
    break
done
}

svnlockstatus(){
svn pl --revprop -r0 https://svne1.access.nsn.com/isource/svnroot/BTS_SC_DSP
svn pg svn:dsp_all_lock_hook --revprop -r0 https://svne1.access.nsn.com/isource/svnroot/BTS_SC_DSP
}

svnexternals(){
select branch in ${BRANCHS[*]}
do
    if [ "$1" == "pe" ];then
        svn pe svn:externals ${SVNROOT}$branch $SVNPARAMS
    else
        svn pg svn:externals ${SVNROOT}$branch $SVNPARAMS | grep -v "^$"
    fi
    break
done
}

suh(){
    mpwd=$PWD
    expect -c '
    spawn su -l hzbtsscm_c_cn
    expect "Password:"
    send "8f2c2b5d\r"
    send ". /home/guiljin/.bash_profile\r"
    send "cd '${mpwd}'\r"
    interact'
}

suca(){
    expect -c '
    spawn su -l ca_hzcbtsscm
    expect "Password:"
    send "hzcbtsscm123\r"
    expect "*\$ "
    send ". /home/guiljin/.bash_profile\r"
    send "cd /build/rcp\r"
    interact'
}

function _left_choice(){
used_params=$1
for i in "${!params[@]}"
do
    for used_param in ${used_params[@]}
    do
        if [[ $used_param == ${params[$i]} ]];then
            unset params[$i]
        fi
    done
done
}

function _svn(){
    local cur prev opts
    COMPREPLY=()
    first=${COMP_WORDS[0]}
    second=${COMP_WORDS[1]}
    cur=${COMP_WORDS[COMP_CWORD]}
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="co log pe pg ps pl info diff revert status blame"
    params=(--username --password --no-auth-cache --non-interactive --trust-server-cert --config-dir --config-option https://svne1.access.nsn.com)

    case $COMP_CWORD in
        0)
        ;;
        1)
        COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
        return 0
        ;;
        2|*)
        case $prev in
            co)
            params+=(--ignore-externals --depth)
            COMPREPLY=($(compgen -W "${params[*]}" -- ${cur}))
            return 0;;
            log)
            params+=(-v -l --diff --diff-cmd --stop-on-copy)
            COMPREPLY=($(compgen -W "${params[*]}" -- ${cur}))
            return 0;;
            pe|pg|ps)
            COMPREPLY=($(compgen -W "svn:externals" -- ${cur}))
            return 0;;
            pl)
            COMPREPLY=('--revprop -r0')
            return 0;;
            revert)
            if [[ $cur == -* ]];then
                COMPREPLY=(-R)
            else
                COMPREPLY=($(compgen -A file -- ${cur}))
            fi
            return 0;;
            -R)
            COMPREPLY=($(compgen -A directory -- ${cur}))
            return 0;;
            --diff-cmd)
            COMPREPLY=($(compgen -W "colordiff" -- ${cur}))
            return 0;;
            --depth)
            COMPREPLY=($(compgen -W "empty files immediates infinity" -- ${cur}))
            return 0;;
            --username)
            COMPREPLY=($(compgen -W "guiljin hzbtsscm_c_cn ca_hzcbtsscm wcdmacb" -- ${cur}))
            return 0;;
            --password)
            COMPREPLY=($(compgen -W "8f2c2b5d hzcbtsscm123 Wcdma31#" -- ${cur}))
            return 0;;
            *)
            case $second in
                co)
                _left_choice "$COMP_LINE"
                COMPREPLY=($(compgen -W "${params[*]}" -- ${cur}))
                ;;
                *)
                _left_choice "$COMP_LINE"
                COMPREPLY=($(compgen -W "${params[*]}" -- ${cur}))
                ;;
            esac
            return 0;;
        esac
        ;;
    esac
}
complete -F _svn svn