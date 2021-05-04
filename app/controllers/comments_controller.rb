class CommentsController < ApplicationController

  def create
    comment = Comment.create(comment_params)
    redirect_to "/tweets/#{comment.tweet.id}"
  end

  private
  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, tweet_id: params[:tweet_id])
  end
end


# Commentモデルのcreateメソッドの引数では、ストロングパラメーター(comment_params)を用いて保存できるカラムを指定している。
# 渡されたparamsの中にcommentというハッシュが「二重構造」になっているため、
# requireメソッドの引数に指定して、textを取り出した。
# user_idカラムに、ログインしているユーザーのidをdeviseのcurrent_user.idで取得し、保存
# tweet_idカラムは、paramsで渡されるようにするので、
# params[:tweet_id]として保存している。

# ビューを返す時の注意点として、ルーティング時に
# 戻る時親のビューを返す必要がある。