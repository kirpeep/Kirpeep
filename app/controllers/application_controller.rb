####################################################
# Controller::ApplicationController                #
# Desc:                                            #
# Comments:                                        #
####################################################

class ApplicationController < ActionController::Base
  include SessionsHelper
  helper_method :current_user, :cookies 
  protect_from_forgery

  $categories = [
	"Electronics",
	"Furniture",
	"Gigs",
	"Internet/Development",
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
	"Medical",
	"Legal",
	"Dental",
	"Lessons",
	"Marine",
	"Pets",
	"Automotive",
	"Farm+Garden",
	"Household",
	"Labor/Moving",
	"Real Estate",
	"Small Business",
	"Therapeutic",
	"Travel/Vacation",
	"Non-Profit",
	"Free"
  ]

  
  def tos
       render :template => 'pages/tos'
  end

  def privacy
       render :template => 'pages/privacy'
  end

  def how
       render :template => 'pages/how'
  end

  def about
       render :template => 'pages/about'
  end

  def faq
       render :template => 'pages/faq'
  end

  private
  
  

  #def current_user
  #	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  #end
	
  

  def sendTxt(to, body)
    $client = Twilio::REST::Client.new $account_sid, $auth_token
    $client.account.sms.messages.create(
       :from => $ourNumber,
       :to => to,
       :body => body
    )
  end

  def hasEnoughKirpoints(user, amount)
    if user.kirpoints >= amount
      return true
    else
      return false
    end
  end

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
