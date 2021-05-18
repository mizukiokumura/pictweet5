FactoryBot.define do
  factory :user do
    nickname {Faker::Name.initials(number: 6)}
    email   { Faker::Internet.free_email }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
  end
end
# FactoryBotの記述を格納するディレクトリfactroiresと、Userモデルに対するFactoryBotのファイルusers.rbを作成する。
# この設定したインスタンスを生成(作る)ためには、FactoryBot.build(:user)という記述をテストコードの中に記述する必要がある。

# build 
# ActiveRecordメソッドのnewと同様の意味をもつ(new ≒ build )
# FactoryBot.build(:user)は
# User.new(nickname: 'test', ・・・・)と同じ意味を持つ。
