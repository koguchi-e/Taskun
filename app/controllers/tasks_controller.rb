class TasksController < ApplicationController

  before_action :authenticate_user!

  # タスクの新規投稿に関するコントローラ
  def new
    @task = Task.new
  end

  # 新規投稿の保存機能
  def create
    @task = Task.new(task_params)
    # user_idの情報が必須なので、現在ログイン中のユーザーを関連付ける
    @task.user = current_user 
    if @task.save
      @tasks = Task.all
      render :index, notice: 'タスクが作成されました。'
    else
      render :new, notice: 'タスクの作成に失敗しました。'
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
