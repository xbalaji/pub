# get this file and execute
# wget http://bit.ly/xb-do-unix -q -O - | bash

umask 022

BASE_DIR=$HOME
BASE_DIR=`pwd`
BIN_DIR=$BASE_DIR/bin
UNAME=$USER

VIMRC_FILE=$BASE_DIR/.vimrc
BASHRC_FILE=$BASE_DIR/.bashrc

XB_DO_UNIX=http://bit.ly/xb-do-unix
XB_DO_UNIX_SH=$BIN_DIR/xb-do-unix.sh
APT_FIX_SCRIPT=$BIN_DIR/apt-fix.sh
GIT_SETUP_SCRIPT=$BIN_DIR/setup-git.sh
DIS_IPV6_SCRIPT=$BIN_DIR/disable-ipv6.sh


echo $BASE_DIR
echo $BIN_DIR
echo $XB_DO_UNIX
echo $VIMRC_FILE
echo $BASHRC_FILE
echo $XB_DO_UNIX_SH
echo $GIT_SETUP_SCRIPT
echo $DIS_IPV6_SCRIPT



mkdir -p $BIN_DIR

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

# append to bashrc
cat << EOF >> $BASHRC_FILE

umask 022
CDPATH=\$CDPATH:.:..:../..:../../..:\$HOME
PAGER='less'
IGNOREEOF=3
HISTCONTROL=ignoredups
PS1="\u@\H - \D{%m/%d/%y %H:%M:%S} [pwd:\w]\n\\$"

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

# aliases
alias a='alias'
a al='a | less'
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
a ls='ls --color'
a lsrt='ls -Llrt'
a make='/usr/bin/make -k'
a man='man -a'
a mv='mv -i'
a nl='nl -ba'
a psme='ps -u \$USER -f'
a rm='rm -i'
a so='source'
a t='type -a'
a vi='vim'

EOF

# create .vimrc
cat << EOF > $VIMRC_FILE
"this is a comment in this .vimrc file

set history=30          " history size
set et                  " expand tabs
set ts=4                " tab stop 4 columns
set ru                  " set ruler
set nosm
set sw=4

" Match Paren is a plugin, disable loading it,
" use :DoMatchParen and :NoMatchParen to control after loading it
au VimEnter * NoMatchParen

set tags=./tags,tags;
set complete=.,b,i
set ai
set directory=.,/tmp,/var/tmp,.,~/tmp
set paste

map ^N :n^M
map ^P :N^M

noremap 5 %
noremap % 5

if &term =~ "xterm"
if has("terminfo")
  set t_Co=8
  set t_Sf=^[[3%p1%dm
  set t_Sb=^[[4%p1%dm
else
  set t_Co=8
  set t_Sf=^[[3%dm
  set t_Sb=^[[4%dm
endif
endif


" set the font
set guifont=courier_new:h12:w7

" setting backgroud and foreground colors...
colors koehler
unlet colors_name "do this so you dont mess with colorscheme
hi Normal     ctermfg=15  ctermbg=0   guifg=black guibg=white
hi Statement  cterm=bold  ctermfg=3   guifg=Brown
hi Normal     ctermfg=15  ctermbg=10   guifg=black guibg=white

" enable for status line..
set laststatus=2
hi StatusLine cterm=standout ctermfg=15 ctermbg=1 guifg=Green guibg=Red


if has("win32")
    set nocompatible
    set guifont=courier_new:h12:w7
endif

set ru
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
highlight LongLine ctermbg=grey ctermfg=black
match LongLine  /.\%>80v/

highlight VeryLongLine ctermbg=blue ctermfg=white
2match VeryLongLine  /.\%>130v/

highlight VVeryLongLine ctermbg=red ctermfg=green
3match VVeryLongLine  /.\%>180v/

EOF

cat << EOF >> $GIT_SETUP_SCRIPT
#!/bin/bash
sudo apt-get -y install subversion git git-svn gcc g++ make extundelete

git config --global user.name "Balaji Venkataraman"
git config --global user.email xbala.jiv@gmail.com
git config --global push.default tracking

EOF
chmod +x $GIT_SETUP_SCRIPT
