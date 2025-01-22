class Admin::DashboardsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @users = User.page(params[:page])
  end

  def search
    # パラメータから検索ワードを取得
    query = params[:query]
    # 検索ロジックを実装（例: モデルのwhereメソッドを使用）
    @results = User.where("name LIKE ?", "%#{query}%")
    @results = Task.where("title LIKE ?", "%#{query}%")
    # 検索結果をビューに渡す
    render :search
  end
end
