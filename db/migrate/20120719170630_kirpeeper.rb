class Kirpeeper < ActiveRecord::Migration
  def up
  	#table for basic account information
  	# :name => Users Name
    # :email => User's Email Address
    # :encrypted_password =>User's Password (encrypted)
    # :remember_token => User's token to stay logged in
    # :salt => for security
    # :profileID => Profile ID associated with the user
  	create_table :users do |t|   
      t.string :name
      t.string :email, :unique => true
      t.string :encrypted_password
      t.string :remember_token
      t.string :salt
      t.timestamps
    end

    create_table :user_listings do |t|
        t.belongs_to :profile
        t.belongs_to :user, :through => :profile
        t.string :type
        t.text   :description
        t.string :title
        t.integer :quantity
        t.string :quantityUnit
        t.datetime :availableUntil #time offer is available until
        t.integer :inventoryCount #for o
        t.string :imgURL #for uploaded pics. does this allow for more than one pic/video
        t.datetime :neededBy #time need is needed by
        t.string :listingType #public == all Kirpeep, private == only user, custom == designated groups and inviduals
        t.string :photo_file_name
        t.string :photo_content_type
        t.integer :photo_file_size
        t.timestamps
    end

    #Table for information pertaining to the users profile
    #	:profileID => Profile ID related to the user 
    #	:interests   => List of interests the user has
    #	:about     => About Me information
    #	:education => Education level of the user
    #	:location  => Zipcode of the user 
    #	:languages => Lanuages the usr speaks
    create_table :profiles do |t|
    	t.string :interests
        t.string :quickPitch
    	t.text   :about
    	t.string :education
    	t.string :location
    	t.string :languages
        t.string :photo_file_name
        t.string :photo_content_type
        t.integer :photo_file_size
        t.belongs_to :user
        t.timestamps
    end

    #Table that holds the exchanges
    # :exchangeID     => ID of the exchange
    # :exchangeType   => Type of exchange (public, private, unlisted)
    # :status         => current status of the exchange
    # :initProfileID  => ProfileID of the initiator
    # :targetProfileID=> ProfileID for Target of exchange 
    # :needID         => ID of the need  
    # :offerID        => ID of the offer 
    create_table :exchanges do |t|
        #t.string :exchangeType 
    	#t.string :status
    	#t.string :initProfileID 
    	#t.string :targetProfileID
        #t.integer :quantity
        #t.string :quantityUnit
    	#t.string :needID 
    	#t.string :offerID
        #t.timestamps
        
        t.string :type
        t.string :typeWhenTerm
        t.string :initUser
        t.string :targUser
        t.string :init_list_id
        t.string :targ_list_id
        t.boolean :initAcpt
        t.boolean :targAcpt
        t.boolean :initComp
        t.boolean :targComp
        t.boolean :initCode
        t.boolean :targCode
        t.integer :init_rating_time
        t.integer :init_rating_cost
        t.integer :init_rating_ease
        t.integer :init_rating_overall
        t.integer :targ_rating_time
        t.integer :targ_rating_cost
        t.integer :targ_rating_ease
        t.integer :targ_rating_overall
        t.text    :init_comments
        t.text    :targ_comments
        t.string  :type_when_term
    end
  
    
    #Table with modifications to the exchange
    # :modificationID   => ID of the modification
    # :exchangeID       => ID of the exchange
    # :timeModified     => Time of modifications
    # :itemIDModified   => ID of item in modification
    # :modfication      => ADD/DELETE of item
    # :prevModification => ID of previous Modification 
    create_table :modified_exchanges do |t|
        t.integer  :modificationID
        t.integer  :exchangeID
        t.datetime :timeModified
        t.string   :itemIDModified
        t.string   :modification
        t.integer  :prevModification
        t.timestamps
    end

    #Table with all the timeStamps of the exchange
    # :exchangeID ID of associated exchange
    # :timeInitiated  => Time exchange was initiated
    # :timeTerminated => Time exchange was terminated 
    # :timeAccepted   => Time exchange was accepted
    # :timeCompleted  => Time exchange was complete
    # :timeReviewed   => Time exchange was reviewed  
    create_table :time_stamps do |t|
        t.integer  :exchangeID
        t.datetime :timeInitiated
        t.datetime :timeTerminated
        t.datetime :timeAccepted
        t.datetime :timeModified
        t.datetime :timeCompleted
        t.datetime :timeReviewed 
        t.datetime :timeRated 
        t.timestamps
    end

    #Table holding reviews
    # :reviewID         => ID of the review
    # :exchangeID       => ID of the exchange being reviewed
    # :profileID        => ID of the reviewer
    # :review           => Review of the exchange
    create_table  :reviews do |t|
    	t.string :reviewID
    	t.string :exchangeID
        t.string :profileID
    	t.text   :review
        t.timestamps    	
    end

    #Table for users messages 
    # :messageID       =>MessageID
    # :fromUserID      => ID of the user sending message
    # :toUserID        => ID of the user receiving the message
    # :message         => The message itself
    # :responseToMsgID => The ID of the message that was responded to
    create_table :messages do |t|
    	t.string :initUser
    	t.string :targUser
    	t.text   :text
	    t.boolean :targUnread
    	t.boolean :initUnread
	    t.string :responseToMsgID
        t.belongs_to :exchange
        t.belongs_to :message
        t.timestamps
    end
  end

  def down
    drop_table :messages 
    drop_table :reviews 
    drop_table :time_stamps
    drop_table :modified_exchanges 
    drop_table :exchanges
    drop_table :profiles
    drop_table :user_listings
    drop_table :users
  end
end
