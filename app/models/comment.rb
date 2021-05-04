class Comment < ApplicationRecord

  belongs_to :tweet
  belongs_to :user
end

# コメントは、ツイートが「必ず」所有する情報じゃないので、「ツイートと別のテーブルで管理しなくては行けない」
# そのためにcommentテーブルが必要。

# さらに、コメントはどのツイートに対してのコメントなのか、誰の投稿したコメントなのかが
# 書かれている必要があるため、userモデルとtweetモデルの２つにアソシエーションを組む必要がある。