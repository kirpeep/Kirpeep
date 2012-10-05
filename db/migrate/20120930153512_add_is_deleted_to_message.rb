class AddIsDeletedToMessage < ActiveRecord::Migration
  def change
  	add_column :messages, :targ_is_deleted, :boolean, :default => false, :null => false
  	add_column :messages, :init_is_deleted, :boolean, :default => false, :null => false

  end
end
