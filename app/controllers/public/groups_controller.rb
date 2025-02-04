class Public::GroupsController < ApplicationController
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
    @group = Group.find(params[:id])
    redirect_to groups_path, alert: "権限がありません" unless @group.owner == current_user
  end

  def update
    @group = Group.find(params[:id])
    if @group.owner == current_user && @group.update(group_params)
      redirect_to group_path(@group), notice: "グループを更新しました"
    else
      redirect_to group_path(@group)
    end
  end

  def show
    @group = Group.find(params[:id])
  end

  def join
    @group = Group.find(params[:id])
    unless @group.members.include?(current_user)
      @group.members << current_user
      flash[:notice] = "グループに参加しました！"
    end
    redirect_to group_path(@group)
  end

  def leave
    @group = Group.find(params[:id])
    if @group.members.include?(current_user)
      @group.members.delete(current_user)
      flash[:notice] = "グループを退会しました！"
    end
    redirect_to group_path(@group)
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.owner == current_user && @group.destroy
      flash[:notice] = "グループを削除しました"
      redirect_to groups_path
    else
      redirect_to group_path(@group)
    end
  end

  private

  def group_params
    params.require(:group).permit(:name,:image,:summary)
  end
end
