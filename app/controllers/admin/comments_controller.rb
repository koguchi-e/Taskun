class Admin::CommentsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @comments = TaskComment.page(params[:page])
  end

  def destroy
    comment = TaskComment.find(params[:id])
    comment.destroy
    redirect_to admin_comments_path, notice: 'コメントを削除しました。'
  end
end
