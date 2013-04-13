####################################################
# Model::Profile                                   #
# Desc: Profile associated with user accounts      #
# Comments:                                        #
####################################################

class Profile < ActiveRecord::Base
  attr_accessible :photo, :interests, :quickPitch, :about, :education, :group, :sector, 
              :location, :languages, :gender, :birthdate, :zipcode, :phone_number, :number_verified
  after_commit :set_product_delta_flag

  belongs_to :user
  has_many :offers
  has_many :needs
  has_many :exchanges
  has_many :messages
  #paperclip
  has_attached_file :photo,
     :styles => {
       :thumb=> "100x100#",
       :small  => "400x400>" }
       
  validates :interests,  :length => {:minimum => 0, :maximum =>500}
  validates :about,      :length => {:minimum => 0, :maximum => 1000}
  validates :quickPitch, :length => {:minimum => 0, :maximum => 160}
  validates :education,  :length => {:minimum => 0, :maximum => 500}
  validates :location,   :length => {:maximum => 160}#, :presence => true
  validates :languages,  :length => {:minimum => 0, :maximum => 500}
  validates :group, 	 :length => {:minimum => 0, :maximum => 500}
  validates :sector, 	 :length => {:minimum => 0, :maximum => 500}

  private

  def set_product_delta_flag
      Need.define_indexes
      Need.update_all ['delta = ?', true], ['profile_id = ?', id]
      Need.index_delta
      Offer.define_indexes
      Offer.update_all ['delta = ?', true], ['profile_id = ?', id]
      Offer.index_delta
  end
end
