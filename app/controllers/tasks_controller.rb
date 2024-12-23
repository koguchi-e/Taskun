class TasksController < ApplicationController

  before_action :authenticate_user!

  # タスクの新規投稿に関するコントローラ
  def new
    @task = Task.new
  end

  # 新規投稿の保存機能
  def create
    Rails.logger.debug params.inspect
    task = current_user.tasks.new(task_params) 
    if task.save
      redirect_to task_path(task)
    else
      Rails.logger.debug task.errors.full_messages
      render :new
    end
  end

  # タスク一覧画面
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    task = Task.find(params[:id])
    task.update(task_params)
    redirect_to task_path(task.id)
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
