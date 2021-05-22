require 'rails_helper'

RSpec.describe "Comments", type: :system do
  before do
    @tweet = FactoryBot.create(:tweet)
    @comment = Faker::Lorem.sentence
  end

  it 'ログインしたユーザーはツイート詳細ページでコメント投稿できる' do
    # ログインする
    sign_in(@tweet.user)
    # ツイート詳細ページに遷移する
    visit tweet_path(@tweet)
    # フォームに情報を入力する
    fill_in 'コメントする', with: @comment
    # fill_in 'comment_text', with: @commentでも可能
    # コメントを送信すると、Commentモデルのカウントが１上がることを確認する
    expect{
      find('input[name="commit"]').click
    }.to change{ Comment.count}.by(1)
    # 詳細ページにリダイレクトされることを確認する
    expect(current_path).to eq(tweet_path(@tweet))
    # 詳細ページ上に先ほどのコメント内容が含まれていることを確認する
    expect(page).to have_content(@commnet)
  end
end
# テストコードをまとめる
# 同じ処理を繰り返している箇所を確認しよう
# 結合テストコードを振り返り、特に同じ処理を繰り返しているのはログインのステップです、ログインしている時/していないときを
# ハンベルするため、記述しないわけにはいかなくなってくる
# このログインの流れを１つのまとまり。メソッドにまとめてしまう
# この時に使用するのがサポートモジュール

# サポートモジュール
# RSpecに用意されている、メソッドなどをまとめる機能