class Public::FavoritesController < ApplicationController
  def create
    @task = Task.find(params[:task_id])
    unless @task.favorited_by?(current_user)
      @task.favorites.create(user: current_user)
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @task = Task.find(params[:task_id])
    favorite = current_user.favorites.find_by(task_id: @task.id)
    favorite.destroy if favorite

    respond_to do |format|
      format.js
    end
  end
end
