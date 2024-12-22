class TasksController < ApplicationController
  # タスクの新規投稿に関するコントローラ
  def new
    @task = Task.new
  end

  # 新規投稿の保存機能
  def create
    Rails.logger.debug params.inspect
    # task_paramsはラストのストロングパラメータから来ている
    # 外部から送信されたデータを安全に取り出す役割
    task = Task.new(task_params)
    if task.save
      redirect_to task_path(task)
    else
      render :new
    end
  end

  # タスク一覧画面
  def index
    @tasks = Task.all
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  # ストロングパラメータ
  def task_params
    params.require(:task).permit(:title, :keyword1, :keyword2, :keyword3)
  end
end
