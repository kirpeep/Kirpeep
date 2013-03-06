class AddTargUserToChatReply < ActiveRecord::Migration
  def change
    add_column :chat_replies, :targ_user, :integer
  end
end
