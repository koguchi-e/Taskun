class Public::TasksController < ApplicationController

  before_action :authenticate_user!,:is_matching_login_user, only: [:edit, :update, :destroy]

  # タスクの新規投稿に関するコントローラ
  def new
    @task = Task.new
    @new_task = Task.new
  end

  # 新規投稿の保存機能
  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    
    if @task.save
      flash[:notice] = 'タスクが作成されました。'
      redirect_to task_path(@task.id)
    else
      flash.now[:alert] = 'タスクの作成に失敗しました。'
      @new_task = @task  
      @tasks = Task.page(params[:page])  # ページネーション用
      render :index
    end
  end

  # タスク一覧画面
  def index
    @tasks = Task.page(params[:page])
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
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
    redirect_to tasks_path
  end

  private

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

