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