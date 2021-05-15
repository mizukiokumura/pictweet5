require 'rails_helper'

describe TweetsController, type: :request do
  
  before do
    @tweet = FactoryBot.create(:tweet)
  end

  describe 'GET #index' do
    it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
      get root_path
      expect(response.status).to eq 200
    end
    it 'indexアクションにリクエストするとレスポンスに投稿済みのツイートのテキストが存在する' do 
      get root_path
      expect(response.body).to include(@tweet.text)
    end
    it 'indexアクションにリクエストするとレスポンスに投稿済みのツイートの画像URLが存在する' do
       get root_path
       expect(response.body).to include(@tweet.image)
      
    end
    it 'indexアクションにリクエストするとレスポンスに投稿検索フォームが存在する' do
      get root_path
      expect(response.body).to include('投稿を検索する')
    end

  end

  describe 'GET show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる。' do
      get tweet_path(@tweet)
      expect(response.status).to eq 200
    end
    it 'showアクションにリクエストするとレスポンスに投稿済みのツイートのテキストが存在する ' do
      get tweet_path(@tweet)
      expect(response.body).to include(@tweet.text)
    end
    it 'showアクションにリクエストするとレスポンスに投稿済みのツイートの画像URLが存在する' do
      get tweet_path(@tweet)
      expect(response.body).to include(@tweet.image)
    end
    it 'showアクションにリクエストするとレスポンスにコメント一覧表示部分が存在する。' do
      get tweet_path(@tweet)
      expect(response.body).to include('＜コメント一覧＞')
    end
  end
end

# コントローラーの単体テストコード
# モデルとコントローラーのテストコードの方針の違い。
# モデル    | インスタンスを生成し、それがモデルに規定した通りの挙動になるか（バリデーションが正しく動くか)を確かめる。
# コントローラー | あるアクションにリクエストを送った時、想定どおりのレスポンスが生成されるかどうかを確かめる。

# このように、コントローラーのテストコードでは「リクエストとレスポンス」に着目したテストコードを記述する。
# この時「Rspecの中のRequest Spec」を利用する。

# Request Spec
# Rspecが提供している、コントローラーのテストコードを書くために特化した手法で、Rspecが導入されていれば使用できる。

# exmpleの整理
# まず、indexアクションにリクエストを送った際に確認すべきexampleについて整理していく。
# indexアクションにリクエストをした際は、以下のようなことが考えられる。
# ・indexアクションにリクエストすると正常にレスポンスが返ってくる。
# ・indexアクションにリクエストするとレスポンスに投稿済みのツイートのテキストが存在する。
# ・indexアクションにリクエストするとレスポンスに投稿済みのツイートの画像URLが存在する。
# ・indexアクションにリクエストするとレスポンスに投稿検索フォームが存在する。


# createメソッド
# ActiveRecordのcreateメソッドと同様の意味を持つ。
# buildとほぼ同じ働きをするが、createの場合は、テスト用のDBに値が保存される。
# 注意すべき点として、１回テストが終了する事に、保存された内容は消去される。

# GET
# get 〇〇_pathのように、どこのパスにリクエストを送りたいかを記述する。
# どのアクションがどのパスに対応しているかは、rails routesコマンドで確かめられる。

# レスポンスの内容を確認するためにはresponseと入力する。
# response
# リクエストに対するレスポンスそのものが含まれている。
# このレスポンスで取得できる情報に、想定する内容が含まれているかを確認することで、テストコードを書くことができる。

# responseと打つと長い文章が出てくるがその中で「正常なレスポンスがどうか」を判断する必要がある。
# それを判断するためには[
# HTTPステータスコードで判別する。
# ]

# HTTPステータスコード
# HTTP通信において、どのような処理の結果となったのかを示すもので、
# 以下のような分類になっている。
# ステータスコード            | 内容                                 |
#  100 ~                   | 処理の継続中                           |
#  200 ~                   | 処理の成功                             |
#  300 ~                   | リダイレクト                           |
#  400 ~                   | クライアントエラー                      |
#  500 ~                   | サーバーエラー                         |

#  正常にレスポンスを得ることを確かめたいため、200というステータスコードを期待する。

#  status
#  response.statusと実行することによって、そのレスポンスのステータスコードを出力できる。

# body
# response.bodeと記述すると、ブラウザに表示されるHTMLの情報を抜き出すことができる。