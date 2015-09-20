class PostsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    if params[:category_id].present?
      @category = Category.find(params[:category_id])
      @q      = Post.ransack(params[:q])
      @posts  = @q.result(distinct: true).where(category_id: params[:category_id])
      @posts  = @posts.page(params[:page]).per(params[:per])
    else
      @q      = Post.ransack(params[:q])
      @posts  = @q.result(distinct: true).page(params[:page]).per(params[:per])
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.all
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to posts_path
    else
      render :new
    end
  end

  def destroy
    @post = Post.find params[:id]
    if @post.destroy
      redirect_to posts_path, notice: "Se ha eliminado correctamente"
    else
      redirect_to post_path(@post), error: "No se ha podido eliminar"
    end
  end

  def post_params
    params.require(:post).permit(:title, :body, :category_id)
  end
end
