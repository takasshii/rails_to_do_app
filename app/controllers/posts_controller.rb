class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    @posts = Post.where(share_id: session[:share_id]).order(:post_deadline=>:asc, :post_importance=>:desc)
  end

  def show
    @post = Post.find_by(id: params[:id])
    reminding_seconds = @post.post_deadline - Time.now
    if(((reminding_seconds/(3600*12)).floor).abs >= 1)
      day = (reminding_seconds/(3600*12)).floor
      hour = ((reminding_seconds - (day*3600*12))/3600).floor
      minutes = ((reminding_seconds - (day*3600*12) - (hour*3600))/60).floor
      if day==1
        @remaining = "#{day}日#{hour}時間後"
        @correct_remaining = "#{day}日#{hour}時間#{minutes}分後"
      elsif day > 1
        @remaining = "#{day}日後"
        @correct_remaining = "#{day}日#{hour}時間#{minutes}分後"
      elsif day==-1
        @remaining = "#{day.abs}日#{hour.abs}時間前"
        @correct_remaining = "#{day.abs}日#{hour.abs}時間#{minutes.abs}分前"
      elsif day < -1
        @remaining = "#{day.abs}日前"
        @correct_remaining = "#{day.abs}日#{hour.abs}時間#{minutes.abs}分前"
      end
    elsif (((reminding_seconds/3600).floor).abs >= 1)
      hour = (reminding_seconds/3600).floor
      minutes = ((reminding_seconds - hour*3600)/60).floor
      if hour > 3
        @remaining = "#{hour}時間後"
        @correct_remaining = "#{hour}時間#{minutes}分後"
      elsif (hour>0 && hour<3) 
        @remaining = "#{hour}時間#{minutes}分後"
        @correct_remaining = "#{hour}時間#{minutes}分後"
      elsif (hour<0 && hour>-3) 
        @remaining = "#{hour.abs}時間#{minutes.abs}分前"
        @correct_remaining = "#{hour.abs}時間#{minutes.abs}分前"
      elsif hour < -3
        @remaining = "#{hour.abs}時間前"
        @correct_remaining = "#{hour.abs}時間#{minutes.abs}分前"
      end
    else
      minutes = ((reminding_seconds)/60).floor
      if minutes>=0
        @remaining = "#{minutes}分後"
        @correct_remaining = "#{minutes}分後"
      else
        @remaining = "#{minutes.abs}分前"
        @correct_remaining = "#{minutes.abs}分前"
      end
    end
    
    @user = @post.user
    @likes_count = Like.where(post_id: @post.id).count
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(content: params[:content],
                     user_id: @current_user.id, 
                     share_id: @current_user.share_id,
                     post_importance: params[:post_importance],
                     post_deadline: params[:post_deadline]
                    )
    @post.save
    if @post.save
      flash[:notice] = "投稿を作成しました"
      redirect_to("/posts/index")
    else
      render("posts/new")
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    if @post.save
      flash[:notice] = "投稿を編集しました"
      redirect_to("/posts/index")
    else
      render("posts/edit")
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/index")
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end


end
