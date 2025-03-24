# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  layout "admin"

  # before_action :configure_sign_in_params, only: [:create]

  def new
    self.resource = resource_class.new
    @admin = resource
    super
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

  protected
    # ログイン後の遷移先の設定
    def after_sign_in_path_for(resource)
      admin_dashboards_path
    end

    # ログアウト後の遷移先の設定
    def after_sign_out_path_for(resource_or_scope)
      new_admin_session_path
    end
end
