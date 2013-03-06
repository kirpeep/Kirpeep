class CreateChatReplies < ActiveRecord::Migration
  def change
    create_table :chat_replies do |t|

      t.timestamps
    end
  end
end
