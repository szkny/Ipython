# SplitTerm

## 概要

neovimのターミナルモードのラッパープラグインです  

## インストール

[vim-plug](https://github.com/junegunn/vim-plug)の場合、`init.vim`に以下を追記  

```vim
Plug 'szkny/SplitTerm'
```

neovimを開いて下記コマンドを実行  
```vim
:PlugInstall
```

## キーマッピング (おすすめ)

`t`で分割コンソールを起動するようにマッピング  

```vimscript
nnoremap  t  :SplitTerm<CR>i
```

## コマンド

| 使い方                      | 説明                                                  |
|:----------------------------|:------------------------------------------------------|
| :SplitTerm *COMMAND*        | 分割コンソールを開き、*COMMAND*を実行 (default: bash) |
| :SplitTermJobSend *COMMAND* | 最後に開いたコンソールで*COMMAND*を実行               |
| :SplitTermClose             | 最後に開いたコンソールを閉じる                        |

## 関数

`[]`の引数はオプショナル

| 名前                                           | 説明                                                                     |
|:-----------------------------------------------|:-------------------------------------------------------------------------|
| splitterm#open(['*COMMAND*'])                  | 分割コンソールを開く (*COMMAND*が与えられれば実行)                       |
| splitterm#close([*term_info*])                 | 最後に開いたコンソールを閉じる (*term_info*で指定したコンソールを閉じる) |
| splitterm#exist([*term_info*])                 | 最後に開いたコンソールの存在確認 (*term_info*で指定したコンソールを確認) |
| splitterm#jobsend('*COMMAND*')                 | 最後に開いたコンソールで*COMMAND*を実行                                  |
| splitterm#jobsend_id(*term_info*, '*COMMAND*') | *term_info*で指定したコンソールで*COMMAND*を実行                         |
| splitterm#getinfo()                            | 最後に開いたコンソールの*terminal_info*を取得                            |

#### <u>応用例</u>

```vim
fun! s:python_run() abort
    " ABOUT: Pythonコンソールウィンドウを作り、編集中のPythonスクリプトを実行する関数
    if &filetype ==# 'python'
        if s:python_exist()
            "" コンソールウィンドウが有ればスクリプトを実行
            let l:script_name = expand('%:p')
            let l:script_dir = expand('%:p:h')
            if has_key(s:ipython, 'script_name')
                \&& s:ipython.script_name !=# l:script_name
                call splitterm#jobsend_id(s:ipython.info, '%reset')
                call splitterm#jobsend_id(s:ipython.info, 'y')
            endif
            if has_key(s:ipython, 'script_dir')
                \ && s:ipython.script_dir !=# l:script_dir
                call splitterm#jobsend_id(s:ipython.info, '%cd '.l:script_dir)
            endif
            let s:ipython.script_name = l:script_name
            let s:ipython.script_dir = l:script_dir
            call splitterm#jobsend_id(s:ipython.info, '%run '.s:ipython.script_name)
        else
            "" コンソールウィンドウが無ければコンソール用のウィンドウを作る
            let l:command = 'ipython'
            let l:filename = ' ' . expand('%')
            if findfile('Pipfile', expand('%:p')) !=# ''
                \ && findfile('Pipfile.lock', expand('%:p')) !=# ''
                let l:command = 'pipenv run ipython'
            endif
            let s:ipython = {}
            let s:ipython.script_name = expand('%:p')
            let s:ipython.script_dir = expand('%:p:h')
            let l:script_winid = win_getid()
            call splitterm#open(l:command, '--no-confirm-exit --colors=Linux')
            let s:ipython.info = splitterm#getinfo()
            silent exe 'normal G'
            call win_gotoid(l:script_winid)
        endif
    endif
endf
command! Python call s:python_run()


fun! s:python_exist() abort
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
```

## デモ

![](https://github.com/szkny/SplitTerm/wiki/images/demo1.gif)  

上記の応用例(Pythonコマンド)  
![](https://github.com/szkny/SplitTerm/wiki/images/demo2.gif)  
