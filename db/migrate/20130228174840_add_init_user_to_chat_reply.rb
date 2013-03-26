class AddInitUserToChatReply < ActiveRecord::Migration
  def change
    add_column :chat_replies, :init_user, :integer
  end
end
