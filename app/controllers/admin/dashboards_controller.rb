class Admin::DashboardsController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  def index
    @users = User.includes(image_attachment: :blob).page(params[:page])
  end

  def search
    @user_query = params[:user_query]
    @task_query = params[:task_query]
    @comment_query = params[:comment_query]

    if @user_query.blank? && @task_query.blank? && @comment_query.blank?
      flash[:alert] = "検索条件を入力してください。"
    else
      if @user_query.present?
        @user_results = User
          .includes(image_attachment: :blob)
          .where("name LIKE ?", "%#{@user_query}%")
      end

      if @task_query.present?
        @task_results = Task
          .includes(:user => { image_attachment: :blob }, comments: [])
          .where("title LIKE ?", "%#{@task_query}%")
      end

      if @comment_query.present?
        @comment_results = TaskComment
          .includes(:task, user: { image_attachment: :blob })
          .where("comment LIKE ?", "%#{@comment_query}%")
      end

      render :search
    end
  end
end
