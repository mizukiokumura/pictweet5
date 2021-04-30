class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end
end

# devise_parameter_sanitizerメソッド
# deviseにおけるparamsのようなメソッドです。deviseのUserモデルに関わる「ログイン」「新規登録」などのリクエストから
# パラメーターを取得できる。
# このメソッドとpermitメソッドを組み合わせることにより、deviseに定義されているストロングパラメーターに対し、自分で新しく追加したカラムも指定して含める事ができる。
# deviseの提供元では、新たに定義するメソッド名を
# configure_permitted_parameters(日本語訳：許可されたパラメータの設定)
# 慣習的に使っている事が多い。

# private
# def configure_permitted_parameters
#   devise_parameter_sanitizer.permit(:deviseの処理名, keys: [:許可するキー])
# end
# このメソッドで使用するpermitメソッドは「devise」で定義されているメソッドであり
# railsに初めからあるメソッドとは異なる。
# deviseのpermitは第一引数に「deviseの処理名, 第二引数にキーを配列で指定する」事で、許可するパラメーターを追加する。

# deviseの処理名は３つあり。
# :sign_in        | サインイン(ログイン)の処理を行うとき
# :sign_up        | サインアップ(新規登録)の処理を行うとき
# :account_update | アカウト情報更新の処理を行うとき
# 第一引数はこのどれかを指定して許可を出す。

# application_controller.rbファイル
# 「全てのコントローラが継承しているファイル」です。
# すなわち、ここに処理を記述しておくことで、全てのコントローラーで共通となる処理を作る事ができる。
# deviseの処理に関わるコントローラーはgemに書かれて編集できないのでここに書く。

# before_actionのifという記述は値にメソッド名（今回は:devise_controller?）を指定する事で
# その戻り値がtrueであった場合にのみ処理を実行するよう設定するもの。
# 今回は:devise_controller?という「devise」のヘルパーメソッド名を指定して、
# もしdeviseに関するコントローラーの処理であれば、その時だけconfigure・・・メソッドを実行するように設定している。