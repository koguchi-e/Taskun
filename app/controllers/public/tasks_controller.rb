class Public::TasksController < ApplicationController
  before_action :authenticate_user!,:is_matching_login_user, only: [:edit, :update, :destroy]
  before_action :set_task, only: [:show, :edit, :update, :destroy, :complete]

  def new
    @task = Task.new
    @new_task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    
    if @task.save
      flash[:notice] = 'タスクが作成されました。'
      redirect_to task_path(@task.id)
    else
      flash.now[:alert] = 'タスクの作成に失敗しました。'
      @new_task = @task  
      @tasks = Task.page(params[:page])
      render :index
    end
  end

  def index
    @tasks = Task.page(params[:page])
  end

  def show
    @task_comment = TaskComment.new
  end

  def edit
  end

  def search
    query = params[:query]

    if query.blank?
      flash[:alert] = "検索条件を入力してください。"
      @results = Task.includes(:user).page(params[:page])  # 検索なしの場合は全件
    else
      keywords = query.split(',').map(&:strip)  # カンマ区切りで配列化 & 空白除去

      query_conditions = keywords.map.with_index do |word, index|
        "(tasks.title LIKE :word#{index} OR COALESCE(tasks.keyword1, '') LIKE :word#{index} OR COALESCE(tasks.keyword2, '') LIKE :word#{index} OR COALESCE(tasks.keyword3, '') LIKE :word#{index} OR users.name LIKE :word#{index})"
      end.join(" AND ")  # 「OR」から「AND」に変更

      query_params = keywords.map.with_index { |word, index| ["word#{index}".to_sym, "%#{ActiveRecord::Base.sanitize_sql_like(word)}%"] }.to_h

      Rails.logger.debug "検索クエリ: #{query}"
      Rails.logger.debug "検索条件: #{query_conditions}"
      Rails.logger.debug "検索パラメータ: #{query_params}"

      @results = Task.joins(:user).where(query_conditions, query_params).includes(:user).page(params[:page])

      Rails.logger.debug "検索結果: #{@results.inspect}"
    end

    render :search
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task.id), notice: 'タスクが更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'タスクが削除されました。'
  end

  def complete
    if @task.nil?
      render json: { success: false, error: "タスクが見つかりません" }, status: :not_found
      return
    end
  
    unless @task.user == current_user
      render json: { success: false, error: "権限がありません" }, status: :forbidden
      return
    end
  
    begin
      ActiveRecord::Base.transaction do
        new_status = !@task.completed
        completed_at = new_status ? Time.current : nil
  
        # `update_columns` を使用し、バリデーションをスキップ
        @task.update_columns(completed: new_status, completed_at: completed_at, updated_at: Time.current)
  
        render json: { success: true, completed: new_status, completed_at: completed_at&.iso8601 }
      end
    rescue ActiveRecord::StatementInvalid => e
      Rails.logger.error "❌ データベースエラー: #{e.message}"
      render json: { success: false, error: "データベースエラーが発生しました" }, status: :internal_server_error
    rescue => e
      Rails.logger.error "❌ 予期しないエラー: #{e.message}"
      render json: { success: false, error: "サーバーエラーが発生しました" }, status: :internal_server_error
    end
  end
  
  
  private
  
  def set_task
    @task = Task.find_by(id: params[:id])
    unless @task
      render json: { success: false, error: "タスクが見つかりません" }, status: :not_found
    end
  end  

  # ストロングパラメータ
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
