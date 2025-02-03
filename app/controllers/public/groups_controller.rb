class Public::GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def create
    @group = current_user.owned_groups.build(group_params)
    if @group.save
      redirect_to groups_path, notice: "グループを作成しました"
    else
      render :new
    end
  end

  def index
    @groups = Group.all
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
      render :edit
    end
  end

  def show
  end

  private

  def group_params
    params.require(:group).permit(:name,:image,:summary)
  end
end
