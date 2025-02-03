class Public::GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def create
  @group = current_user.owned_groups.build(group_params)
  if @group.save
    redirec_to groups_path, notice: "グループを作成しました"
  else
    render :new
  end
  end

  def index
  end

  def edit
  end

  def update
  end

  def show
  end
end
