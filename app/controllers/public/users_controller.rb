class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  # ユーザの一覧画面
  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.page(params[:page])

    @owned_groups = @user.owned_groups
    @joined_groups = @user.groups
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def withdraw
    @user = User.find(params[:id])
    if @user == current_user
      # 退会状態に更新
      @user.update(is_active: false)
      # セッションをリセットしてログアウト
      reset_session
      redirect_to new_user_registration_path, notice: "退会処理が完了しました。ご利用ありがとうございました。"
    else
      redirect_to user_path(@user), alert: "不正な操作です。"
    end
  end

  private

  # ストロングパラメータ
  def user_params
    params.require(:user).permit(:name, :email, :image, :is_active)
  end

  # 本人以外変更不可
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user.id)
    end
  end
end
