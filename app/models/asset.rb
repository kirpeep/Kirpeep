###################################################
# Model::Asset                                    #
# Desc: Holds images that can be tied to messages #
#       and userlistings                          #
###################################################
class Asset < ActiveRecord::Base
  attr_accessible :photo
  
  belongs_to :user_listing
  has_one :profile, :through => :user_listing
  has_one :user, :through => :profile
  
  #paperclip
  has_attached_file :photo,
     :styles => {
       :thumb=> "70x70#",
       :small  => "100x100>",
       :large => '200x200#' }
end
