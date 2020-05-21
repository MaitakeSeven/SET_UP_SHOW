class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to login_path
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end
  
  def likes
    @user = User.find(params[:id])
    @posts = @user.favorite_now
  end
private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
