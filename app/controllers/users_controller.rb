class UsersController < ApplicationController
    before_action :require_user_logged_in, only: [:show, :destroy]
    
  def show
    @user = User.find(params[:id])
    @items = @user.items.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
  
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      login(@user.email,@user.password)
      redirect_to user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def destroy 
    user = User.find(params[:id])
    if user.destroy
      flash[:success] = 'ユーザを削除しました。'
      redirect_to root_path
    else
      flash.now[:danger] = 'ユーザの削除に失敗しました。'
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
end