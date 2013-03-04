class AddChatStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :chat_status, :string
  end
end
