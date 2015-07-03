# get this file and execute
# wget http://bit.ly/xb-do-unix | bash
# wget https://raw.githubusercontent.com/xbalaji/pub/master/xb-do-unix.sh | bash

echo "Testing"

umask 022

# fix apt-get issues
sudo sed -i 's,^#precedence ::ffff:0:0/96  100,precedence ::ffff:0:0/96  100,' /etc/gai.conf

# disable ipv6
cat << EOF >> /etc/sysctl.conf

net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

EOF
sysctl -p


BASE_DIR=$HOME
UNAME=$USER
VIMRC_FILE=$BASE_DIR/.vimrc
BASHRC_FILE=$BASE_DIR/.bashrc


cat << EOF >> $BASHRC_FILE
umask 022
EOF

# create minimal .vimrc
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
set titlestring=%(\ %{$CLEARCASE_ROOT}:\ %)%(\ %F%)

" less straining to the eyes
highlight LongLine ctermbg=grey ctermfg=black
match LongLine  /.\%>80v/

highlight VeryLongLine ctermbg=blue ctermfg=white
2match VeryLongLine  /.\%>130v/

highlight VVeryLongLine ctermbg=red ctermfg=green
3match VVeryLongLine  /.\%>180v/

EOF

sudo apt-get -y install subversion git git-svn gcc g++ make extundelete

git config --global user.name "Balaji Venkataraman"
git config --global user.email xbala.jiv@gmail.com
git config --global push.default tracking
