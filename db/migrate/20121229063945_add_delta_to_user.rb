class AddDeltaToUser < ActiveRecord::Migration
  def change
    add_column :users, :delta, :boolean
  end
end
