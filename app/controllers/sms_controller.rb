
class SmsController < ApplicationController
  $account_sid = 'AC0c0a7ba5f860c03bbe3e787840311779'
  $auth_token = '373cfa0549ab3a994ffb5bf0c9d6f2c9'
  $ourNumber = '617-431-2087'

  def verify
    if params[:to] and params[:body]
       sendTxt(params[:to], params[:body])
       flash[:notice] = 'Message Sent'
       redirect_to root_path
    else
       flash[:error] = 'Could not send SMS'
       redirect_to root_path
    end
  end

  def recieve
       
   @profile = Profile.where(:phone_number => params[:From]).first!

   if @profile
     @profile.update_attribute(:number_verified, true)
   end
   
   render 'recieve.xml.erb', :content_type => 'text/xml'
   
  end

private
  def sendTxt(to, body)
    $client = Twilio::REST::Client.new $account_sid, $auth_token
    $client.account.sms.messages.create(
       :from => $ourNumber,
       :to => to,
       :body => body
    )
  end

end
