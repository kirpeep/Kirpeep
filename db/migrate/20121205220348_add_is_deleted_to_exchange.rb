class AddIsDeletedToExchange < ActiveRecord::Migration
  def change
  	add_column :exchanges, :is_deleted, :boolean, :default => false, :null => false
  end
end
