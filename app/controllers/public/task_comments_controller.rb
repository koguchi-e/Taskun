class Public::TaskCommentsController < ApplicationController
  def create
    @task = Task.find(params[:task_id])
    @comment = current_user.task_comments.new(task_comment_params)
    @comment.task_id = @task.id
    
    respond_to do |format|
      if @comment.save
        @task_comment = TaskComment.new
        format.js
        format.html { redirect_to task_path(@task), notice: "コメントを追加しました。" } 
      else
        @task_comment = @comment
        format.html { redirect_to task_path(@task), alert: "コメントを入力してください。" }
      end
    end
  end

  def destroy
    @task = Task.find(params[:task_id])
    @comment = TaskComment.find(params[:id])
    @comment.destroy
    @task_comment = TaskComment.new

    respond_to do |format|
      format.js
    end
  end

  private
    def task_comment_params
      params.require(:task_comment).permit(:comment)
    end
end
