syntax on

if &term =~ "xterm"
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

"if &term =~ "xterm"
"if has("terminfo")
"  set t_Co=16
"  set t_AB=[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{92}%+%;%dm
"  set t_AF=[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{82}%+%;%dm
"else
"  set t_Co=16
"  set t_Sf=[3%dm
"  set t_Sb=[4%dm
"endif
"endif

"hi Statement  term=bold  ctermfg=3  gui=bold  guifg=Brown
"hi Statement  term=bold  ctermfg=3   guifg=Brown
"hi Statement  term=reverse ctermfg=white ctermbg=black guifg=white guibg=black
" get a black and white screen - what I'm used to ..
" added for cfilebrowser
"hi Normal guifg=white guibg=black
"hi Normal guifg=black guibg=white
hi Normal ctermfg=white ctermbg=black guifg=white guibg=black

"hi sr

"set the font
set guifont=-adobe-courier-medium-r-normal--14-100-100-100-m-90-iso8859-1
set guifont="Courier 10 Pitch 12"
set guifont=Courier_New:h16:cANSI
"set guifont="Monospace 12"

" do settings for windows invocation of gvim...

if has("win32")
    set nocompatible
"    source $VIMRUNTIME/vimrc_example.vim
"    source $VIMRUNTIME/mswin.vim
"    behave mswin
    set guifont=courier_new:h12:w7
    set guifont="Courier 10 Pitch 12"
    set guifont=Courier_New:h16:cANSI
    set lines=48
endif

"""colors koehler
set columns=80
set rulerformat=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
set laststatus=2
set ru
syncbind

"set rulerformat=%40(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
set rulerformat=%50(%{strftime('%m\/%d\/%y\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
"set rulerformat=%50(%{strftime('%I:%M\ %p %m\/%e\/%y ')}\ %5l,%-6(%c%V%)\ %P%)
"hi StatusLine term=standout ctermfg=15 ctermbg=1 guifg=Green guibg=Red

" remove later
hi StatusLine term=standout ctermfg=15 ctermbg=1 guifg=Red guibg=White

let Tlist_Inc_Winwidth = 120

" set title string...
"set titlestring=%{$CLEARCASE_ROOT}
"set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)

set titlestring=%(\ %{$CLEARCASE_ROOT}:\ %)%(\ %F%)
