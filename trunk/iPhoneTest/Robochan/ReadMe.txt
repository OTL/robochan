# Robochan

☆iPodでのインストール方法☆
$ make
$ make install (二回目以降はmake cpで)
iPodでタッチ

☆iPodでの操作方法☆
ドラッグで視点移動
マルチタッチドラッグで近づく・遠ざかる

☆Cygwinでのインストール方法☆
% make
% make install
% ./Robochan.exe

☆Cygwinでの操作方法☆
左ドラッグで視点移動
右ドラッグで近づく・遠ざかる

☆フォルダ構成☆

./ ----- Classes           .... 共通ソースファイル
     |
     --- Classes.Darwin    .... iPhone用ソースファイル
     |
     --- Classes.CYGWIN    .... Cygwin用ソースファイル
     |
     --- Resources         .... リソース格納ファイル

