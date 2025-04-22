class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit]

  def index
    # @users = User.where(is_active: true).includes(:tasks).page(params[:page])
    @users = User
      .includes(
        { image_attachment: :blob },
        :tasks,
        :followers,
        :followings
      )
      .where(is_active: true)
      .page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.order(created_at: :desc).page(params[:page])

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

    def ensure_guest_user
      @user = User.find(params[:id])
      if @user.guest_user?
        redirect_to user_path(current_user), notice: "ゲストユーザーはプロフィールを編集できません。"
      end
    end
end
