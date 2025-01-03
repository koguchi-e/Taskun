# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :configure_sign_in_params, only: [:create]

  # ログイン後のリダイレクト先を変更
  def after_sign_in_path_for(resource)
    tasks_path  
  end

  # ログアウト後のリダイレクト先
  def after_sign_out_path_for(resource)
    homes_path
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  # アクティブユーザかどうか判断するメソッド
  def user_state
    # 入力されたメアドから、アカウントを取得
    user = User.find_by(email: params[:custmer][:email])
    # アカウントが取得できなかった場合、このメソッドを終了
    return if user.nil?
    # 取得したPWと入力したPWが一致しなかった場合、このメソッドを終了
    return unless usr.valid_password?(params[:customer][:password])

    if is_active == true
      retrun 
    else
      redirect_to sign_up
    end
  end

  protected

  # 名前の情報も保存できるようにする
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
