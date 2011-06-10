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
        "autocmd VimEnter * NERDTree
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

