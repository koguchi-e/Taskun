class Public::TaskCommentsController < ApplicationController
  def create
    task = Task.find(params[:task_id])
    comment = current_user.task_comments.new(task_comment_params)
    comment.task_id = task.id
    comment.save
    redirect_to task_path(task)
  end

  def destroy
    TaskComment.find(params[:id]).destroy
    redirect_to task_path(params[:task_id])
  end

  private
    def task_comment_params
      params.require(:task_comment).permit(:comment)
    end
end
