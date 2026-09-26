class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = Category.all

    @posts = current_user.posts
    @posts = @posts.where(category_id: params[:category_id]) if params[:category_id].present?
    @posts = @posts.order(created_at: :desc)
  end

  def show
    @post = current_user.posts.find(params[:id])
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to @post, notice: "記録を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!

    redirect_to posts_path, notice: "投稿を削除しました"
  end

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
