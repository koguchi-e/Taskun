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
  end

  def update
  end

  def show
  end

  private

  def group_params
    params.require(:group).permit(:name,:image,:summary)
  end
end
