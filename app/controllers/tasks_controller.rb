class TasksController < ApplicationController

  before_action :authenticate_user!

  # タスクの新規投稿に関するコントローラ
  def new
    @task = Task.new
  end

  # 新規投稿の保存機能
  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    
    if @task.save
      flash[:notice] = 'タスクが作成されました。'
      redirect_to tasks_path
    else
      flash.now[:alert] = 'タスクの作成に失敗しました。'
      render :new
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
    # 投稿者本人以外変更不可
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to task_path
    end
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
end
