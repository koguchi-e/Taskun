class Admin::TasksController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  def index
    @tasks = Task.page(params[:page])
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to admin_tasks_path, notice: "投稿を削除しました。"
  end
end
