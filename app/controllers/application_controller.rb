####################################################
# Controller::ApplicationController                #
# Desc:                                            #
# Comments:                                        #
####################################################

class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery

  def tos
       render :template => 'pages/tos'
  end

  def privacy
       render :template => 'pages/privacy'
  end

  def how
       render :template => 'pages/how'
  end

  private
  
  

  #def current_user
  #	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  #end
	
  helper_method :current_user

  $account_sid = 'AC0c0a7ba5f860c03bbe3e787840311779'
  $auth_token = '373cfa0549ab3a994ffb5bf0c9d6f2c9'
  $ourNumber = '617-431-2087'

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
      user.kirpoints -= amount
      user.kirpoints_committed += amount
      if user.save
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def transferKirpoints(fromUser, toUser, amount)
    if fromUser.kirpoints_committed < amount
      return false
    else
      fromUser.kirpoints_committed -= amount
      toUser.kirpoints += amount
      return true
    end
  end
end
