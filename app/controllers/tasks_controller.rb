class TasksController < ApplicationController
  # タスクの新規投稿に関するコントローラ
  def new
    @task = Task.new
  end

  def create
    # 12/21ここわからない・調べる
    task = Task.new(task_params)
    task.save
    redirect_to "/top"
  end

  def index
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
