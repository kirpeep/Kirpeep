class AddChatIdToChatReply < ActiveRecord::Migration
  def change
    add_column :chat_replies, :chat_id, :integer
  end
end
