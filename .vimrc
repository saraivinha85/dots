""
"" Thanks:
""   Gary Bernhardt  <destroyallsoftware.com>
""   Drew Neil  <vimcasts.org>
""   Tim Pope  <tbaggery.com>
""   Janus  <github.com/carlhuda/janus>
""

set t_Co=256
set nocompatible
set encoding=utf-8
set exrc                    " load vimrc from current directory
set ttyfast

call pathogen#infect()
filetype on 
filetype plugin on 
filetype indent on

runtime macros/matchit.vim  " enables % to cycle through `if/else/endif`

syntax on
color wal 
set synmaxcol=800           " don't try to highlight long lines

set number                " line numbers aren't needed
set relativenumber        " relative numbers
set ruler                 " show the cursor position all the time set cursorline   
"set cursorline            " highlight the line of the cursor
set showcmd               " show partial commands below the status line
set shell=bash            " avoids munging PATH under zsh
let g:is_bash=1           " default shell syntax
set history=200           " remember more Ex commands
set scrolloff=3           " have some context around the current line always on screen
set clipboard=unnamedplus " copy-paste vim from another

" Enable mouse
set mouse=a

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

" Auto-reload buffers when file changed on disk
set autoread

" Disable swap files; systems don't crash that often these days
set updatecount=0

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

"" Whitespace
set wrap                       " don't wrap lines
set tabstop=2                  " a tab is two spaces
set shiftwidth=2               " an autoindent (with <<) is two spaces
set noexpandtab                " use spaces, not tabs

" Toogle show invisible characters
map <F3> :set list! list? <CR> 

set backspace=indent,eol,start " backspace through everything in insert mode

" Joining lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j            " Delete comment char when joining commented lines
endif
set nojoinspaces                  " Use only 1 space after "." when joining lines, not 2
" Indicator chars
set listchars=tab:▸\ ,trail:•,extends:❯,precedes:❮
set showbreak=↪\ 

"" Searching
set hlsearch                      " highlight matches
set incsearch                     " incremental searching
set ignorecase                    " searches are case insensitive...
set smartcase                     " ... unless they contain at least one capital letter
set gdefault                      " have :s///g flag by default on

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=100

" Ragel syntax (default to ruby as host language)
let g:ragel_default_subtype='ruby'

function! s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=80
endfunction

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!

  " Avoid showing trailing whitespace when in insert mode
  au InsertEnter * :set listchars-=trail:•
  au InsertLeave * :set listchars+=trail:•

  " Some file types use real tabs
  au FileType {make,gitconfig,go} setl noexpandtab

  " Make sure all markdown files have the correct filetype set and setup wrapping
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown | call s:setupWrapping()

  " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json setf javascript

  " https://github.com/sstephenson/bats
  au BufNewFile,BufRead *.bats setl filetype=sh

  au BufNewFile,BufRead *.rl setfiletype ragel

  " make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
  au FileType python setl softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif

  " mark Jekyll YAML frontmatter as comment
  au BufNewFile,BufRead *.{md,markdown,html,xml} sy match Comment /\%^---\_.\{-}---$/

  " magic markers: enable using `H/S/J/C to jump back to
  " last HTML, stylesheet, JS or Ruby code buffer
  au BufLeave *.{erb,html}      exe "normal! mH"
  au BufLeave *.{css,scss,sass} exe "normal! mS"
  au BufLeave *.{js,coffee}     exe "normal! mJ"
  au BufLeave *.{rb}            exe "normal! mC"
augroup END

" don't use Ex mode, use Q for formatting
map Q gq

" clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<cr>

" toggle the current fold
nnoremap <Space> za

let mapleader=","

" yank to system clipboard
map <leader>y "*y

" paste lines from unnamed register and fix indentation
nmap <leader>p pV`]=
nmap <leader>P PV`]=

" expand %% to current directory in command-line mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Command-T very fast fuzzy search to open files quickly without many
" keystrokes
set wildmenu
set wildmode=longest,full
set wildignore+=*/.hg/*,/.git/*,*/.svn/*
set wildignore+=*.gif,*.png,*.jp*
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=*/.sass-cache/*,*.map
set wildignore+=*.log,*.sql,*.cache
noremap <leader>r :CommandTFlush<CR>

map <leader>gl :CommandT lib<cr>
map <leader>gt :CommandTTag<cr>
map <leader>f :CommandT<cr>
map <leader>F :CommandT %%<cr>

let g:CommandTMatchWindowAtTop=1
let g:CommandTMaxHeight=10
let g:CommandTMinHeight=2

let g:turbux_command_test_unit = 'ruby -Ilib:test'
" let g:turbux_command_cucumber = 'cucumber -f progress'

let g:ackprg = 'ag --nogroup --nocolor --column'

" In command-line mode, C-a jumps to beginning (to match C-e)
cnoremap <C-a> <Home>

" <Tab> indents if at the beginning of a line; otherwise does completion
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-n>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-p>

" ignore Rubinius, Sass cache files
set wildignore+=tmp/**,*.rbc,.rbx,*.scssc,*.sassc
" ignore Bundler standalone/vendor installs & gems
set wildignore+=bundle/**,vendor/bundle/**,vendor/cache/**,vendor/gems/**
set wildignore+=node_modules/**

" toggle between last open buffers
nnoremap <leader><leader> <c-^>

command! GdiffInTab tabedit %|vsplit|Gdiff
nnoremap <leader>d :GdiffInTab<cr>
nnoremap <leader>D :tabclose<cr>

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>

" populate arglist with files from the quickfix list
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

set splitright
set splitbelow

" Easier split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" disable cursor keys in normal mode
map <Left>  :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up>    :echo "no!"<cr>
map <Down>  :echo "no!"<cr>

if has("statusline") && !&cp
  set laststatus=2                   " always show the status bar
  set statusline=%<%1*\ %f\ %*       " filename
  set statusline+=%2*%m%r%*          " modified, readonly
  set statusline+=\ %3*%y%*          " filetype
  set statusline+=\ %4*%{fugitive#head()}%0*
  set statusline+=%=                 " left-right separation point
  set statusline+=\ %5*%l%*/%L[%p%%] " current line/total lines
  set statusline+=\ %5*%v%*[0x%B]    " current column [hex char]
endif

autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

" SuperTab plugin
let g:SuperTabContexDefaultComletionType = "<c-n>"

" Youcompleteme
let g:ycm_global_ycm_extra_conf="~/.vim/.ycm_extra_conf.py"
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
let g:ycm_confirm_extra_conf=0
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_error_symbol='>>'
let g:ycm_warning_symbol='->'
let g:ycm_add_preview_to_completeopt=1

" Ruby syntax
autocmd FileType ruby compiler ruby 

"lightvim
set noshowmode 

let g:lightline = {
    \ 'colorscheme': 'PaperColor_light',
		\ 'active': {
		\ 	'left': [ [ 'mode', 'paste' ],
		\ 						[ 'readonly', 'filename', 'modified', 'charvaluehex'] ]
		\ },
		\ 'component': {
		\ 	'charvaluehex': '0x%B'
		\ },
    \ 'component_function': {
    \  	'filename': 'LightlineFilename',
     \ },
     \ }

function! LightlineFilename()
  return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
       \ &filetype ==# 'unite' ? unite#get_status_string() :
       \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
       \ expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

" Keybindings
map <F5> :split
map <F6> :vsplit

" Protect large files from sourcing and other overhead.
" Files become read only
if !exists("my_auto_commands_loaded")
  let my_auto_commands_loaded = 1
  " Large files are > 10M
  " Set options:
  " eventignore+=FileType (no syntax highlighting etc
  " assumes FileType always on)
  " noswapfile (save copy of file)
  " bufhidden=unload (save memory when other file is viewed)
  " buftype=nowrite (file is read-only)
  " undolevels=-1 (no undo possible)
  let g:LargeFile = 1024 * 1024 * 10
  augroup LargeFile
    autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
    augroup END
  endif

