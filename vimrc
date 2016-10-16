"this is a comment in this .vimrc file

set history=30          " history size
set et                  " expand tabs
set ts=4                " tab stop 4 columns
set ru                  " set ruler
set nosm
set sw=4
set path=.,/usr/include,include,common;

" ./common/logger/include
" ./common/include
" ./common/platform/include
" ./common/cli/include


"set ts=8

set tags=./tags,tags;
"set tags=./tags,/home/xbalaji/*/tags 
"set tags=./tags,/home/xbalaji/*/source/tags 

"set tagrelative

set complete=.,b,i

"set mouse=a
set ai
set directory=.,/tmp,/var/tmp,.,~/tmp
set paste

map  :n
map  :N

noremap 5 %
noremap % 5

" fix the backspace !!!
if &term =~ "xterm"
    set t_kb=
    fixdel
endif

" syntax file
" $VIMRUNTIME/syntax/c.vim


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

" set the font
set guifont=courier_new:h12:w7

" setting backgroud and foreground colors...
" get a black and white screen - what I'm used to ..
"hi Statement  term=bold  ctermfg=3  gui=bold  guifg=Brown
"hi Normal ctermfg=white ctermbg=black
colors koehler
unlet colors_name "do this so you dont mess with colorscheme
hi Normal     ctermfg=15  ctermbg=0   guifg=black guibg=white
hi Statement  cterm=bold  ctermfg=3   guifg=Brown


" enable for status line..
set laststatus=2
hi StatusLine cterm=standout ctermfg=15 ctermbg=1 guifg=Green guibg=Red


if has("win32")
                            set nocompatible
        "    source $vimruntime/vimrc_example.vim
"    source $vimruntime/mswin.vim
"    behave mswin
    set guifont=courier_new:h12:w7
"    set guifont=Courier_New:h16:cANSI
    set dir=%TMP%
    set backupdir=%TMP%
else
    "syntax on
    "syntax off
endif



"set laststatus=2
"set wildmenu

set ru

"scroll multiple windows simultaneously
"set scrollbind
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


"set rulerformat=%40(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
 set rulerformat=%50(%{strftime('%m\/%e\/%y\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
"set rulerformat=%50(%{strftime('%I:%M\ %p %m\/%e\/%y ')}\ %5l,%-6(%c%V%)\ %P%)

" add title ...
set titlestring=%(\ %{$CLEARCASE_ROOT}:\ %)%(\ %F%)

" for taglist: Taglist
filetype on
"let Tlist_Ctags_Cmd = '/usr/local/bin/ctags --if0=yes --line-directives=yes --links=yes --recurse=yes --tag-relative=no --c-types=+cdefgmnpstuvx'
let Tlist_Ctags_Cmd='/usr/bin/ctags --if0=yes --line-directives=yes --links=yes --recurse=yes --tag-relative=no --C++-kinds=+cdefgmnpstuvx --verbose=yes --totals=yes '
let Tlist_Inc_Winwidth = 0
let Tlist_Display_Prototype = 1
let Tlist_Use_Horiz_Window = 0
"let Tlist_Use_Right_Window=1
"use ':TlistAddFilesRecursive /home/xbalaji/main/source ' to build the tags
"use ':TlistSessionSave ~/taglist.save' to save the current session
"use ':TlistSessionLoad ~/taglist.save' to load the session

" Tips & tricks section
" the following replaces the line number generated in the
" html formatted 'c' or 'h' file to an anchor based on the line number
":g/\(^<font color=\"\#ffff00\">\)\( *\)\([0-9]*\)\(<\/font>\)/s//<a name="\3"\2>\1\2\3\4<\/a>/g

" removing backspace
" any character except CTRL+H followed by CTRL+H replace with nothing
":g/\([^]\)\(\)/s///g


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


" HomeSettings
function! HomeSettings(tsval)
    setlocal ts=4
    "echo a:tsval
    "setlocal syntax=off
endfunction

" SubVersionSettings
function! SubVersionSettings(tsval)
    setlocal ts=8
    " setlocal syntax=cpp
endfunction

function! SubVersionSettings1(tsval)
    setlocal ts=4
    " setlocal syntax=cpp
endfunction

function! WebFilesSettings(tsval)
    setlocal ts=2
    setlocal noai
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


autocmd BufEnter /users/xbalaji/*               call HomeSettings(4)
autocmd BufEnter /home/xbalaji/*cpp             call SubVersionSettings(8)
autocmd BufEnter /home/xbalaji/*h               call SubVersionSettings(8)
autocmd BufEnter /home/xbalaji/main-xml/*cpp    call SubVersionSettings1(4)
autocmd BufEnter /home/xbalaji/main-xml/*h      call SubVersionSettings1(4)
autocmd BufEnter *.js,*.json,*.css,*.html,*.htm call WebFilesSettings(4)

" highlight anything after 80 columns.
"highlight RightMargin term=reverse ctermbg=12 guifg=White guibg=Green
" highlight RightMargin ctermbg=red ctermfg=white guibg=#592929
" match RightMargin /\%\>80v.\+/
"syntax match Error /%>80v.\+/ containedin=ALL
"syntax match Error /\t/ containedin=ALL

" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/


" replace === with increasing anchor number, new line and add === with number 
" :let ix=1|g/\(^=== \)/s//\="<<Anchor(Num" . ix . ")>>\r".submatch(0). " " . ix . "  "/ | let ix+=1


" add line number like c-style comment, right justified with padded zero's, without zeros 
" :let ix=1|g/^/s//\=printf("\/* %04d *\/ ",ix) /|let ix+=1
" :let ix=1|g/^/s//\=printf("\/* %4d *\/ ",ix) /|let ix+=1


