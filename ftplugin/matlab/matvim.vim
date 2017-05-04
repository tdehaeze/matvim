if !has('python')
    finish
endif

" default settings

if !exists('g:matvim_auto_connect')
    let g:matvim_auto_connect = 0
endif

if !exists('g:matvim_auto_start')
    let g:matvim_auto_start = 0
endif

if !exists('g:matvim_max_outputchars')
    let g:matvim_max_outputchars = -1
endif

" load python3 module

python3 import vim
python3 import sys
python3 sys.path.append(vim.eval('expand("<sfile>:h")'))
python3 import matvim

" bold cell titles

highlight MATCELL cterm=bold term=bold gui=bold
match MATCELL /^%%[^%]*$/

" python3 wrappers

function! MatlabStart()
python3 matvim.startMatlab()
endfunction

function! MatlabConnect(...)
    if a:0 == 0
        python3 matvim.connectMatlab()
    elseif a:0 == 1
        python3 matvim.connectMatlab(vim.eval('a:1'))
    endif
endfunction

function! MatlabFind(...)
python3 matvim.findMatlab()
endfunction

function! MatlabRunLine()
python3 matvim.runLine()
endfunction

function! MatlabRunFile()
python3 matvim.runFile()
endfunction

function! MatlabRunSelection() range
python3 matvim.runSelection()
endfunction

function! MatlabRunSection()
python3 matvim.runSection()
endfunction

function! MatlabShowVariable()
python3 matvim.showVariable()
endfunction

function! MatlabRunCommand(...)
    if a:0 == 0
        let commandstr = input('>> ')
        echo ' '
        python3 matvim.runCommand(vim.eval('commandstr'))
    elseif a:0 == 1
        python3 matvim.runCommand(vim.eval('a:1'))
    endif
endfunction

" Initialize engine

if g:matvim_auto_connect && !g:matvim_auto_start
    python3 matvim.connectMatlab()
endif

if g:matvim_auto_start && !g:matvim_auto_connect
    python3 matvim.startMatlab()
endif

if g:matvim_auto_connect && g:matvim_auto_start
    python3 matvim.connectOrStartMatlab()
endif

" shortcuts and commands

command! -nargs=1 Matlab :call MatlabRunCommand(<f-args>)
command! MatlabStart :call MatlabStart()
command! MatlabFind :echo MatlabFind()
command! -nargs=? -complete=customlist,MatlabFind MatlabConnect :call MatlabConnect(<f-args>)

nmap <buffer>,mc :call MatlabRunCommand() <cr>
nmap <buffer>,ml :call MatlabRunLine() <cr>
nmap <buffer>,mf :call MatlabRunFile() <cr>
vmap <buffer>,ms :call MatlabRunSelection() <cr>
nmap <buffer>,ms :call MatlabRunSection() <cr>
nmap <buffer>,mv :call MatlabShowVariable() <cr>
