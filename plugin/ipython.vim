"=============================================================================
" FILE: ipython.vim
" AUTHOR:  Sohei Suzuki <suzuki.s1008 at gmail.com>
" License: MIT license
"=============================================================================
scriptencoding utf-8

if !has('nvim')
    echomsg 'Ipython-vim requires Neovim.'
    finish
endif

if !exists('*splitterm#open')
    echomsg 'Ipython-vim based on szkny/SplitTerm.'
    finish
endif

command! Ipython call ipython#run()
command! -range VIpython call ipython#run_visual()
