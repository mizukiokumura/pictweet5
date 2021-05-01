class Tweet < ApplicationRecord
  validates :text, presence: true
  belongs_to :user
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
