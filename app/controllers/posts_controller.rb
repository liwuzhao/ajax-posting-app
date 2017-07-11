class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:create, :destroy]

  def index
    @posts = Post.order("id DESC").limit(20)

    if params[:max_id]
      @posts = @posts.where( "id < ?", params[:max_id])
    end

    respond_to do |format|
      format.html  # 如果客户端要求 HTML，则回传 index.html.erb
      format.js
    end

  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save

  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    render :json => { :id => @post.id }
  end

   def update
     @post = Post.find(params[:id])
     @post.update!( post_params )

     render :json => { :id => @post.id, :message => "ok"}
   end

  def like
    @post = Post.find(params[:id])
    unless @post.find_like(current_user)  # 如果已经按讚过了，就略过不再新增
      Like.create( :user => current_user, :post => @post)
    end

  end

  def unlike
    @post = Post.find(params[:id])
    like = @post.find_like(current_user)
    like.destroy

    render "like"
  end

  def favor
    @post = Post.find(params[:id])
    unless @post.find_favor(current_user)
      Favor.create( :user => current_user, :post => @post)
    end

  end

  def unfavor
    @post = Post.find(params[:id])
    favor = @post.find_favor(current_user)
    favor.destroy

    render "favor"
  end

  def toggle_flag
    @post = Post.find(params[:id])

    if @post.flag_at
      @post.flag_at = nil
    else
      @post.flag_at = Time.now
    end

    @post.save!

    render :json => { :message => "ok", :flag_at => @post.flag_at, :id => @post.id }
  end


  protected

  def post_params
    params.require(:post).permit(:content, :category_id)
  end

end
