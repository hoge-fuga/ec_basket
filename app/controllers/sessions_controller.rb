class SessionsController < ApplicationController
  def new
  end

  def create
    email = session_params[:email].downcase
    password = session_params[:password]
    if login(email, password)
      flash[:success] = 'ログインに成功しました。'
      redirect_to root_path
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'ログアウトしました。'
    redirect_to root_path
  end

  private


  def session_params
    params.require(:session).permit(:email, :password)
  end
end