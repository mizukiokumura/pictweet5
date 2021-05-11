require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー新規登録' do
    it 'nicknameが空では登録できない' do
      user = User.new(nickname: '', email: 'test@example', password: '000000', password_confirmation: '000000')
      user.valid?
      expect(user.errors.full_messages).to include("Nickname can't be blank")
    end
    it 'emailが空では登録できない' do
      user = User.new(nickname: "abe", email: '', password: '000000', password_confirmation: '000000')
      user.valid?
      expect(user.errors.full_messages).to include("Email can't be blank")
    end
  end
end

# rails_helper.rb
# Rspecを用いてRailsの機能をテストするときに、共通の設定を書いておくファイルで、各テスト用ファイルで
# spec/rails_helper.rbを読み込むことで、共通の設定やメソッドを適用する。
# rails gコマンドでテストファイルを生成すると、rails_helperを読み込む記述が、自動的に追加される。

# describeメソッド
# テストコードの「グループ分け」を行うメソッドで。
# 「どの機能に対してのテストを行うか」をdescribeでグループ分けし、その中に各テストコードを
# 記述する。describeの中にdescribeを書くことで入子構造も可能。
# describe 'テスト内容' do ~ endと書くことでどの機能に対してテストを行うか明記できた

# itメソッド
# describe同様に、グループ分けを行うメソッドで、
# itの場合はより詳細に、「desctibeメソッドに記述した機能において、どのような状況のテストを行うか」を明記する。
# itメソッドで分けたグループを、exampleともよぶ。

# exampleメソッド
# itで分けたグループのことを指したり、itに記述した内容のことを指す場合もある。

# bundle execコマンド
# gemの依存関係を整理してくれるコマンドで、
# Rspecを初め、多くのGemはそのほかのGemと関係があり、互いに依存しているので、
# bundle execコマンドを用いて、gemの依存関係を整理する必要がある。

# rspecコマンド
# specディレクトリ以下に書かれたRspecのテストコードを実行するコマンド
# 実行するファイルを指定することも可能。

# 異常系モデル単体テストの流れ
# １、保存するデータ(インスタンスを)作成する
# ２、作成したデータ(インスタンス)が、保存されているかどうかを確認する。
# ３、保存されない場合は、生成されるエラ〜メッセージが想定されるものかどうかを確認する。

# valid?メソッド
# バリデーションを実行させて、エラーがあるかどうかを判断するメソッドで、
# エラーがない場合はtrue,ある場合はfalseを返し、またエラーがあると（false）だと判断された場合は、
# エラーの内容を示すメッセージを生成する。

# expectation
# 検証で得られた挙動が想定通りなのかを確認する構文のこと。
# expect().to matcher()を「雛形」に、テストの内容に応じて引数やmatcherを変えて記述する。

# matcher
# 「expectの引数」と「想定した挙動」が一致しているかどうかを判断する。
# まっちゃーしてるかどうかを判断する。
# expectの引数には検証で得られた実際の挙動を指定し、マッチャには、どのような挙動を想定しているかを記述する。
# 代表的なものにincledeとeqまっちゃがある。

# inclede
# 「expectの引数」に「includeの引数」が含まれていることを確認するマッチャで、
# 具体的には
# describe 'フルーツ盛り合わせ' do
#   it 'フルーツ盛り合わせにメロンが含まれている' do
#     expect(['りんご', 'バナナ', 'ぶどう', 'メロン']).to include('メロン')
#   end
# end
# 上記のように記述することで、りんご、バナナ、ぶどう、メロンが入った配列の中に、メロンが含まれているかどうかを想定している。

# eq
# 「expectの引数」と「eqの引数」が「等しい」ことを確認するマッチャで、
# 具体的には
# describe '加算' do
#   it '1 + 1の計算結果は2と等しい' do 
#     expect(1 + 1).to eq(2)
#   end
# end

# 上記のように記述することで、1+1の計算結果が、2と等しいことを想定している。

# errors
# インスタンスにエラーを示す情報がある場合、その内容を返すメソッドです。
# [8] pry(main)> user = User.new(nickname: '', email: 'test@example', password: '000000', password_confirmation: '000000')
# => #<User id: nil, email: "test@example", created_at: nil, updated_at: nil, nickname: "">
# [9] pry(main)> user.valid?
#   User Exists? (18.9ms)  SELECT 1 AS one FROM `users` WHERE `users`.`email` = BINARY 'test@example' LIMIT 1
# => false
# [10] pry(main)> user.errors
# => #<ActiveModel::Errors:0x00007fa7e345bef0
#  @base=#<User id: nil, email: "test@example", created_at: nil, updated_at: nil, nickname: "">,
#  @details={:nickname=>[{:error=>:blank}]},
#  @messages={:nickname=>["can't be blank"]}>
# [11] pry(main)> 

# 上記のようにnicknameでblank(空である)というエラーが起こっているのが確認できる。
# この複雑なエラーの」情報は、expectの中には記載できない、なのでここからエラーの内容を取り出していく。
# この時に使うのがfull_messagesメソッド

# full_messagesメソッド
# エラーの内容から、エラ〜メッセージを配列として取り出すメソッドで、
# ターミナルでuser.errors.full_messagesと実行すると、以下のようにエラーの内容の配列が返される。

# 11] pry(main)> user.errors.full_messages
# => ["Nickname can't be blank"]

# 以上のことを踏まえて、どのようなエクスペクテーションを記述すれば良いのか考えると、
# expectの引数には、検証で得られた挙動を指定したいため、valid?メソッドを使用した後のインスタンスのエラ〜メッセージを指定する。
# expect(user.errors.full_messages)となる。
# さらに、full_messagesの返り値は「配列」であるので、includeマッチャを用いて、配列にどのようなエラーが含まれていれば良いか指定する。
# nikcnameでpresence: trueに夜エラーが起こるはずであるため、想定するエラ〜メッセージは
# "Nickname can't be blank"となる。