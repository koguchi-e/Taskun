class ApplicationController < ActionController::Base

  # deviseのコントローラは直接修正できないため、
  # 全てのコントローラに対する処理を行える権限を持つ、ApplicationControllerに記述する必要があり。

  # devise利用の機能（ユーザ登録、ログイン認証など）が使われる前に
  # configure_permitted_parametersメソッドが実行
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # 名前の情報も保存できるようにする
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
