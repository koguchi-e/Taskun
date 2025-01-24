class Admin::DashboardsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @users = User.page(params[:page])
  end

  def search

    @user_query = params[:user_query]
    @task_query = params[:task_query]

    if @user_query.blank? && @task_query.blank?
      flash[:alert] = "検索条件を入力してください。"
    end

    @user_results = User.where("name LIKE ?", "%#{@user_query}%") if @user_query.present?

    @task_results = Task.where("title LIKE ?", "%#{@task_query}%") if @task_query.present?

    render :search
  end
end

