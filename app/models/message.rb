####################################################
# Model: Message								   #
# Desc: Message that users send to communicate     #
# Comments: 9/30/12 - Added Photo, will add assets #
#                  For multiple File Uploads       # 
####################################################
class Message < ActiveRecord::Base
  attr_accessible :photo, :initUser, :targUser, :text, :subject, :responseToMsgID, :targUnread, :initUnread, :targ_is_deleted, :init_is_deleted, :updated_at 
  belongs_to :user
  has_one :profile, :through => :user
  belongs_to :searchQuery
  belongs_to :exchange
  #has_many :assets  <= enable to allow multiple images

  #paperclip
  has_attached_file :photo, :default_url => "missing.pict",
     :styles => {
       :thumb => "100x100#",
       :small  => "40x40" }

  validates :initUser, :presence => true
  validates :targUser, :presence => true
  validates :text, :presence =>true

  #updates the starting message associated
  def updateStartingMessage
    #update starting message
    parent_message = Message.find(id)
    while parent_message.responseToMsgID.to_i != 0
      parent_message = Message.find(parent_message.responseToMsgID)
    end
    #update timestamp
      parent_message.update_attribute("updated_at", DateTime.now.to_datetime)
      
      #mark as unread
      if Message.find(id).initUser == parent_message.initUser
        parent_message.update_attribute("targUnread", true)
      else
        parent_message.update_attribute("initUnread", true)
      end
  end

  #see if user has read message
  def isUnread? (user_id)
    if user_id.to_s == initUser
      initUnread
    else
      targUnread
    end
  end

  def markAsRead (user_id)
    if user_id == initUser
      initUnread = false
    else
      targUnread = false
    end
  end
end
