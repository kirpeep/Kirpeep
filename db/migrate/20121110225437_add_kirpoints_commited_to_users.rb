class AddKirpointsCommitedToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :kirpoints_committed, :decimal
  end
end
