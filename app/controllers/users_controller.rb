class UsersController < ApplicationController
  before_action :authenticate_user, {only:[:index,:show,:edit,:update]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit,:update]}

  def index; 
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password],
      share_id: params[:share_id],
      image_name: "default_user_#{params[:gender]}.png",
      gender: params[:gender]
    )
    if @user.save
      session[:user_id] = @user.id
      session[:share_id] = @user.share_id
      flash[:notice] = 'ユーザー登録が完了しました'
      redirect_to("/users/#{@user.id}")
    else
      render('users/new')
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    @user.comment = params[:comment]
    @user.gender = params[:gender]

    # 画像を保存する処理
    if params[:image]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    elsif ((@user.image_name == 'default_user_female.png') || (@user.image_name == 'default_user_male.png')) & (!params[:image])
      @user.image_name = "default_user_#{params[:gender]}.png"
    end

    if @user.save
      flash[:notice] = 'ユーザー情報を編集しました'
      redirect_to("/users/#{@user.id}")
    else
      render('users/edit')
    end
  end

  def login_form
  
  end

  def login
    @user = User.find_by(email: params[:email],share_id: params[:share_id])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      session[:share_id] = @user.share_id
      flash[:notice]="ログインしました"
      redirect_to("/posts/index")
    else
      @error_message="メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      @share_id = params[:share_id]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    session[:share_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id)
  end

  def member 
    @users = User.where(share_id: params[:share_id])
  end
end
