FactoryBot.define do
  factory :tweet do
    text {Faker::Lorem.sentence}
    image {Faker::Lorem.sentence}
    association :user
  end
end

# 5行目のassociation :userの記述は
# users.rbの「FactoryBotとアソシエーションがありますよ」ということを意味している。
# つまり、Tweetのインスタンスが生成したと同時に、関連するUserのインステンスも生成してくれる。

# Tweetモデルで検討すべきexamleを整理。
# Userモデルの時と同様に、どのような時に新規投稿できて、どのような時に新規投稿できないのかを、Tweetモデルのバリデーションを参考にして考える。
# class Tweet < ApplicationRecord
#   validates :text, presence: true
#   belongs_to :user
#   has_many :comments

#   def self.search(search)
#     if search!=""
#       Tweet.where('text LIKE(?)', "%#{search}%")
#     else
#       Tweet.all
#     end
#   end
# end

# textカラムにはpresenceのバリデーション
# アソシエーションを示すbelongs_to :userには、「TweetはUserに属している必要がある」という制約が含まれている。
# まとめるとexampleは
# ・画像とテキストがあれば投稿できる。
# ・テキストがあれば投稿できる。
# ・テキストが空では投稿できない
# ・ユーザーが紐づいていなければ投稿できない。
