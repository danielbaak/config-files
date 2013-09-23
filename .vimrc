"" No need to be compatible with vi and lose features.
set nocompatible

"" Assume a dark background
""set background=dark

"" Set textwidth to 80, this implies word wrap.
""set textwidth=80

"" Show line numbers.
set nu
set cursorline

"" Automatic C-style indenting.
""set autoindent
set smartindent
set tabstop=2
set shiftwidth=2

"" When inserting TABs replace them with the appropriate number of spaces
""set expandtab

"" But TABs are needed in Makefiles
""au BufNewFile,BufReadPost Makefile se noexpandtab

"" Show matching braces.
""set showmatch

"" Choose the right syntax highlightning per TAB-completion :-)
"" map <F2> :source $VIM/syntax/

"" Syntax highlightning, but only for color terminals.
if &t_Co > 1
  syntax on
endif

"" Set update time to 1 second (default is 4 seconds), convenient vor taglist.vim.
set updatetime=1000

"" Colours in xterm.
""map <F3> :se t_Co=16<C-M>:se t_AB=<C-V><ESC>[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{92}%+%;%dm<C-V><C-M>:se t_AF=<C-V><ESC>[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{82}%+%;%dm<C-V><C-M>
"" Remove search highlighting
nnoremap <F3> :set hlsearch!<CR>

"" Toggle between .h and .cpp with F4.
function! ToggleBetweenHeaderAndSourceFile()
  let bufname = bufname("%")
  let ext = fnamemodify(bufname, ":e")
  if ext == "h"
    let ext = "cpp"
  elseif ext == "cpp"
    let ext = "h"
  else
    return
  endif
  let bufname_new = fnamemodify(bufname, ":r") . "." . ext
  let bufname_alt = bufname("#")
  if bufname_new == bufname_alt
    execute ":e#"
  else
    execute ":e " . bufname_new
  endif
endfunction
map <silent> <F4> :call ToggleBetweenHeaderAndSourceFile()<CR>

"" Keep the horizontal cursor position when moving vertically.
set nostartofline

"" Reformat comment on current line. TODO: explain how.
map <silent> hc ==I  <ESC>:.s/\/\/ */\/\//<CR>:nohlsearch<CR>j

"" Make sure == also indents #ifdef etc.
noremap <silent> == IX<ESC>==:.s/X//<CR>:nohlsearch<CR>

"" Toggle encoding with F12.
function! ToggleEncoding()
  if &encoding == "latin1"
    set encoding=utf-8
  elseif &encoding == "utf-8"
    set encoding=latin1
  endif
endfunction
map <silent> <F12> :call ToggleEncoding()<CR>

"" Do not break long lines.
set nowrap
set listchars=eol:$,extends:>

"" Next / previous error with Tab / Shift+Tab.
map <silent> <Tab> :cn<CR>
map <silent> <S+Tab> :cp<CR>
map <silent> <BS><Tab> :cp<CR>

"" Umlaut mappings for US keyboard.
""imap "a ä
""imap "o ö
""imap "u ü
""imap "s ß
""imap "A Ä
""imap "O Ö
""imap "U Ü

"" After this many msecs do not imap.
set timeoutlen=500

"" Always show the name of the file being edited.
 set ls=2

"" Show the mode (insert,replace,etc.)
set showmode
 
"" No blinking cursor please.
set gcr=a:blinkon0

"" Cycle through completions with TAB (and SHIFT-TAB cycles backwards).
function! InsertTabWrapper(direction) 
    let col = col('.') - 1 
    if !col || getline('.')[col - 1] !~ '\k' 
        return "\<tab>" 
    elseif "backward" == a:direction 
        return "\<c-p>" 
    else 
        return "\<c-n>" 
    endif 
endfunction 
inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<cr>

"" Cycling through Windows quicker.
map <C-M> <C-W>j<C-W>_ 
map <C-K> <C-W>k<C-W>_ 
map <A-Down>  <C-W><Down><C-W>_
map <A-Up>    <C-W><Up><C-W>_
map <A-Left>  <C-W><Left><C-W>|
map <A-Right> <C-W><Right><C-W>|

"" Do not show any line of minimized windows
set wmh=0

"" Make it easy to update/reload _vimrc.
"":nmap ,s :source $HOME/.vimrc 
"":nmap ,v :sp $HOME/.vimrc 

"" Latex Suite 1.5 wants it
"" REQUIRED. This makes vim invoke latex-suite when you open a tex file.
filetype plugin on

"" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
"" can be called correctly.
set shellslash

"" IMPORTANT: grep will sometimes skip displaying the file name if you
"" search in a singe file. This will confuse latex-suite. Set your grep
"" program to alway generate a file-name.
set grepprg=grep\ -nH\ $*

"" OPTIONAL: This enables automatic indentation as you type (by 2 spaces)
filetype indent on
set sw=2

"" no placeholders please
let g:Imap_UsePlaceHolders = 0

"" no " conversion please
let g:Tex_SmartKeyQuote = 0

"" don't use Makefile if one is there
let g:Tex_UseMakefile = 0

"" Syntax Highlighting for MhonArc Config files
au BufNewFile,BufRead *.mrc so $HOME/.vim/mhonarc.vim

"" set guifont=Courier10_BT/Roman/10
"" set gfn=Courier\ 10\ Pitch\ 10
set gfw=
set go=agimrLtT

set guifont=DejaVu\ Sans\ Mono\ 8

"" more keybindings
map cn <esc>:cn<cr>
map cp <esc>:cp<cr>
map mn <esc>:make<cr>
map mm <esc>:w<cr><esc>:make<cr>

"" moving between splits easily
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

"" folding by syntax
map FF <esc>:set foldmethod=syntax<cr>

set wmw=0
nmap <c-h> <c-w>h<c-w><Bar>
nmap <c-l> <c-w>l<c-w><Bar>

"" fixing autolinebreaks
set linebreak wrap tw=0

"" Google Contacts Lookup functionality
""imap <C-F> <ESC>:r!google-contacts-lookup.py <cword><CR><ESC>

"" keybindings for Screen integration
map <F5> <esc>:ScreenSend<cr>
""let g:ScreenShellGnuScreenVerticalSupport = 'native'

"" the following command lets vim get along better with screen
set term=xterm

"" spell checking for US-english
"" set spell spelllang=en_us

map <F5> <Esc>:EnableFastPHPFolds<Cr>
map <F6> <Esc>:EnablePHPFolds<Cr>
map <F7> <Esc>:DisablePHPFolds<Cr>

nnoremap <Space> za
nnoremap ~ zfat 

colorscheme desert 

cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))

filetype plugin on

map <Tab> <Esc>:TlistOpen<Cr>

set backupdir=~/.vimbackup//
set dir=~/.vimswap// 

highlight ExtraWhitespace ctermbg=red guibg=red
highlight Whitespace ctermbg=darkgreen guibg=darkgreen


execute pathogen#infect()
