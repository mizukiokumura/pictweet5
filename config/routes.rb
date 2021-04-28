Rails.application.routes.draw do
  root to: 'tweets#index'
  resources :tweets
end

# CRUDとは
# アプリケーションのデータ取扱に関して、基本的な処理の頭文字を並べたもの。
# アプリケーションの機能は、この４つの処理を組み合わせながら実装する。
# C(Create) | R(Read)   | U(Update)    | D(Delete)     |
# 生成       | 読み取り   | 更新          | 削除する       |
# 生成し読み取り、更新し、削除する。
# Railsではこれらを更に「７つのアクション」に分割して、処理を実現する。

# 7つのアクション
# CRUDを実現するためには、それぞれの処理を記述する必要がある。
# Railsではアクションが慣習的に決められており、下記の表のようなアクションが存在する。

# index   | 一覧表示
# show    | 詳細表示
# new     | 生成
# create  | 保存
# edit    | 編集
# update  | 更新
# destroy | 削除

# これらはresourcesメソッドで一度に設定可能

# resourcesメソッドは
# 7つのアクションへのルーティングを自動生成するメソッド。
# resourcesの引数に、:tweetsというシンボルを指定すると、/tweetsのパスに対応するルーティングが生成される。
# resourcesにonlyオプションを加えると、指定したアクションのみのルーティングを自動で生成する。
# オプション名: :追加したいアクション名と「シンボル型」で記述する。

# rails d controllerコマンド
# rails d controllerは、指定したコントローラーを削除するコマンド。
# 書き方は
# rails d controller 削除するコントローラー名

# prefix
# ルーティングのURI Patternに名前をつけて変数化したもので、これにより、
# URI Patternの代わりにPrefixを用いてパスを表現できる。
# prefix名_pathと記述を加えることによってURI Patternとして認識される。

# またprefixを用いる前は特定のIDを削除し際場合、"/tweets/#{tweet.id}"と記述していたところを
# prefixの場合はtweet_path(tweet.id)のように引数として渡す。