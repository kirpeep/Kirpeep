####################################################
# Controller::ApplicationController                #
# Desc:                                            #
# Comments:                                        #
####################################################

class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery

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
end
