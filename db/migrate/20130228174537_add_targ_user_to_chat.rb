class AddTargUserToChat < ActiveRecord::Migration
  def change
    add_column :chats, :targ_user, :integer
  end
end
