require 'rails_helper'

RSpec.describe "Tweets", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @tweet_text = Faker::Lorem.sentence
    @tweet_image = Faker::Lorem.sentence
  end

  context 'ツイート投稿ができる時' do
    it 'ログインしたユーザーは新規投稿できる' do
      # ログインする
      visit new_user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 新規投稿ページへのボタンがあることを確認する
      expect(page).to have_content('投稿する')
      # 投稿ページに移動する
      visit new_tweet_path
      # フォームに情報を入力する
      fill_in 'tweet_image', with: @tweet_image
      fill_in 'tweet_text', with: @tweet_text
      # 送信するとTweetモデルのカウントが１上がることを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Tweet.count}.by(1)
      # 送信完了ページに遷移することを確認する
      expect(current_path).to eq(tweets_path)
      # 「投稿が完了しました」の文字があることを確認する
      expect(page).to have_content('投稿が完了しました。')
      # トップページに遷移する
      visit root_path
      # トップページには先ほど投稿した内容のツイートが存在することを確認する(画像)
      expect(page).to have_selector ".content_post[style='background-image: url(#{@tweet_image});']"
      # トップページには先ほど投稿した内容のツイートが存在することを確認する(テキスト)
      expect(page).to have_content(@tweet_text)
    end
  end
  context 'ツイート投稿ができない時' do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 新規投稿ページへのボタンがないことを確認する
      expect(page).to have_no_content('投稿する')
    end
  end
end
RSpec.describe 'ツイート編集', type: :system do
  before do
    @tweet1 = FactoryBot.create(:tweet)
    @tweet2 = FactoryBot.create(:tweet)
  end
  context 'ツイート編集ができる時' do
    it 'ログインしたユーザーは自分が投稿してツイートの編集ができる' do
      # ツイート１を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'Email', with: @tweet1.user.email
      fill_in 'Password', with: @tweet1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # ツイート１に「編集」へのリンクがあることを確認する
      expect(
        all('.more')[1].hover
      ).to have_link '編集', href: edit_tweet_path(@tweet1)
      # 編集ページへ遷移する
      visit edit_tweet_path(@tweet1)
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(
        find('#tweet_image').value
      ).to eq(@tweet1.image)
      expect(
        find('#tweet_text').value
      ).to eq(@tweet1.text)
      # 投稿内容を編集する
      fill_in 'tweet_image', with: "#{@tweet1.image} + 編集した画像URL"
      fill_in 'tweet_text', with: "#{@tweet1.text} + 編集したテキスト"
      # 編集してもTweetモデルのカウントは変わらないことを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Tweet.count}.by(0)
      # 編集完了画面に遷移したことを確認する
      expect(current_path).to eq(tweet_path(@tweet1))
      #「更新が完了しました」の文字があることを確認する
      expect(page).to have_content('更新が完了しました。')
      # トップページに遷移する
      visit root_path
      # トップページには先ほど変更した内容のツイートが存在することを確認する(画像)
      expect(page).to have_selector ".content_post[style='background-image: url(#{@tweet1.image} + 編集した画像URL);']"
      # トップページには先ほど変更した内容のツイートが存在することを確認する(テキスト)
      expect(page).to have_content("#{@tweet1.text} + 編集したテキスト")
    end
  end
  context 'ツイート編集ができない時' do
    it 'ログインしたユーザーは自分以外が投稿したツイートの編集画面には遷移できない' do
      # ツイート１を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'Email', with: @tweet1.user.email
      fill_in 'Password', with: @tweet1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # ツイート２に「編集」へのリンクがないことを確認する
      expect(
        all('.more')[0].hover
      ).to have_no_link '編集', href: edit_tweet_path(@tweet2)
    end
    it 'ログインしていないとツイートの編集画面には遷移できない ' do
      # # トップページにいる
      visit root_path
      # # ツイート1に「編集」へのリンクがないことを確認する
      expect(
        all('.more')[1].hover
      ).to have_no_link '編集', href: edit_tweet_path(@tweet1)
      # # ツイート2に「編集」へのリンクがないことを確認する
      expect(
        all('.more')[0].hover
      ).to have_no_link '編集', href: edit_tweet_path(@tweet2)
    end
  end
end
RSpec.describe 'ツイート削除', type: :system do
  before do
    @tweet1 = FactoryBot.create(:tweet)
    @tweet2 = FactoryBot.create(:tweet)
  end
  context 'ツイートが削除できる時' do
    it 'ログインしたユーザーは自らが投稿したツイートの削除ができる' do
      # ツイート１を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'Email', with: @tweet1.user.email
      fill_in 'Password', with: @tweet1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # ツイート１に「削除」へのリンクがあることを確認する
      expect(
        all('.more')[1].hover
      ).to have_link '削除', href: tweet_path(@tweet1)
      # 投稿を削除するとレコードの数が１ヘルことを確認する
      expect{
        all('.more')[1].hover.find_link('削除', href: tweet_path(@tweet1)).click
      }.to change { Tweet.count }.by(-1)
      # 削除完了画面に遷移したことを確認する
      expect(current_path).to eq(tweet_path(@tweet1))
      # 「削除が完了しました」の文字があることを確認する
      expect(page).to have_content('削除が完了しました。')
      # トップページに遷移する
      visit root_path
      # トップページにはツイート１の内容が存在しないことを確認する(画像)
      expect(page).to have_no_selector ".content_post[style='background-image: url(#{@tweet1.image});']"
      # トップページにはツイート１の内容が存在しないことを確認する（テキスト）
      expect(page).to have_no_content("#{@tweet1.text}")
    end
  end
  context 'ツイート削除ができない時' do
    it 'ログインしたユーザーは自分以外が投稿したツイートの削除ができない' do
      # ツイート１を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'Email', with: @tweet1.user.email
      fill_in 'Password', with: @tweet1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # ツイート２に「削除」へのリンクがないことを確認する
      expect(
        all('.more')[0].hover
      ).to have_no_link '削除', href: tweet_path(@tweet2)
    end
    it 'ログインしていないとツイートの削除ボタンがない' do
      # トップページに移動する
      visit root_path
      # ツイート１に「削除」へのリンクがないことを確認する
      expect(
        all('.more')[1].hover
      ).to have_no_link '削除', href: tweet_path(@tweet1)
      # ツイート２に「削除」へのリンクがないことを確認する
      expect(
        all('.more')[0].hover
      ).to have_no_link '削除', href: tweet_path(@tweet2)
    end
  end
end
RSpec.describe 'ツイート詳細', type: :system do
  before do
    @tweet = FactoryBot.create(:tweet)
  end
  it 'ログインしたユーザーはツイート詳細ページに遷移してコメント投稿欄が表示される' do
    # ログインする
    visit new_user_session_path
    fill_in 'Email', with: @tweet.user.email
    fill_in 'Password', with: @tweet.user.password
    find('input[name="commit"]').click
    expect(current_path).to eq(root_path)
    # ツイート「詳細」へのリンクがあることを確認する
    expect(
      all('.more')[0].hover
    ).to have_link '詳細', href:tweet_path(@tweet)
    # 詳細ページに遷移する
   visit tweet_path(@tweet)
    # 詳細ページにツイートの内容が含まれている
    expect(page).to have_selector ".content_post[style='background-image: url(#{@tweet.image});']"
    expect(page).to have_content("#{@tweet.text}")
    # コメント用のフォームが存在する
    expect(page).to have_selector 'form'
  end
  it 'ログインしていな状態でツイート詳細ページに遷移できるもののコメント投稿欄が表示されない' do
    # トップページに移動する
    visit root_path
    # ツイートに「詳細」へのリンクがあることを確認する
    expect(
      all('.more')[0].hover
    ).to have_link '詳細', href: tweet_path(@tweet)
    # 詳細ページに遷移する
    visit tweet_path(@tweet)
    # 詳細ページにツイートの内容が含まれている
    expect(page).to have_selector ".content_post[style='background-image: url(#{@tweet.image});']"
    expect(page).to have_content("#{@tweet.text}")
    # フォームが存在しないことを確認する
    expect(page).to have_no_selector 'form'
    # 「コメントの投稿には新規登録/ログインが必要です」と表示されていることを確認する
    expect(page).to have_content("コメントの投稿には新規登録/ログインが必要です")
  end
end
# ツイート投稿に関するexmpleを整理する。
# ・ツイート投稿ができる時
# ログインしたユーザーは新規投稿ができる
# ログインする
# 新規投稿ペー位へのボタンがあることを確認する
# 投稿ページに移動する
# フォームに情報を入力する
# 送信するとTweetモデルのカウントが１上がることを確認する
# 投稿完了ページに遷移することを確認する
# 「投稿が完了しました」の文字があることを確認する
# トップページに遷移する
# トップページには先程投稿した内容のツイートが存在することを確認する(画像)
# トップページには先程投稿した内容のツイートが存在することを確認する(テキスト)
# ・ツイートが投稿できない時
# ログインしていないと新規投稿ページに遷移ができない
# トップページに遷移する
# 新規投稿ページへのボタンがないことを確認する

# before内の記述におけるポイントは
# ・ユーザーはあらかじめ保存しておくこと
# ・@tweet_imageや@tweet_textという、ツイート投稿した文字をあらかじめ生成してインスタンス変数に代入すること

# have_selector
# 指定したセレクタが存在するかどうかを判断するマッチャです
# 例
# have_selector ".content_pos[style=background-image: url(#{@tweet_image});']"
# と記述する

# beforeに着目すると、@tweet1と@tweet2というインスタンスを生成している。
# FactoryBotの記述で、Tweetを生成するときに紐づくUserも同時に生成するようにしました。
# したがって、それぞれ違うインスタンスを生成すると、別々のユーザーが作成できる

# have_linkマッチャ
# expect('要素'),to have_link 'ボタンの文字列', href: 'リンク先のパス'と記述することで、
# 要素の中に当てはまるリンクがあるかどうかを確認できる、have_linkはa要素に対して用いる

# hve_no_linkマッチャ
# have_linkの逆で、当てはまるリンクがないことを確認する。expect('要素').to have_no_link 'ボタンの文字列', href: 'リンク先のパス'と記述することで、
# 要素の中に当てはまるリンクがないことを確認できる。

# all
# all('クラス名')でpageに存在する同盟のクラスをもつ要素をまとめて取得できる。
# そしてall('クラス名')[0]のように「添字」を加えることで「丸番目のmoreクラス」という取得の仕方ができる。

# find_link().click
# a要素で表示されているリンクをクリックするために用いる
# find_link('リンクの文字列', href: 'URL').clickといった形で使います。
# find_link().clickはa要素だけに用いることができる。