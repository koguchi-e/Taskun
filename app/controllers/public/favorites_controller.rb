class Public::FavoritesController < ApplicationController
  def create
    @task = Task.find(params[:task_id])
    favorite = current_user.favorites.new(task_id: @task.id)
    favorite.save

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @task = Task.find(params[:task_id])
    favorite = current_user.favorites.find_by(task_id: @task.id)
    favorite.destroy

    respond_to do |format|
      format.js
    end
  end
end
