class Tweet < ApplicationRecord
  validates :text, presence: true
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