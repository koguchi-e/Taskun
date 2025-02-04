class AddImageAndSummaryToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :image, :string
    add_column :groups, :summary, :text
  end
end
