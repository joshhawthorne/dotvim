filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

set nocompatible

" Security
set modelines=0

" Tabs/spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Basic options
set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set relativenumber
set laststatus=2
set undofile
set undoreload=10000

" Status line
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)

" Backups
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
set backup                        " enable backups

" Leader
let mapleader = ","
let maplocalleader = "\\"

nnoremap ; :

" Make Y not dumb
nnoremap Y y$

" Searching
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault
map <leader><space> :noh<cr>
runtime macros/matchit.vim
nmap <tab> %
vmap <tab> %

" Soft/hard wrapping
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=85

" Use the same symbols as TextMate for tabstops and EOLs
set list
set listchars=tab:▸\ ,eol:¬

" Color scheme (terminal)
syntax on
set background=dark
"colorscheme molokai
"colorscheme desertEx
colorscheme solarized


" NERD Tree
map <F2> :NERDTreeToggle<cr>
let NERDTreeIgnore=['.vim$', '\~$', '.*\.pyc$', 'pip-log\.txt$', '\.rbc$']

" MOVEMENT ---------------------------------------

" Use the damn jkl; keys
"nnoremap <up> <nop>
"nnoremap <down> <nop>
"nnoremap <left> <nop>
"nnoremap <right> <nop>

" Why stretch?
"noremap h ;
"noremap j h
"noremap k gj
"noremap l gk
"noremap ; l

noremap j gj
noremap k gk

" Easy buffer navigation
" Note: For this section to make any sense you need to remap Ctrl-; to Ctrl-g at
"       the KEYBOARD level.  The reason is that for some reason the OS X doesn't
"       recognize the Ctrl+; combination as something special, so it just passes it
"       to Vim as a semicolon.
"
"       Yeah, it's dumb.
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l
noremap <leader>w <C-w>v<C-w>l

" Folding ----------------------------------------

set foldlevelstart=0
nnoremap <Space> za
vnoremap <Space> za

function! MyFoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 4
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction
set foldtext=MyFoldText()

" Fuck you, help key.
set fuoptions=maxvert,maxhorz
inoremap <F1> <ESC>:set invfullscreen<CR>a
noremap <F1> :set invfullscreen<CR>

" Fuck you too, manual key
nnoremap K <nop>

" Various filetype-specific stuff

au FileType php set noexpandtab
au FileType php nnoremap <leader>f Vatzf

" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru}    set ft=ruby

au BufNewFile,BufRead *.html setlocal filetype=htmldjango
au BufNewFile,BufRead *.html setlocal foldmethod=manual
au BufNewFile,BufRead *.html nnoremap <buffer> <localleader>f Vatzf

au BufNewFile,BufRead *.less setlocal filetype=less
au BufNewFile,BufRead *.less setlocal foldmethod=marker
au BufNewFile,BufRead *.less setlocal foldmarker={,}
au BufNewFile,BufRead *.less setlocal nocursorline

au BufNewFile,BufRead *.js setlocal foldmethod=marker
au BufNewFile,BufRead *.js setlocal foldmarker={,}

au BufRead,BufNewFile *.confluencewiki setlocal filetype=confluencewiki
au BufRead,BufNewFile *.confluencewiki setlocal wrap linebreak nolist

au BufNewFile,BufRead *.fish set filetype=fish

au BufNewFile,BufRead *.m*down set filetype=markdown
au BufNewFile,BufRead *.m*down nnoremap <localleader>1 yypVr=
au BufNewFile,BufRead *.m*down nnoremap <localleader>2 yypVr-
au BufNewFile,BufRead *.m*down nnoremap <localleader>3 I### <ESC>

au BufNewFile,BufRead *.vim setlocal foldmethod=marker

au BufNewFile,BufRead urls.py      setlocal nowrap
au BufNewFile,BufRead settings.py  normal! zR
au BufNewFile,BufRead dashboard.py normal! zR

au BufRead,BufNewFile /etc/nginx/conf/* set ft=nginx
au BufRead,BufNewFile /etc/nginx/sites-available/* set ft=nginx
au BufRead,BufNewFile /usr/local/etc/nginx/sites-available/* set ft=nginx

autocmd FileType clojure call TurnOnClojureFolding()

" Sort CSS
map <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>

" Clean whitespace
map <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Ack
map <leader>a :Ack 

" Yankring
nnoremap <silent> <leader>y :YRShow<cr>

" Formatting, TextMate-style
map <leader>q gqip

nmap <leader>m :make<cr>

" Google's JSLint
au BufNewFile,BufRead *.js set makeprg=gjslint\ %
au BufNewFile,BufRead *.js set errorformat=%-P-----\ FILE\ \ :\ \ %f\ -----,Line\ %l\\,\ E:%n:\ %m,%-Q,%-GFound\ %s,%-GSome\ %s,%-Gfixjsstyle%s,%-Gscript\ can\ %s,%-G

" TESTING GOAT APPROVES OF THESE LINES
nmap <leader>fn :cn<cr>
nmap <leader>fp :cp<cr>

" Easier linewise reselection
map <leader>v V`]

" HTML tag closing
inoremap <C-_> <Space><BS><Esc>:call InsertCloseTag()<cr>a

" Faster Esc
inoremap jj <ESC>
inoremap kk <ESC>

" TextMate-Style Autocomplete
inoremap <ESC> <C-P>
inoremap <S-ESC> <C-N>

" Scratch
nmap <leader><tab> :Sscratch<cr><C-W>x<C-j>:resize 15<cr>

" Make selecting inside an HTML tag less dumb
nnoremap Vit vitVkoj
nnoremap Vat vatV

" Rainbows!
nmap <leader>R :RainbowParenthesesToggle<CR>

" Edit vim stuff.
nnoremap <leader>ev <C-w>s<C-w>j<C-w>L:e $MYVIMRC<cr>
nnoremap <leader>es <C-w>s<C-w>j<C-w>L:e ~/.vim/snippets/<cr>

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Easy filetype switching
nnoremap _dt :set ft=htmldjango<CR>
nnoremap _jt :set ft=htmljinja<CR>
nnoremap _cw :set ft=confluencewiki<CR>
nnoremap _pd :set ft=python.django<CR>

" Python docs
nnoremap <leader>P :Pydoc<space>

" HALP
nnoremap _wtfcw :!open 'http://confluence.atlassian.com/renderer/notationhelp.action?section=all'<cr>

" VCS Stuff
let VCSCommandMapPrefix = "<leader>h"

" Disable useless HTML5 junk
let g:event_handler_attributes_complete = 0
let g:rdfa_attributes_complete = 0
let g:microdata_attributes_complete = 0
let g:atia_attributes_complete = 0

" Save when losing focus
au FocusLost * :wa

" Stop it, hash key
inoremap # X<BS>#

" Cram tests
au BufNewFile,BufRead *.t set filetype=cram
let cram_fold=1
autocmd Syntax cram setlocal foldlevel=1

" Show syntax highlighting groups for word under cursor
nmap <C-S> :call SynStack()<CR>
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Tags!
let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
let Tlist_WinWidth = 50
let Tlist_Show_One_File = 1
map <F4> :TlistToggle<cr>
map <leader>T :!/usr/local/bin/ctags --exclude='**/ckeditor' -R . $(test -f .venv && echo ~/lib/virtualenvs/`cat .venv`)<CR>

" Gundo
nnoremap U :GundoToggle<CR>
let g:gundo_debug = 1
let g:gundo_preview_bottom = 1

" Shortcut for square brackets
onoremap id i[
onoremap ad a[

" Next ()
vnoremap <silent> inb :<C-U>normal! f(vib<cr>
onoremap <silent> inb :<C-U>normal! f(vib<cr>
vnoremap <silent> anb :<C-U>normal! f(vab<cr>
onoremap <silent> anb :<C-U>normal! f(vab<cr>
vnoremap <silent> in( :<C-U>normal! f(vi(<cr>
onoremap <silent> in( :<C-U>normal! f(vi(<cr>
vnoremap <silent> an( :<C-U>normal! f(va(<cr>
onoremap <silent> an( :<C-U>normal! f(va(<cr>

" Next {}
vnoremap <silent> inB :<C-U>normal! f{viB<cr>
onoremap <silent> inB :<C-U>normal! f{viB<cr>
vnoremap <silent> anB :<C-U>normal! f{vaB<cr>
onoremap <silent> anB :<C-U>normal! f{vaB<cr>
vnoremap <silent> in{ :<C-U>normal! f{vi{<cr>
onoremap <silent> in{ :<C-U>normal! f{vi{<cr>
vnoremap <silent> an{ :<C-U>normal! f{va{<cr>
onoremap <silent> an{ :<C-U>normal! f{va{<cr>

" Next []
vnoremap <silent> ind :<C-U>normal! f[vi[<cr>
onoremap <silent> ind :<C-U>normal! f[vi[<cr>
vnoremap <silent> and :<C-U>normal! f[va[<cr>
onoremap <silent> and :<C-U>normal! f[va[<cr>
vnoremap <silent> in[ :<C-U>normal! f[vi[<cr>
onoremap <silent> in[ :<C-U>normal! f[vi[<cr>
vnoremap <silent> an[ :<C-U>normal! f[va[<cr>
onoremap <silent> an[ :<C-U>normal! f[va[<cr>

" Next <>
vnoremap <silent> in< :<C-U>normal! f<vi<<cr>
onoremap <silent> in< :<C-U>normal! f<vi<<cr>
vnoremap <silent> an< :<C-U>normal! f<va<<cr>
onoremap <silent> an< :<C-U>normal! f<va<<cr>

" Next ''
vnoremap <silent> in' :<C-U>normal! f'vi'<cr>
onoremap <silent> in' :<C-U>normal! f'vi'<cr>
vnoremap <silent> an' :<C-U>normal! f'va'<cr>
onoremap <silent> an' :<C-U>normal! f'va'<cr>

" Next ""
vnoremap <silent> in" :<C-U>normal! f"vi"<cr>
onoremap <silent> in" :<C-U>normal! f"vi"<cr>
vnoremap <silent> an" :<C-U>normal! f"va"<cr>
onoremap <silent> an" :<C-U>normal! f"va"<cr>

" Skipreturn
inoremap <c-cr> <esc>A<cr>
inoremap <s-cr> <esc>A:<cr>
au BufNewFile,BufRead *.html nnoremap <s-cr> vit<esc>a<cr><esc>vito<esc>i<cr><esc>

" Syntastic
let g:syntastic_enable_signs=1
let g:syntastic_disabled_filetypes = ['html', 'python']

nmap <silent> <f3> :ErrorsToggle<cr>
command! ErrorsToggle call ErrorsToggle()
function! ErrorsToggle()
  if exists("w:is_error_window")
    unlet w:is_error_window
    exec "q"
  else
    exec "Errors"
    lopen
    let w:is_error_window = 1
  endif
endfunction

" Camel Case Motion
map <silent> ∑ <Plug>CamelCaseMotion_w
map <silent> ∫ <Plug>CamelCaseMotion_b
map <silent> \e <Plug>CamelCaseMotion_e
omap <silent> i∑ <Plug>CamelCaseMotion_iw
xmap <silent> i∑ <Plug>CamelCaseMotion_iw

" Diff
let g:HgDiffing = 0
function! s:HgDiffCurrentFile()
    if g:HgDiffing == 1
        if bufwinnr(bufnr('__HGDIFF__')) != -1
            exe bufwinnr(bufnr('__HGDIFF__')) . "wincmd w"
            bdelete
        endif

        diffoff!

        let g:HgDiffing = 0

        return
    endif

    let fname = bufname('%')
    let ftype = &ft
    diffthis

    vnew __HGDIFF__

    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    exec 'setlocal filetype='.ftype

    setlocal modifiable

    silent normal! ggdG
    silent exec ':r!hg cat ' . fname
    silent normal! ggdd

    setlocal nomodifiable

    diffthis

    wincmd l

    let g:HgDiffing = 1

    return
endfunction

command! HgDiffCurrent call s:HgDiffCurrentFile()

nmap <leader>d :HgDiffCurrent<cr>

" MacVim
if has('gui_running')
    set guifont=Menlo:h12

    set go-=T
    set go-=l
    set go-=L
    set go-=r
    set go-=R

    if has("gui_macvim")
        " Utility functions to create file commands
        function s:CommandCabbr(abbreviation, expansion)
          execute 'cabbrev ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
        endfunction

        function s:FileCommand(name, ...)
          if exists("a:1")
            let funcname = a:1
          else
            let funcname = a:name
          endif

          execute 'command -nargs=1 -complete=file ' . a:name . ' :call ' . funcname . '(<f-args>)'
        endfunction

        function s:DefineCommand(name, destination)
          call s:FileCommand(a:destination)
          call s:CommandCabbr(a:name, a:destination)
        endfunction

        " If the parameter is a directory, cd into it
        function s:CdIfDirectory(directory)
          if isdirectory(a:directory)
            call ChangeDirectory(a:directory)
          endif
        endfunction

        " NERDTree utility function
        function s:UpdateNERDTree(stay)
          if exists("t:NERDTreeBufName")
            if bufwinnr(t:NERDTreeBufName) != -1
              NERDTree
              if !a:stay
                wincmd p
              end
            endif
          endif
        endfunction

        " Public NERDTree-aware versions of builtin functions
        function ChangeDirectory(dir, ...)
          execute "cd " . a:dir
          let stay = exists("a:1") ? a:1 : 1
          call s:UpdateNERDTree(stay)
        endfunction

        function Touch(file)
          execute "!touch " . a:file
          call s:UpdateNERDTree(1)
        endfunction

        function Remove(file)
          let current_path = expand("%")
          let removed_path = fnamemodify(a:file, ":p")

          if (current_path == removed_path) && (getbufvar("%", "&modified"))
            echo "You are trying to remove the file you are editing. Please close the buffer first."
          else
            execute "!rm " . a:file
          endif
        endfunction

        function Edit(file)
          if exists("b:NERDTreeRoot")
            wincmd p
          endif

          execute "e " . a:file

ruby << RUBY
  destination = File.expand_path(VIM.evaluate(%{system("dirname " . a:file)}))
  pwd         = File.expand_path(Dir.pwd)
  home        = pwd == File.expand_path("~")

  if home || Regexp.new("^" + Regexp.escape(pwd)) !~ destination
    VIM.command(%{call ChangeDirectory(system("dirname " . a:file), 0)})
  end
RUBY
        endfunction

        " Define the NERDTree-aware aliases
        call s:DefineCommand("cd", "ChangeDirectory")
        call s:DefineCommand("touch", "Touch")
        call s:DefineCommand("rm", "Remove")
        call s:DefineCommand("e", "Edit")

                
        " Project Tree
        autocmd VimEnter * NERDTree
        autocmd VimEnter * wincmd p
        autocmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))


		" Without setting this, ZoomWin restores windows in a way that causes
		" equalalways behavior to be triggered the next time CommandT is used.
		" This is likely a bludgeon to solve some other issue, but it works
		set noequalalways

        " Command-T for CommandT
        let g:CommandTMaxHeight=20
        macmenu &File.New\ Tab key=<nop>
        map <D-t> :CommandT<CR>

		" ZoomWin configuration
		map <leader><leader> :ZoomWin<CR>

        " Command-Shift-F for Ack
        macmenu Window.Toggle\ Full\ Screen\ Mode key=<nop>
        map <D-F> :Ack<space>

        " ConqueTerm wrapper
        function StartTerm()
          execute 'ConqueTerm ' . $SHELL . ' --login'
          setlocal listchars=tab:\ \ 
        endfunction

        " Command-e for ConqueTerm
        map <D-e> :call StartTerm()<CR>

        " Command-/ to toggle comments
        map <D-/> <plug>NERDCommenterToggle<CR>

    end

    "let g:sparkupExecuteMapping = '<D-e>'

    highlight SpellBad term=underline gui=undercurl guisp=Orange

    inoremenu <silent>&Plugin.QuickCursor.CloseBuffer <Esc>:w<cr>:BufClose<cr>
    nnoremenu <silent>&Plugin.QuickCursor.CloseBuffer :w<cr>:BufClose<cr>

    let g:ruby_debugger_debug_mode = 1
else
    set nocursorline
endif

