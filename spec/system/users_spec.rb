require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録できる時' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'Nickname', with: @user.nickname
      fill_in 'Email',    with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password_confirmation
      # サインアップボタンを押すとユーザーモデルのカウントが１上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{ User.count }.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(
        find('.user_nav').find('span').hover
      ).to have_content('ログアウト')
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する。
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end

  end
  context 'ユーザー新規登録できない時' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'Nickname', with: ''
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する。
      expect {
        find('input[name="commit"]').click
      }.to change { User.count}.by(0)
      # 新規登録ページへ戻されることを確認する。
      expect(current_path).to eq user_registration_path
    end
  end


end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログインができる時' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(
        find('.user_nav').find("span").hover
      ).to have_content('ログアウト')
      # サインアップページへsnにするボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content("新規登録")
      expect(page).to have_no_content("ログイン")
    end
  end

  context 'ログインができない時' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

# 結合テストコードと単体テストコードの違い
# 単体テストコードは機能ごと(コントローラー、モデルなど)にテストを行う。
# 結合テストコードは「ユーザーの操作を再現」してテストを行う。
# このように結合テストコードは、ユーザーがたどる一連お流れを確認するモデ、結合テストコードを実行するためには、System Specという記述を使用する。

# System Spec
# 結合テストコードを記述するための仕組みのことをいう。お枠の記述はこれまでと変われない。
# System Specを記述するためには、CapybaraというGemを用いる。
# これはすでにデフォルトでRuby on Railsに搭載されている。

# Capybara
# System Specを記述するために必要なGemde
# gemfileに標準で記載されている。

# exmpleを整理する。
# ユーザー新規登録に関するexmpleを整理する。まずは、以下のように新規登録ができる場合とできない場合を考える、
# １、ユーザー新規登録ができる時
# ２、ユーザー新規登録ができない時
# そして、それぞれどのようなケースがあるか考える。この時のポイントは、「ユーザーの目線(使用者)で考える」こと、あまり細かく考えずに、「ブラウザでどのような操作をすると、どうなるか」を考える。
# ・ユーザー新規登録できる時
#  正しい情報を入力すればユーザー新規登録ができてトップページに移動する。
# ・ユーザー新規特録画できない時
#  誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる。
# そして結合テストコードのexampleを洗い出すときは、それぞれどのような挙動が起きるのか、
# この段階で深掘りをすることです、以下のように、細かくユーザーがブラウザでどのような操作をするのか考える。
# ・ユーザー新規登録ができる時
#  正しい情報を入力すればユーザー新規登録ができてトップページに移動する。
#  トップページに移動する
#  トップページにサインアップページへ遷移するボタンがある。
#  新規登録ページへ移動する。
#  ユーザー情報を入力する。
#  サインアップボタンを押すとユーザーモデルのカウントが１上がる
#  トップページへ遷移したことを確認する
#  カーソルを合わせるとログアウトボタンが表示される
#  サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていない
# ・ユーザー新規登録ができない時
#  誤った情報ではユーザー新規登録できずに新規登録ページへ戻ってくる
#  トップページに移動する
#  トップページにサインアップページへ遷移するボタンがある
#  新規登録ページへ移動する
#  ユーザー情報を入力する
#  サインアップボタンを押してもユーザーモデルのカウントは上がらない
#  新規登録ベージへ戻される。
# このように、細かく仕様を「言語化」する必要がある。

# visit
# visit 〇〇_pathのように記述すると、００のページへ遷移することを表現できる。
# RequestSpecで学んだgetと似ていますが、getはあくまで「リクエストを送るだけ」
# のことを意味し、visitは「そのページに実際に移動する」ことを意味する

# page
# visitで訪れた先のページの見える分だけの情報が格納されている。
# 後述する通り、「ログアウト」などのカーソルを合わせて初めてみることができる文字列は
# pageの中には含まれていない(javascriptはダメということ)

# have_content
# expect(page).to have_content('X')と記述すると、visitで訪れたpageの中に、Xという文字列があるかどうかを判断するマッチャ

# fill_in
# fill_in 'フォームの名前', with: '入力する文字列'のように記述することで、フォームへの入力を行うことができる。

# 検証ツール
# ブラウザに標準で備わっている、HTMLの要素や、適用されているCSSのコードを確認することができる機能で、ブラウザで右クリックし、
# 「検証」をクリックすると表示できる。
# <div class="field">
#   <label for="user_nickname">Nickname</label> ←forに指定されているIDとinputの値が同一この部分をfill_inの部分に書く
#                                                   ↓
#   <input type="text" name="user[nickname]" id="user_nickname">
# </div>


# find().click
# find('クリックしたい要素').clickと記述することで、実際にクリックができる。
# input要素の場合はname属性を指定する、
# 例
# find('input[name="commit"]').click

# change
# expect{
#   何かしらの動作
# }.to change { モデル名.count }.by(1)と記述することによって、モデルのレコードの春日いくつ変動するのかを確認できる。
# changeマッチャでモデルのカウントをする場合のみ、expect()ではなく{}(波括弧)となる。
# 何かしらの動作の部分には「送信ボタンをクリックした時」がはいる。

# current_path
# 文字通り、現在いるページのパスを示す。
# expect(current_path).to eq(root_path)と記述すれば今いるページはroot_pathかどうか確認できる。

# hover
# find('ブラウザ上の要素').hoverとすることで、特定の要素にカーソルを合わせた時の動作を再現できる。

# have_no_content
# have_contentの逆で、文字列が存在しないことを確かめる抹茶