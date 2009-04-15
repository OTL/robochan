# Robochan ver.2

2009/04/16 UITabBarControllerに対応

☆iPodでのインストール方法☆
$ make
$ make install (二回目以降はmake cpで)
iPodでタッチ

☆Cygwinでのインストール方法☆
% make
% make install
% ./Robochan.exe


☆フォルダ構成☆

./ ----- Classes           .... 共通ソースファイル
     |
     --- Classes.Darwin    .... iPhone用ソースファイル
     |
     --- Classes.CYGWIN    .... Cygwin用ソースファイル
     |
     --- Resources         .... リソース格納ファイル

