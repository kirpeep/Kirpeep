class AddInitUserToChat < ActiveRecord::Migration
  def change
    add_column :chats, :init_user, :integer
  end
end
