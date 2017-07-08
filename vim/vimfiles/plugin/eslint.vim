func! Compile()
	if 'javascript' == &ft
		let makeprg = 'set makeprg=eslint\ --no-color\ ' . expand("%")
		setlocal errorformat=%+P%f,%*\\s%l:%c%*\\s%t%*\\S%*\\s%m
	else
	endif

    silent! exe makeprg
    silent! exe ':update'
	silent! exe ':make'

    call HideOutput()
    call Quickfix()
endfunc

func! Quickfix()
    let list = getqflist()
    let bugs = len(list)

    if bugs == 0
        echo 'Compile success!'
        silent! exe 'cw'
    else
		echo 'Fix bugs first.'
		silent! exe 'cw ' . string((bugs + 1) > 9 ? 9 : (bugs + 1))
    endif
endfunc

func! HideOutput()
    let output_file = string(getpid()) . '.output'
    let bufnumlist  = tabpagebuflist()

	:ccl
    for bufnum in bufnumlist
        let file = bufname(bufnum)
        if file =~# output_file
            silent! exe string(bufnum) . ' bwipe!' 
            break
        endif
    endfor

    silent! exe ':setlocal laststatus=2'
endfunc

autocmd FileType javascript nnoremap <buffer><silent> ,c :call Compile()<cr>
autocmd FileType javascript nnoremap <buffer><silent> ,h :call HideOutput()<cr>
