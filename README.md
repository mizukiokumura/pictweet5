# 新規railsアプリを作成時、エラーが出た時の対処法
エラー例(ターミナル)

Installing mysql2 0.5.3 with native extensions

Gem::Ext::BuildError: ERROR: Failed to build gem native extension.

current directory: /Users/user_name/Programs/web/foobar-repo/vendor/bundle/ruby/2.5.1/gems/mysql2-0.5.3/ext/mysql2

/Users/user_name/.rbenv/versions/2.5.1/bin/ruby -r

(中略)

An error occurred while installing mysql2 (0.5.3), and Bundler cannot continue.
Make sure that `gem install mysql2 -v '0.5.3'` succeeds before bundling.

このようなエラーが出た場合、
ターミナルで以下のコマンドをうつ
bundle config --delete build.mysql2
bundle config --global build.mysql2 --with-opt-dir="$(brew--prefix)"
cd ~/projects/pictweet
bundle install

devise

ユーザー管理機能を簡単に実装するためのgemです。実際に運用されている多くのRailsアプリケーションサービスで使用されている。

rails g devise:installコマンド
このコマンドは、追加したdeviseというGemの「設定関連にしようするファイル」を自動で生成してくれるコマンド。

rails g deviseコマンド
deviseによるユーザー機能の対象を指定することで、モデルとマイグレーションの生成やルーティングの設定などをまとめて処理する。
実行すると、モデルが生成され、routes.rbにはdeviseに関連するパスが追加される。

rails g devise:viewsコマンド
deviseに用意されたビューファイルをコピーし、app/viewsの配下に配置してくれるコマンド。HTMLを修正できるため、カスタマイズ可能になる。

rails g migrationコマンド
マイグレーションを生成するコマンド
すでに作成されたテーブルの内容を変更する際などに使用する。
指定するファイルの舐めによって、どのようなテーブル操作を行うかを自動で記述する。
rails g migration Addカラム名To追加先のテーブル名 追加するカラム名:型
と記述することで、テーブルにカラムを追加する際に必要なコードが記述された状態で、マイグレーションが生成される。
例)
rails g migration AddNicknameToUsers nickname:string

スネークケースとキャメルケース
スネークケースとキャメルケースとは、それぞれ単語の区切り方を表したもの。
スネークケースは、単語の区切りをアンダースコアで
キャメルケースは、単語の区切りを大文字で
例）スネークケース
admin_user_session

例）キャメルケース
adminUserSession

例）アッパーキャメルケース
AdminUserSession

スネークケースは主に「メソッド名」や「変数名」につかい。
アッパーキャメルケースは「クラス名」に使う。