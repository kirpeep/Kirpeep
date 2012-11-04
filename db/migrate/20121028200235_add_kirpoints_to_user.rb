class AddKirpointsToUser < ActiveRecord::Migration
  def change
    add_column :users, :kirpoints, :decimal
  end
end
