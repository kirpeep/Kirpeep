class AddMessageToChatReply < ActiveRecord::Migration
  def change
    add_column :chat_replies, :message, :string
  end
end
