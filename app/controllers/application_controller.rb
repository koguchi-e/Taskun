class ApplicationController < ActionController::Base
  before_action :configure_authentication
  before_action :set_new_task

  layout :set_layout

  private
    # 管理者用コントローラかどうかで、適切な認証メソッドを呼び出す
    def configure_authentication
      if admin_controller?
        authenticate_admin!
      else
        authenticate_user! unless action_is_public?
      end
    end

    # 現在のコントローラーがAdmin名前空間の下にあるかどうかを判定
    def admin_controller?
      self.class.module_parent_name == "Admin"
    end

    # homes#topアクションとhomes#aboutアクションが認証が不要かどうかを判定
    def action_is_public?
      controller_name == "homes" && (action_name == "top" || action_name == "about")
    end

    #  @new_task をすべてのページで利用可能にする
    def set_new_task
      @new_task = Task.new if user_signed_in?
    end

    def set_layout
      if controller_path.match?(/public\/homes|public\/sessions|public\/registrations|public\/passwords/)
        "public"
      else
        "application"
      end
    end
end
