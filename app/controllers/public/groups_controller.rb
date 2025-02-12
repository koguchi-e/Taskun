class Public::GroupsController < ApplicationController
  before_action :set_group, only: [:edit,:update,:show,:join,:leave,:destroy]

  def new
    @group = Group.new
  end

  def create
    @group = current_user.owned_groups.build(group_params)
    if @group.save
      redirect_to group_path(@group), notice: "グループを作成しました"
    else
      render :new
    end
  end

  def index
    @groups = Group.page(params[:page])
  end

  def edit
    redirect_to groups_path, alert: "権限がありません" unless @group.owner == current_user
  end

  def update
    if @group.owner == current_user
      if @group.update(group_params)
        flash[:notice] = "グループを更新しました"
        redirect_to group_path(@group)
      else
        flash[:alert] = "更新に失敗しました"
        render :edit
      end
    else
      flash[:alert] = "権限がありません"
      redirect_to group_path(@group)
    end
  end

  def show
  end

  def join
    unless @group.members.include?(current_user)
      @group.members << current_user
      flash[:notice] = "グループに参加しました！"
    end
    redirect_to group_path(@group)
  end

  def leave
    if @group.members.include?(current_user)
      @group.members.delete(current_user)
      flash[:notice] = "グループを退会しました！"
    end
    redirect_to group_path(@group)
  end

  def destroy
    if @group.owner == current_user
      if @group.destroy
        flash[:notice] = "グループを削除しました"
        redirect_to groups_path
      else
        flash[:alert] = "削除に失敗しました"
        render :edit
      end
    else
      flash[:alert] = "権限がありません"
      redirect_to group_path(@group)
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name,:image,:summary)
  end
end
