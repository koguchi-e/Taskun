class UsersController < ApplicationController
  # ユーザの一覧画面
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to user_path(user.id)
  end

  def destroy
  end

  private
  # ストロングパラメータ
  def user_params
    params.require(:user).permit(:name, :email, :image)
  end
end
