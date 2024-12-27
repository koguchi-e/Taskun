class UsersController < ApplicationController
  # ユーザの一覧画面
  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.page(params[:page])
  end

  def edit
    @user = User.find(params[:id])
    # 本人以外変更不可
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def destroy
  end

  private
  # ストロングパラメータ
  def user_params
    params.require(:user).permit(:name, :email, :image)
  end
end
