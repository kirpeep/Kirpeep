class AddActiveToUser < ActiveRecord::Migration
  def change
    add_column :users, :Active, :boolean
  end
end
