####################################################
# Controller::ApplicationController                #
# Desc: Globally accessable values and functions   #
# Comments:                                        #
####################################################

class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery

  #Array of catagories for user listings
  $categories = [
	"Electronics",
	"Hand Made Items",
 	"Clothing",
	"Art",
	"Home Decor",
	"Misc",
	"Movies and TV",
	"Collectables",
	"Baby",
	"Tools",
	"Instruments",
	"Appliances",
	"Beauty",
	"Creative",
	"Computer",
	"Events",
	"Financial",
	"Legal",
	"Lessons",
	"Marine",
	"Pets",
	"Automotive",
	"Farm+Garden",
	"Household",
	"Labor/Moving",
	"Real Estate",
	"Small Business",
	"Theraputic",
	"Travel/Vacation"
  ]

  #Renders the terms of service page
  def tos
       render :template => 'pages/tos'
  end
  
  #Renders the privacy page
  def privacy
       render :template => 'pages/privacy'
  end

  #Renders the 'How Kirpeep Works" page'
  def how
       render :template => 'pages/how'
  end

  private
  
  

  #def current_user
  #	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  #end
	
  helper_method :current_user 

  #Function sends text message to a user
  #ARGS
  # to => user that the message will be sent to
  # body => text that will be in the body of the message
  def sendTxt(to, body)
    $client = Twilio::REST::Client.new $account_sid, $auth_token
    $client.account.sms.messages.create(
       :from => $ourNumber,
       :to => to,
       :body => body
    )
  end

  #Function checks if a user has a specific amount of kirpoints in their account
  #Returns a boolean, if user has the passed amount of kirpoints, true is returned, else false
  #ARGS
  # user => user account that is beinging checked
  # amount => the amount of Kirpoints that are being verified
  def hasEnoughKirpoints(user, amount)
    if user.kirpoints >= amount
      return true
    else
      return false
    end
  end

  #Function commits Kirpoints that user has promised in an exchange by taking them out of the availble funds
  #Returns true if points are availible and are successfully commited, else false
  #ARGS
  # user => user account that has Kirpoints that need to be commited
  # amount => the amount of Kirpoints that are being commited
  def commitKirpoints(user, amount)
    if hasEnoughKirpoints(user, amount)
      kirpoints = user.kirpoints - amount

      if user.kirpoints_committed.nil?
        user.kirpoints_committed = 0
      end

      kirpoints_committed = user.kirpoints_committed + amount
      
      user.update_attribute(:kirpoints_committed, kirpoints_committed)
      user.update_attribute(:kirpoints, kirpoints)
        return true
    else
      return false
    end
  end

  #Function that gifts points from one user to another
  #Returns true if the points are sucessfully gifted, else false
  #ARGS
  # fromUser => user account that is beinging gifted from
  # toUser => user account that is beinging gifted to
  # amount => the amount of Kirpoints that are being gifted
  def giftKirpoints(fromUser, toUser, amount)
    if fromUser.kirpoints_committed < amount
      return false
    else
      kirpoints_committed = fromUser.kirpoints_committed - amount
      kirpoints = toUser.kirpoints + amount
      fromUser.update_attribute(:kirpoints_committed, kirpoints_committed)
      toUser.update_attribute(:kirpoints, kirpoints)
      return true
    end
  end

  #Function that transfers Kirpoints from one user to another
  #Returns true if the points are sucessfully transferred, else false
  #ARGS
  # fromUser => user account that is beinging tranferred from
  # toUser => user account that is beinging tranferred to
  # amount => the amount of Kirpoints that are being tranferred
  def transferKirpoints(fromUser, toUser, amount)
    if fromUser.kirpoints_committed < amount
      return false
    else
      kirpoints_committed = fromUser.kirpoints_committed - amount
      kirpoints = toUser.kirpoints + amount
      fromUser.update_attribute(:kirpoints_committed, kirpoints_committed)
      toUser.update_attribute(:kirpoints, kirpoints)

      Transaction.add_transaction fromUser.id, amount*-1
      Transaction.add_transaction toUser.id, amount
      return true
    end
  end
end
