# Ipython

## 概要

neovimのターミナルモードからipythonを呼び出すプラグインです。  
[`szkny/SplitTerm`](https://github.com/szkny/SplitTerm)を利用しています。

- このプラグインでできること
    - Ipythonコンソールでスクリプトを実行 (実行後も変数、メソッドを保持)
    - 編集中スクリプトの部分実行
    - Ipythonの機能をおおよそ実行可能

## インストール

[vim-plug](https://github.com/junegunn/vim-plug)の場合、`init.vim`に以下を追記  

```vim
Plug 'szkny/Ipython'
```

neovimを開いて下記コマンドを実行  
```vim
:PlugInstall
```

## コマンド

| 使い方    | 説明                                                                       |
|:----------|:---------------------------------------------------------------------------|
| :Ipython  | 現在編集中のPythonスクリプトを実行する  (ipythonウィンドウが無ければ開く ) |
| :VIpython | Visual modeで選択している行を実行する  (ipythonウィンドウが無ければ開く )  |


## キーマッピング (おすすめ)

`init.vim`に以下を追加  

```vimscript
nnoremap  <leader>ip  :Ipython<CR>
vnoremap  <leader>ip  :VIpython<CR>
```

## Ipythonの起動オプションを指定する

`init.vim`にリストで定義  

```vimscript
let g:ipython_startup_options = [
            \'--no-confirm-exit',]

let g:ipython_startup_import_modules = [
            \'import matplotlib.pyplot as plt',
            \'import pandas as pd',
            \'import numpy as np']
```

以下はデフォルト  

```vimscript
let g:ipython_startup_options = [
            \'--no-confirm-exit',
            \'--colors=Linux',
            \'--no-banner']

let g:ipython_startup_options = []
```

## 関数

| 名前                 | 説明                                   |
|:---------------------|:---------------------------------------|
| ipython#open()       | ipythonウィンドウを開く                |
| ipython#close()      | ipythonウィンドウを閉じる              |
| ipython#exist()      | ipythonウィンドウの存在確認            |
| ipython#run()        | 現在編集中のPythonスクリプトを実行する |
| ipython#run_visual() | Visual modeで選択している行を実行する  |
