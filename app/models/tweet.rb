class Tweet < ApplicationRecord
  validates :text, presence: true
  belongs_to :user
  has_many :comments

  def self.search(search)
    if search != ""
      Tweet.where('text LIKE(?)', "%#{search}%")
    else
      Tweet.all
    end
  end
end

# バリデーション
# データを登録する際に、一体の制約をかけることをいい、例えば、
# 空のデータを登録できないようにする。
# すでに登録されている文字列を登録できないようにする。
# 文字数制限をかける。
# バリデーションを設ける際は、モデルにvalidatesメソッドを記述する。

# validates
# バリデーションを設定するときにしようするメソッド。
# 書き方は
# Model名.rbに
# validates :カラム名, バリデーションの種類
# 例えばnameが空ではないか調査したい場合、
# validates :name, presence: true
# と書く

# has_manyメソッド
# Userモデルの視点で考えると、あるユーザーの作成した投稿は複数個ある状態です。
# つまり、1人のユーザーは複数の投稿を所有しています。

# この状態のことをhas manyの関係といい、今回の場合は「User has many Tweets」の状態であると言えます。
# この関連付けをするため、userと他のモデルとの間に「1対多」のつながりがあることを示すのがhas_manyメソッドです

# belongs_toメソッド
# 1つの投稿は、1人のユーザーが投稿したものです。
# つまり1つの投稿を複数人が投稿できないため、投稿は必ず1人のユーザーに所属します。

# この状態のことをbelongs toの関係といい、今回の場合は「Tweet belongs to User」の状態であると言えます。

# Tweetモデルと他のモデル（User）との間に「1対1」のつながりがあることを示すのがbelongs_toメソッドです。

# whereメソッド
# 「モデル」が使用できる、ActiveRecordメソッドの一つで
# モデル名.where(条件)のように、引数の部分に条件を指定することで、テーブル内の「条件に一致したレコードのインスタンス」を
# 「配列」の形で取得できる。
# 引数の条件には、「検索対象となるカラム」を必ず含めて、条件式を記述する。

# 例)
# モデル.where('検索対象となるカラムを含む条件式')
# 条件式には'カラム名 > 5'やキーバリューの形でカラム名: 値などの記述が可能
# whereメソッドを連続して記述する事によって複数の条件に一致したレコードを取得することもできる。

# # idが3未満のtweetsテーブルのインスタンスを配列で取得
# [1] pry(main)> Tweet.where('id < 3')
# => [＃<Tweet id: 1, image: "test1.jpg", text: "いい景色だ。", created_at: "2014-12-06 00:00:00", updated_at: "2014-12-06 00:00:00", user_id: 1>,＃<Tweet id: 2, image: "test2.jpg", text: "Thank you!", created_at: "2014-12-07 00:00:00", updated_at: "2014-12-07 00:00:00", user_id: 2>]

# # idが3未満かつuser_idが1のtweetsテーブルのインスタンスを配列で取得
# [2] pry(main)> Tweet.where('id < 3').where(user_id: 1)
# => [＃<Tweet id: 1, image: "test1.jpg", text: "いい景色だ。", created_at: "2014-12-06 00:00:00", updated_at: "2014-12-06 00:00:00", user_id: 1>]

# LIKE句
# 曖昧な文字列の検索をするときに使用するもので、
# whereメソッドと一緒に使う。

# 曖昧文字列について
# | 文字列   |  意味                                     |
# |   %     | 任意の文字列(空白文字列含む)                  |
# |   _     | 任意の1文字                                |

# 実行時サンプル
# | 実行例                         |  詳細                         |
# | where('title LIke(?)', "a%")  | aから「始まる」タイトル          |
# | where('title LIKE(?)', "%b")  | bで「終わる」タイトル            |
# | where('title LIKE(?)', "%c%") | cが「含まれる」タイトル          |
# | where('title LIKE(?)', "d_")  | dで始まる「２文字」のタイトル     |
# | where('title LIKE(?)', "_e")  | eで終わる「２文字」のタイトル     |

# def self.search(search)
#   if search != ""
#     Tweet.where('text LIKE(?)', "%#{search}%" )
#   else
#     Tweet.all
#   end
# end

# 引数のsearchは、検索フォームから送信されたパラメーターが入るため、
# if search != ""と記述し、検索フォームに何らかの値が入力されていた場合を条件としている。
# 実際の開発現場でも、テーブルとのやりとりに関する「メソッド」はモデルに置くという意識が必要。