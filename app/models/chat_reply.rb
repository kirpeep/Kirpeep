class ChatReply < ActiveRecord::Base
  attr_accessible :init_user, :targ_user, :message, :chat_id

  belongs_to :chat
end
