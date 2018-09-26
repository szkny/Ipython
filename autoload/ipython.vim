"=============================================================================
" FILE:    ipython.vim
" AUTHOR:  Sohei Suzuki <suzuki.s1008 at gmail.com>
" License: MIT license
"=============================================================================
scriptencoding utf-8

" include guard
if !has('nvim') || exists('b:ipython_plugin_loaded')
    finish
endif
let b:ipython_plugin_loaded = 1

" インスタンス
let s:ipython = {}

" ipythonの起動オプション
let g:ipython_startup_options = get(g:, 'ipython_options',
            \['--no-confirm-exit',
            \'--colors=Linux',
            \'--no-banner'])
if type(g:ipython_startup_options) != 3
    echomsg 'the variable "g:ipython_startup_options" must be list.'
    finish
endif
let g:ipython_startup_import_modules = get(g:, 'ipython_startup_import_modules', [])
if type(g:ipython_startup_import_modules) != 3
    echomsg 'the variable "g:ipython_startup_import_modules" must be list.'
    finish
endif

" 分割ウィンドウのオプション
let g:ipython_window_width = get(g:, 'ipython_window_width', 10)

fun! ipython#open() abort
    if !ipython#exist()
        let l:command = 'ipython'
        let g:ipython_startup_options += ['--profile='.s:init_ipython()]
        let l:args = join(g:ipython_startup_options, ' ')
        let l:filename = ' ' . expand('%')
        if findfile('Pipfile', expand('%:p')) !=# ''
            \ && findfile('Pipfile.lock', expand('%:p')) !=# ''
            let l:command = 'pipenv run ipython'
        endif
        let s:ipython = {}
        let s:ipython.script_name = expand('%:p')
        let s:ipython.script_dir = expand('%:p:h')
        let l:script_winid = win_getid()
        call splitterm#open_width(g:ipython_window_width, l:command, l:args)
        let s:ipython.info = splitterm#getinfo()
        silent exe 'normal G'
        call win_gotoid(l:script_winid)
    endif
endf


fun! ipython#close() abort
    if ipython#exist()
        call splitterm#close(s:ipython.info)
    endif
endf


fun! s:init_ipython() abort
    " ipythonの初期化関数
    "   (~/.ipython/profile_Ipython.vimを生成する)
    if !executable('ipython')
        echon 'Ipython: [error] ipython does not exist.'
        echon '                 isntalling ipython ...'
        if !executable('pip')
            echoerr 'You have to install pip!'
            return
        endif
        call system('pip install ipython')
        echon
    endif
    let l:profile_name = 'Ipython.vim'
    let l:ipython_profile_dir = $HOME . '/.ipython/profile_' . l:profile_name
    let l:ipython_startup_dir = l:ipython_profile_dir . '/startup'
    if finddir(l:ipython_startup_dir) ==# ''
        call mkdir(l:ipython_startup_dir, 'p')
    endif
    let l:ipython_startup_file = l:ipython_startup_dir . '/startup.py'
    let l:ipython_init_command = [
                \'from IPython import get_ipython',
                \'mgc = get_ipython().magic',
                \'mgc("%load_ext autoreload")',
                \'mgc("%autoreload 2")']
    let l:ipython_init_command += g:ipython_startup_import_modules
    if &filetype ==# 'python'
        let l:ipython_init_command += ['try:',
                                      \'    from '.expand('%:t:r').' import *',
                                      \'except:',
                                      \'    pass']
    endif
    call writefile(l:ipython_init_command, l:ipython_startup_file)
    return l:profile_name
endf


fun! s:run_script() abort
    if &filetype ==# 'python'
        let l:script_name = expand('%:p')
        let l:script_dir = expand('%:p:h')
        if has_key(s:ipython, 'script_name')
            \&& s:ipython.script_name !=# l:script_name
            call splitterm#jobsend_id(s:ipython.info, '%reset')
            python3 import time; time.sleep(0.1)
            call splitterm#jobsend_id_freestyle(s:ipython.info, "y\<CR>")
            python3 import time; time.sleep(0.1)
        endif
        if has_key(s:ipython, 'script_dir')
            \ && s:ipython.script_dir !=# l:script_dir
            call splitterm#jobsend_id(s:ipython.info, '%cd '.l:script_dir)
            python3 import time; time.sleep(0.1)
        endif
        let s:ipython.script_name = l:script_name
        let s:ipython.script_dir = l:script_dir
        call splitterm#jobsend_id(s:ipython.info, '%run '.s:ipython.script_name)
    endif
endf


fun! ipython#run(...) abort
    " Pythonコンソールウィンドウを作る or Pythonスクリプトを実行する関数
    " szkny/SplitTerm プラグインを利用している
    "      以下のように使用する
    "      :Python
    if ipython#exist()
        "" コンソールウィンドウが有ればスクリプトを実行
        call s:run_script()
    else
        "" コンソールウィンドウが無ければコンソール用のウィンドウを作る
        call ipython#open()
    endif
endf


fun! ipython#run_visual() abort range
    if ipython#exist()
        if &filetype ==# 'python'
            exe 'silent normal gvy'
            call splitterm#jobsend_id(s:ipython.info, '%paste')
        endif
    else
        call ipython#open()
    endif
endf


fun! ipython#exist() abort
    if exists('s:ipython')
        \&& has_key(s:ipython, 'script_name')
        \&& has_key(s:ipython, 'script_dir')
        \&& has_key(s:ipython, 'info')
        if splitterm#exist(s:ipython.info)
            return 1
        endif
    endif
    return 0
endf
