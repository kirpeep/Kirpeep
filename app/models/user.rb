####################################################
# Model::User                                      #
# Desc: Users accounts                             #
# Comments:                                        #
####################################################

require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  
  attr_accessible :email, :name, :password, :password_confirmation, :token, :Active, :kirpoints_committed, :kirpoints
  has_one :profile, :dependent => :destroy
  has_many :messages
  has_many :needs, :through => :profile
  has_many :offers, :through => :profile
  has_many :exchanges
  has_many :ratings, :through => :exchange
  has_many :reviews, :through => :exchange
  has_many :messages, :through => :profile
  has_many :messages, :through => :searchQuery
  has_many :messages, :through => :exchange
  has_many :modifiedExchanges, :through => :exchange
  has_many :transactions
  has_and_belongs_to_many :searchQueries

  searchable do 
    text :email, :name #, :location
    #integer :zipcode
  end

  email_regex = /^.+@.+$/
  #old regex:    /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates(:name, :presence => true,
                   :length   => {:maximum => 50} )
  validates(:email, :presence   => true,                    
                    :uniqueness => true)
  validates(:password, :presence     => true,
                        :confirmation => true,
                        :length       => {:within => 6..40})
  validates(:password_confirmation, :presence => true)
  
  
  
  before_save { |user| user.email = email.downcase }
  before_save :encrypt_password
  before_save :create_remember_token

  def has_password?(submitted_password)
  	self.encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
  	user = find_by_email(email)
  	#return nil if user.nil?  || !user.has_password?(submitted_password)
  	if user && user.has_password?(submitted_password)
      return user
    else
       return nil
    end
  end

  def self.authenticate_with_salt(id, cookie_salt)
  	user = find_by_id(id)
  	(user && user.salt == cookie_salt) ? user : nil
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.mail = auth.info.email
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end	
  
  # Helper method that will generate a token for the user account
  # This will be used for things like reset/forgot passwords
  def self.generateToken()
	  SecureRandom.urlsafe_base64
  end

  def resetPassword new_password
    self.salt = make_salt 
    self.encrypted_password = encrypt(new_password)
    self.save(:validate => false)
  end

  def numOfExchanges
    @exchanges = Exchange.where('initUser = ? OR targUser = ?',  self.id, self.id)
    @exchanges.count
  end

  def numOfReviews
    #@reviews = Exchange.where(:initUser => self.id, :targUser => self.id)
    @reviews = 0
  end

  def numOfMessages
    messages = Message.where("initUser = ? OR targUser = ?", self.id,self.id).count
  end

  def numOfUnreadMessages
    
    messages = Message.where("initUser = ? OR targUser = ?", self.id,self.id)

    unreadCount = 0
    for message in messages
      
      user = self.id.to_s

      if user == message.initUser && message.initUnread
        unreadCount += 1
      elsif user == message.targUser && message.targUnread
        unreadCount += 1
      end
    end

    return unreadCount.to_i
  end

  #Profile accessor methods
  def aboutMe
    self.profile.about
  end

  def profilePic
    self.profile.photo.url
  end

  def self.set_chat_status(id, status)
    user = self.find(id)

    user.chat_status = status
    user.save(:validate => false)
  end
  private

  	def encrypt_password
      if new_record?
  		  self.salt = make_salt 
  		  self.encrypted_password = encrypt(password)
      end
  	end

  	def encrypt(string)
  		secure_hash("#{salt}--#{string}")
  	end

  	def make_salt
  		secure_hash("#{Time.now.utc}--#{password}")
  	end

  	def secure_hash(string)
  		Digest::SHA2.hexdigest(string)
  	end

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def set_product_delta_flag
      Need.define_indexes
      Need.update_all ['delta = ?', true], ['profile_id = ?', (User.find(id)).profile.id]
      Need.index_delta
      Offer.define_indexes
      Offer.update_all ['delta = ?', true], ['profile_id = ?', (User.find(id)).profile.id]
      Offer.index_delta
    end
end
