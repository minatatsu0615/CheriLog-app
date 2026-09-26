class PostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to root_path, notice: "記録を保存しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(
      :image,
      :title,
      :category_id,
      :body,
      :favorite_rating,
      :emotion
    )
  end
end
