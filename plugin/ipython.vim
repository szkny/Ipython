"=============================================================================
" FILE: ipython.vim
" AUTHOR:  Sohei Suzuki <suzuki.s1008 at gmail.com>
" License: MIT license
"=============================================================================
scriptencoding utf-8

if !has('nvim')
    echomsg 'SplitTerm requires Neovim.'
    finish
endif

command! Ipython call ipython#run()
command! -range VIpython call ipython#run_visual()
