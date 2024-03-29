#! /usr/bin/env bash
# get this file and execute
# wget http://bit.ly/xb-do-unix -q -O - | bash

umask 022

BASE_DIR=$HOME
BASE_DIR=`pwd`
BIN_DIR=$BASE_DIR/bin
WIN_DIR=$BASE_DIR/win
UNAME=$USER

VIMRC_FILE=$BASE_DIR/.vimrc
BASHRC_FILE=$BASE_DIR/.bashrc
PROFILE_FILE=$BASE_DIR/.profile

XB_DO_UNIX=http://bit.ly/xb-do-unix
XB_DO_UNIX_SH=$BIN_DIR/xb-do-unix.sh
APT_FIX_SCRIPT=$BIN_DIR/apt-fix.sh
GIT_SETUP_SCRIPT=$BIN_DIR/setup-git.sh
DIS_IPV6_SCRIPT=$BIN_DIR/disable-ipv6.sh
CFG_ST_IP_SCRIPT=$BIN_DIR/network-config-static.sh

DST_WIN_VIM_RC=$WIN_DIR/_vimrc
DST_WIN_VIMRC=$WIN_DIR/vimrc
DST_WIN_GVIMRC=$WIN_DIR/gvimrc
WIN_README=$WIN_DIR/README.txt

SRC_WIN_VIM_RC="https://raw.githubusercontent.com/xbalaji/pub/master/_vimrc"
SRC_WIN_VIMRC="https://raw.githubusercontent.com/xbalaji/pub/master/vimrc"
SRC_WIN_GVIMRC="https://raw.githubusercontent.com/xbalaji/pub/master/gvimrc"


echo $BASE_DIR
echo $BIN_DIR
echo $XB_DO_UNIX
echo $VIMRC_FILE
echo $BASHRC_FILE
echo $PROFILE_FILE
echo $XB_DO_UNIX_SH
echo $GIT_SETUP_SCRIPT
echo $DIS_IPV6_SCRIPT
echo $CFG_ST_IP_SCRIPT

mkdir -p $BIN_DIR
mkdir -p $WIN_DIR

wget $XB_DO_UNIX -O $XB_DO_UNIX_SH --quiet
chmod +x $XB_DO_UNIX_SH

cat << EOF > $APT_FIX_SCRIPT
#!/bin/bash
# fix apt-get issues
sudo sed -i 's,^#precedence ::ffff:0:0/96  100,precedence ::ffff:0:0/96  100,' /etc/gai.conf
EOF
chmod +x $APT_FIX_SCRIPT


# disable ipv6
cat << EOF1 > $DIS_IPV6_SCRIPT
#!/bin/bash

cat << EOF >> /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
sysctl -p
EOF1
chmod +x $DIS_IPV6_SCRIPT

# convert dhcp to static ip
cat << EOF > $CFG_ST_IP_SCRIPT
#!/bin/bash

IFACE_2REPLACE=\$(ifquery -X lo --list)
echo \${IFACE_2REPLACE}

IFACE_FILE="/etc/network/interfaces"
iface_d="iface \${IFACE_2REPLACE} inet dhcp"
iface_s="iface \${IFACE_2REPLACE} inet static"

ip_line=\$(ifconfig \${IFACE_2REPLACE} | grep 'inet addr')
a_line=\$(echo \$ip_line | awk '{print \$2}' | sed -e 's/addr:/    address /')
m_line=\$(echo \$ip_line | awk '{print \$4}' | sed -e 's/Mask:/    netmask /')
b_line=\$(echo \$ip_line | awk '{print \$3}' | sed -e 's/Bcast:/    broadcast /')
g_line=\$(route -n | grep '^0' | awk '{print \$2}' | sed -e 's/^/    gateway /')

dns_servers=\$(grep nameserver /etc/resolv.conf | awk '{printf "%s ", \$2}')
d_line=\$(echo "    dns-nameservers \$dns_servers")
static_line="\n\$iface_s\n\$a_line\n\$m_line\n\$b_line\n\$g_line\n\$d_line\n"

sed -e "s,\$iface_d,\${static_line},g" \${IFACE_FILE}

if [ -w \${IFACE_FILE} ]
then
    sed -i -e "s,\$iface_d,\${static_line},g" \${IFACE_FILE}
fi

EOF
chmod +x $CFG_ST_IP_SCRIPT

# append to bashrc
cat << EOF >> $BASHRC_FILE
# custom bashrc: xbalaji@gmail.com

# If not running interactively, don't do anything
case \$- in
    *i*) ;;
      *) return;;
esac

umask 022
shopt -qs checkwinsize
shopt -s histappend
CDPATH=\$CDPATH:.:..:../..:../../..:\$HOME
EDITOR='vim'
GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_START="\u@\H - \D{%m/%d/%y %H:%M:%S} [pwd:\w]"
GIT_PROMPT_END="\n\\$"
HISTCONTROL=ignoreboth # ignore duplicate and lines starting with space
HISTFILESIZE=2000
HISTSIZE=1000
IGNOREEOF=3
PAGER='less'
PATH=.:\$HOME/bin:\$HOME:/.local/bin:\$HOME/.cargo/bin:\$PATH
PS1="\u@\H - \D{%m/%d/%y %H:%M:%S} [pwd:\w]\n\\$"

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# useful functions
# find pattern
fpn ()
{
grep -l \$1 \$(find . -name "*.[ch]" -print)
}

# grep in history
hg ()
{
history | egrep \$1
}

# get the path of the files if multiple - use type
tf()
{
type -a \$1 | grep -v aliased | grep -v builtin | cut -d " " -f3-
}

# format man pages from source - xbalaji@cisco.com
myman()
{
    nroff -man \$* | less
}

# world visible ip address
whatsmyip2()
{
    curl -s checkip.dyndns.org  |  sed -e 's,^.*IP Address: ,,g;s,<\/body.*,,g'
}

# gitgo, switch to remote branch
gitgo ()
{
    [ \$(git branch -r | grep -v HEAD | grep -c \$1) -ne 1 ] && echo "\$1 matches multiple or no branches" && return;
    git switch \$(git branch -r | grep -v HEAD | grep \$1 | cut -d "/" -f2-)
}

gitprunebranches ()
{
    cd \$(git rev-parse --show-toplevel) && git switch main && git branch -D \$(git branch | cut -c3- | grep -v "main\$" | tr '\n' ' ') && git remote prune origin && git pull --rebase
}


export TWILIO_ACCOUNT_SID=GET_FROM_TWILIO
export TWILIO_AUTH_TOKEN=GET_FROM_TWILIO
twilio-phone-get()
{
  num=\$(echo \${*} | tr -d [:space:])
  [[ "\$num" =~ ^[0-9].* ]] && num="+1\${num}"
  echo \$num
  twilio api:lookups:v1:phone-numbers:fetch --type carrier --type caller-name -o json --phone-number "\${num}"
}

# aliases
alias a='alias'
a al='a | less'
a aws2='awsv2'
a bc='bc -l'
a c='clear'
a cls='clear'
a dmpath='echo \$MANPATH | tr ":" "\n"'
a dpath='echo \$PATH | tr ":" "\n"'
a ebash='exec bash'
a ecsh='exec csh'
a hcd='h | grep cd'
a hfind='h | grep find'
a h='history'
a hvi='h | grep vi'
a lal='ls -al'
a la='ls -a'
a lam='\ls -al|less'
a ldir='ls -rt1F | grep "/" '
a less='less -I -r -X'
a lld='ls -l| grep ^d'
a lldm='ls -l| grep ^d | less'
a l='ls -l'
a lm='\ls -l|less'
a ls='ls -G'
a lsrt='ls -Llrt'
a make='/usr/bin/make -k'
a man='man -a'
a mv='mv -i'
a mydate='date "+%A %B %d, %Y %r"'
a nl='nl -ba'
a piplistoutdated="pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f1"
a pip=pip3
a pipupgradeall="pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f1| xargs -n1 pip install -U"
a psme='ps -u \$USER -f'
a python='python3'
a rm='rm -i'
a so='source'
a t='type -a'
a vi='vim'
a whatsmyip='curl ipinfo.io/ip'
a wslcopy='clip.exe'
a wslpaste='powershell.exe -command "Get-Clipboard"'
a wtsettings='vi /mnt/c/Users/xbalaji/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json'

# using find with prune, skip any directory or file with name _build and then do the or operation "-o"
a mytags1='find \$PWD  -type d -name _build -prune -o  \( -iname "*.cpp" -o -iname "*.hpp" -o -iname "*.[ch]" \)  -print | /usr/bin/ctags --sort=yes --language-force=C++ --if0=yes --line-directives=yes --links=yes --tag-relative=no --C++-kinds=+cdefgmnpstuvx --fields=+iaS  --extra=+q --verbose=yes --totals=yes -L -'

export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source \$HOME/dev/public/bash-git-prompt/gitprompt.sh
EOF

# create .vimrc
cat << EOF > $VIMRC_FILE
"this is a comment in this .vimrc file

set paste               " set this first, will reset other options
set history=30          " history size
set ru                  " set ruler
set nosm                " don't show match by default
set et                  " expand tabs
set ts=2                " tab stop 2 columns
set sw=2
set sts=2               " :help softtabstop

" Match Paren is a plugin, disable loading it,
" use :DoMatchParen and :NoMatchParen to control after loading it
au VimEnter * NoMatchParen

set tags=./tags,tags;
set complete=.,b,i
set noai
set directory=.,/tmp,/var/tmp,.,~/tmp
"set columns=80

nnoremap  :n<CR>
nnoremap  :N<CR>

nnoremap 5 %
nnoremap % 5

" fold related stuff
set fdm=indent        " set fold method as indent
set nofoldenable      " disable fold by default
nnoremap - za         " map - (minus) for fold toggle
nnoremap _ zR         " map _ (underscore) to unfold all

set lazyredraw

if &term =~ "xterm"
  set t_kb=
  fixdel
  if has("terminfo")
    set t_Co=8
    set t_Sf=[3%p1%dm
    set t_Sb=[4%p1%dm
  else
    set t_Co=8
    set t_Sf=[3%dm
    set t_Sb=[4%dm
  endif
endif


" set the font
set guifont=courier_new:h12:w7

" setting backgroud and foreground colors...
colors koehler
unlet colors_name "do this so you dont mess with colorscheme
" hi Statement  cterm=bold  ctermfg=3   guifg=Brown
" hi Normal     ctermfg=15  ctermbg=0   guifg=black guibg=white

" enable for status line..
set laststatus=2
hi StatusLine cterm=standout ctermfg=15 ctermbg=1 guifg=Green guibg=Red


if has("win32")
  set nocompatible

  source \$VIMRUNTIME/vimrc_example.vim
  source \$VIMRUNTIME/mswin.vim

  behave mswin

  set guifont=courier_new:h12:w7
  set guifont=Courier_New:h16:cANSI
  set lines=48
  set dir=%TMP%
  set backupdir=%TMP%

  set diffexpr=MyDiff()

  function! MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let eq = ''
    if $VIMRUNTIME =~ ' '
      if &sh =~ '\<cmd'
        let cmd = '""' . $VIMRUNTIME . '\diff"'
        let eq = '"'
      else
        let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
      endif
    else
      let cmd = $VIMRUNTIME . '\diff'
    endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
  endfunction
endif "has win32

syncbind

" binary editing
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END


" add title ...
set rulerformat=%50(%{strftime('%m\/%e\/%y\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
set titlestring=%(\ %{\$CLEARCASE_ROOT}:\ %)%(\ %F%)

" less straining to the eyes
highlight LongLine ctermbg=red guibg=red
match LongLine  /.\%>80v\%<130v/

" highlight VeryLongLine ctermbg=blue ctermfg=white
highlight VeryLongLine ctermbg=green guibg=green
2match VeryLongLine  /.\%>130v\%<179v/

" highlight VVeryLongLine ctermbg=green ctermfg=white
highlight VVeryLongLine ctermbg=blue guibg=blue
3match VVeryLongLine  /.\%>180v.\%<400v/

" --------------------------------------------------------
"    notes and help section: tips & tricks section
" --------------------------------------------------------
" highlight search, use the command below to highlight search
" set hlsearch

" not greedy search, to end at the first matching pattern in regex
" to end the search after the first double quote after name, use
" name="balaji" city="san jose" city="usa"
" /name=".\{-}"
"
" the following replaces the line number generated in the
" html formatted 'c' or 'h' file to an anchor based on the line number
":g/\(^<font color=\"\#ffff00\">\)\( *\)\([0-9]*\)\(<\/font>\)/s//<a name="\3"\2>\1\2\3\4<\/a>/g

" removing backspace
" any character except CTRL+H followed by CTRL+H replace with nothing
":g/\([^]\)\(\)/s///g

let Tlist_Ctags_Cmd='/usr/bin/ctags --if0=yes --line-directives=yes --links=yes --recurse=yes --tag-relative=no --C++-kinds=+cdefgmnpstuvx --verbose=yes --totals=yes '
let Tlist_Inc_Winwidth = 0
let Tlist_Display_Prototype = 1
let Tlist_Use_Horiz_Window = 0

" BackSpaceDelete
function! BackSpaceDelete()
  let lnum = 1
  while lnum < line('$')
    let l = getline(lnum)
      while l =~ '[^]'
        let l = substitute(l, '[^]', '', '')
      endwhile
      call setline(lnum, l)
      let lnum = lnum + 1
  endwhile
endfunction

command! -nargs=0 BSdelete call BackSpaceDelete()

" SetTabSize
function! SetTabSize(tsval)
  let &l:ts=a:tsval  " special case setting properties to variables
  let &l:sw=a:tsval  " set shift-width same as tab-size
  let &l:sts=a:tsval " set softtabstop same as tab-size
endfunction

function! UnHighLight()
  match
  2match
  3match
endfunction

"
" increment and replace: first group the data, operate on the
" particular block using functions and use "." to join the strings
"
" Example:   Async0/1,  Async0/2,   Async0/3,   Async0/4 with
"            Async0/23  Async0/24,  Async0/25   Async0/26
"
" :g/\(Async0\/\)\(\d\)/s//\=submatch(1) . (submatch(2)+22)/gc

" find lines that don't contain something
" :g!/notthis/p

" get the current file name, remove the path after the first 3 directories
" and add tags file to the end

"let s:cur_dir  = fnamemodify(bufname("%"), ":p")
"let s:tag_file = substitute(s:cur_dir, '/\([^/]*\)/\([^/]*\)/\([^/]*\)/\(.*\)', '/\1/\2/\3/tags', 'g')
"let &tags=s:tag_file

autocmd BufEnter *cpp,*h,*c,*hpp,*cc        call SetTabSize(2)
autocmd BufEnter *.js,*.css,*.html,*.htm    call SetTabSize(2)
autocmd BufEnter .vimrc,*.json,*.yml,*.py   call SetTabSize(2)
autocmd BufEnter *.sh,*yaml,*rs,*.tf        call SetTabSize(2)

" replace === with increasing anchor number, new line and add === with number
" :let ix=1|g/\(^=== \)/s//\="<<Anchor(Num" . ix . ")>>\r".submatch(0). " " . ix . "  "/ | let ix+=1

" add line number like c-style comment, right justified with padded zero's, without zeros
" :let ix=1|g/^/s//\=printf("\/* %04d *\/ ",ix) /|let ix+=1
" :let ix=1|g/^/s//\=printf("\/* %4d *\/ ",ix) /|let ix+=1

EOF

cat << EOF >> $GIT_SETUP_SCRIPT
#!/bin/bash
sudo apt-get -y install subversion git git-svn gcc g++ make extundelete

git config --global user.name "Balaji Venkataraman"
git config --global user.email xbala.jiv@gmail.com
git config --global push.default tracking

EOF
chmod +x $GIT_SETUP_SCRIPT

cat << EOF >> $WIN_README

Copy the files in this directory to \$VIM directory
To find \$VIM, open gvim and type :echo \$VIM on command prompt

EOF

cat << EOF >> $PROFILE_FILE
[[ -f $BASHRC_FILE ]] && source $BASHRC_FILE
EOF


# download windows vimrc files
# wget $SRC_WIN_VIMRC -O $DST_WIN_VIMRC  --quiet
# wget $SRC_WIN_VIMRC -O $DST_WIN_VIM_RC --quiet
# wget $SRC_WIN_VIMRC -O $DST_WIN_GVIMRC --quiet

cp $VIMRC_FILE $DST_WIN_VIMRC
cp $VIMRC_FILE $DST_WIN_VIM_RC
cp $VIMRC_FILE $DST_WIN_GVIMRC

