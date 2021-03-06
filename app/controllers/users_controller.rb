class UsersController < ApplicationController
  before_action :set_user, only:[:show, :edit, :update]
  before_action :logged_in_user, only:[:edit, :update, :following, :followers]
  before_action :authenticate!, only:[:edit, :update]
  
  def show
    @user = User.find(params[:id])
    # @microposts = @user.microposts.order(created_at: :desc)
    @microposts = @user.microposts.paginate(page: params[:page], :per_page => 10)
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_profile)
      redirect_to user_url(@user)
    else
      render 'edit'
    end
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    render 'show_follower'
  end
  
  def index
    @users = User.paginate(page: params[:page], :per_page => 10)
    
  end
  
  private
  
  def logged_in_user
    @user = User.find(params[:id])
    if current_user != @user
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :profile, :region, :password, :password_confirmation)
  end
  
  def user_profile
    params.require(:user).permit(:name, :email, :profile, :region, :password, :password_confirmation)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def authenticate!
    if@user !=current_user
      redirect_to root_url, flash: {danger: "Unauthorized Access"}
    end
  end
end
