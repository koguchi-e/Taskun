class Public::TasksController < ApplicationController
  before_action :authenticate_user!

  def new
    @task = Task.new
    @new_task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      flash[:notice] = "タスクが作成されました。"
      redirect_to task_path(@task.id)
    else
      flash.now[:alert] = "タスクの作成に失敗しました。"
      @new_task = @task
      @tasks = Task.page(params[:page])
      render :index
    end
  end

  def index
    sort_order = params[:sort] || 'created_at DESC'
    @tasks = Task.joins(:user).where(users: { is_active: true }).order(sort_order).page(params[:page])
  end

  def show
    @task = Task.find(params[:id])
    @task_comment = TaskComment.new
  end

  def edit
    @task = Task.find(params[:id])
    if @task.user != current_user
      redirect_to tasks_path, alert: "このタスクを編集する権限がありません。"
    end
  end

  def search
    @query = params[:query]

    if @query.blank?
      flash[:alert] = "検索条件を入力してください。"
      @results = Task.includes(:user).page(params[:page])  # 検索なしの場合は全件
    else
      keywords = @query.split(",").map(&:strip)  # カンマ区切りで配列化 & 空白除去

      query_conditions = keywords.map.with_index do |word, index|
        "(tasks.title LIKE :word#{index} OR COALESCE(tasks.keyword1, '') LIKE :word#{index} OR COALESCE(tasks.keyword2, '') LIKE :word#{index} OR COALESCE(tasks.keyword3, '') LIKE :word#{index} OR users.name LIKE :word#{index})"
      end.join(" AND ")  # 「OR」から「AND」に変更

      query_params = keywords.map.with_index { |word, index| ["word#{index}".to_sym, "%#{ActiveRecord::Base.sanitize_sql_like(word)}%"] }.to_h

      Rails.logger.debug "検索クエリ: #{@query}"
      Rails.logger.debug "検索条件: #{query_conditions}"
      Rails.logger.debug "検索パラメータ: #{query_params}"

      @results = Task.joins(:user).where(query_conditions, query_params).includes(:user).page(params[:page])

      Rails.logger.debug "検索結果: #{@results.inspect}"
    end

    render :search
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to task_path(@task.id)
    else
      render :edit
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to user_path(current_user)
  end

  private
    def task_params
      params.require(:task).permit(:title, :keyword1, :keyword2, :keyword3)
    end

    # 投稿者本人以外変更不可
    def is_matching_login_user
      task = Task.find(params[:id])
      unless task.user == current_user
        redirect_to task_path
      end
    end
end
