class UsersController < ApplicationController

  def show
    user = User.find(params[:id])
    @nickname = user.nickname
    @tweets = user.tweets
  end

end

# class UsersController < ApplicationController
#   def show
#     @nickname = current_user.nickname
#     @tweets = current_user.tweets
#   end
# end

# この記述のままではどのツイートのユーザーマイページに行っても自分の情報しか
# 出て来なくなってしまうので、ツイートの右下に表示されるユーザー名をクリックすることで、
# 送られたidをparamsで取得し、そのユーザーのレコードを変数userに代入する。