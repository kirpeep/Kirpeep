class Chat < ActiveRecord::Base
  attr_accessible :init_user, :targ_user, :message
  
  has_many :chat_replys

  
end
