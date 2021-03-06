class TweetsController < ApplicationController
  before_action :set_tweet, only: [:edit, :show]
  before_action :move_to_index, except: [:index, :show, :search]
  def index
    @tweets = Tweet.includes(:user).order("created_at DESC")
  end

  def new
    @tweet = Tweet.new
  end

  def create
    Tweet.create(tweet_params)
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
  end

  def edit
  end

  def update
    tweet = Tweet.find(params[:id])
    tweet.update(tweet_params)
  end

  def show
    @comment = Comment.new
    @comments = @tweet.comments.includes(:user)
  end

  def search
    @tweets = Tweet.search(params[:keyword])
  end

  private
  def tweet_params
    params.require(:tweet).permit(:image,:text).merge(user_id: current_user.id)
  end
  
  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end
  
end

# ストロングパラメーター
# 指定したキーをもつパラメーターのみを受け取るように制限するもの。
# これをしようする理由は、受け取るパラメーターを制限しなければ、使用以外のパラメーターも使われてしまう危険性が発生するためです。
# この状態だと、意図しないデータの更新をされる可能性が発生する。
# ストロングパラメーターの定義には、requireとpermitメソッドを組み合わせて使う。

# requireメソッド
# 送信されたパラメーターの情報をもつparamsが、使用できるメソッド、
# requireメソッドは、パラメーターからどの情報を取得するか、選択する。
# ストロングパラメーターとしてしようする場合は、主にモデル名を指定する。
# params.reiqure(:モデル名) 
# params[:モデル名]としても同じっ情報を取得できるが、
# requireを使うことで、「意図しないパラメーターであった場合にエラーとして返す」事ができ、
# 原因の特定やユーザーにエラーをしますなどの対応が可能。
# params  #=> 中身は以下の内容
# {
#   "utf8" => "✓",
#   "authenticity_token" => "token",
#   "モデルA" => {
#     "image" => "image.jpg",
#     "text" => "sample text"
#   },
#   "commit" => "SEND",
#   "controller" => "hoges",
#   "action" => "create"
# }

# params.require(:モデルA)
# #=> { "image" => "image.jpg", "text" => "sample text" }

# params[:モデルA]  # 結果は同じだが、もしモデルAが存在しない場合はエラーになってくれない
# #=> { "image" => "image.jpg", "text" => "sample text" }

# params.require(:commit)  # モデル名以外のキーも指定できる
# #=> "SEND"

# paramsに入っている値は、リクエストの内容によって様々なので、もしフォームを利用した場合は、
# 「フォームに紐づくモデルの名前がキーになっておくられる。」

# permitメソッド
# requireメソッドと同様に、「params」が使用できるメソッドです。
# permitメソッドをしようすると、取得したいキーを指定でき、指定したキーと値のセットのみを取得します。
# params.require(:モデル名).permit(:キー名, :キー名, ・・・)
# permitメソッドでparams.requireの内容からキーを指定すると、それ以外のキーがあっても値を受け付けない。
# params.require(:post)
# #=> { "image" => "image.jpg", "text" => "sample text" }

# params.require(:post).permit(:image)  # imageのみを指定（textは取得されない）
# #=> { "image" => "image.jpg" }

# params.require(:post).permit(:image, :text)  # 指定したパラメーターだけの取得を約束する
# #=> { "image" => "image.jpg", "text" => "sample text" }

# プライベートメソッド
# クラス外から呼び出すことのできないメソッドのこと。
# Rubyでは、privateと記述した以下のコードがプライベートメソッドとなる
# private # private以下の記述は全てプライベートメソッドになる。
# メリットは、
# １.Classの外部から呼ばれたら困るメソッドを隔離
# メソッドの中には、Classの外部から呼び出されてしまうとエラーを起こすメソッドも存在する。
# そのため、誤って呼び出すなどのエラーを事前に防ぐ事ができる。
# 2.可読性
# Classの外部から呼び出されるメソッドを探すときに、private以下の部分は目を通さなくて良くなり読みやすくなる。

# before_action
# コントローラで定義されたアクションが実行される前に、共通の処理を行う事ができる。
# 書き方は
# before_action :処理させたいメソッド名

# onlyオプション
# resourcesと同様にonlyやexceptなどのオプションをしようすることによって、どの
# アクションの実行前に、処理を実行させるかなど制限が可能

# リダイレクト
# 「本来受け取ったパスとは別のパスを転送する」機能のことをリダイレクトという。
# これを使うと、アクションに処理を持たせたまま、別のパスを記述する事ができる。

# unlessとは
# ifと同様に、条件式の返り値で条件分岐して処理を実行するRubyの構文。
# ifはtrueの時unlessはfalseの時にelseまでの処理が実行される。
# 書き方
# unless 条件式
#   # 条件式がfalseの時に実行する処理
# end

# redirect_toメソッド
# Railsでリダイレクト処理を行う際に使用するメソッド
# コントローラーなどでの処理が終わった後、アクションに体操するビューファイルを参照せずに、別のページへリダイレクトされる事ができる。
# 書き方は
# redirect_to action: :リダイレクト先となるアクション名

# exceptオプション
# before_actionで使用できるオプション[除外]という意味がある。

# current_userメソッド
# deviseをが持っているメソッドで、現在ログインしているユーザーの情報を取得できる。

# mergeメソッド
# 「ハッシュ」を結合させるときに使用する「Ruby」のメソッド
# tweet情報のハッシュとuser_idを持つハッシュを結合させる
# 例)
# tweet = { name: "たなか", text: "test", image: "test.jpeg" }
# uid = { user_id: "1" }
# tweet.merge(uid)
# => {:name=>"たなか", :text=>"test", :image=>"test.jpeg", :user_id=>"1"}

# テーブルから不要になったカラムの削除方法
# rails g migration Removeカラム名From削除元テーブル名 削除するカラム:型
# rails g migration RemoveNameFromTweets name:string
# rails db:migrate

# orderメソッド
# モデルが使用できる、ActiveRecordメソッドの一つで
# orderメソッドは、テーブルから取得してきた複数のレコード情報を持つインスタンスの「並び順」を変更するメソッド。
# 引数に、(並び替えの基準となるカラム名 並び順)のように書く
# インスタンス = モデル名.order("並び替えの基準となるカラム名 並び順" )
# 並び順は２つあり、
# ・ASC(昇順) 小さいものから大き物になる。古いものから新しい物になる。
# ・DESC(降順) ASCの反対

# tweets/show.html.erbでform_withを使用して、comments#createを実行するリクエストを飛ばしたいので、
# showにコメントのインスタンスを生成しておく必要がある。
# tweetテーブルとcommentsテーブルはアソシエーションが組まれているので、@tweet.commentsとすることで、@tweetへ投稿された全ての
# コメントを取得できる。またN+1問題も発生するので、includesメソッドを使用する。

# def search
#   @tweets = Tweet.search(params[:keyword])
# end

# Tweetモデルに書いたsearchメソッドを呼び出している。
# searchメソッドの引数にparams[:keyword]と記述して、検索結果を渡している。
# また、このままでは、未ログイン時に検索をするとトップページへリダイレクトされてしまうので、
# これを回避するために、move_to_indexのexceptオプションで:searchを追加し除外している。