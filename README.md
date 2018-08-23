# Ipython

## 概要

neovimのターミナルモードからipythonを呼び出すプラグインです。  
`szkny/SplitTerm`を利用しています。

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

| 使い方  | 説明                                                                       |
|:--------|:---------------------------------------------------------------------------|
| :Python | 現在編集中のPythonスクリプトを実行する  (ipythonウィンドウが無ければ開く ) |

## 関数

| 名前            | 説明                                   |
|:----------------|:---------------------------------------|
| ipython#open()  | ipythonウィンドウを開く                |
| ipython#close() | ipythonウィンドウを閉じる              |
| ipython#exist() | ipythonウィンドウの存在確認            |
| ipython#run()   | 現在編集中のPythonスクリプトを実行する |
