class StaticPagesController < ApplicationController
  def home
    if logged_in?
     @micropost = current_user.microposts.build
     @feed_items = current_user.feed_items.includes(:user).order(created_at: :desc).paginate(page: params[:page], :per_page => 10)
     @user = User.find(current_user)
     @microposts = @user.microposts.order(created_at: :desc).paginate(page: params[:page], :per_page => 10)
    end
  end
end
