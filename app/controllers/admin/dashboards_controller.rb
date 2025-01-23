class Admin::DashboardsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @users = User.page(params[:page])
  end

  def search
    if params[:user_query].present?
      @user_results = User.where("name LIKE ?", "%#{params[:user_query]}%")
    end

    if params[:task_query].present?
      @task_results = Task.where("title LIKE ?", "%#{params[:task_query]}%")
    end

    render :search
  end
end

