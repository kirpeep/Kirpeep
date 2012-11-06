
class SmsController < ApplicationController
 
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
    
   if params[:Body]
     if params[:Body].downcase == "verify"
        @profile = Profile.where("phone_number = ?", params[:From].gsub('+1','')).first!

	if @profile
	  @profile.update_attribute(:number_verified, true)
          render 'recieve.xml.erb', :content_type => 'text/xml'
        else
          #send error text
          render 'error.xml.erb', :content_type => 'text/xml'
	end
        
     elsif params[:Body].starts_with?('c-')
        #Get the User id of this phone number
        @profile = Profile.where("phone_number = ?", params[:From].gsub('+1','')).first!
        #Get the exchange for this id and this conf code
        
        @exch = Exchange.where("(initUser = #{@profile.user_id} and targConfCode = '#{params[:Body]}') or (targUser = #{@profile.user_id} and initConfCode = '#{params[:Body]}')").first!
        if @exch
           #determine if the what thise user is init or targ?
           if @exch.initUser == @profile.user_id
             # it is the init user
             #update the complete flag for the user on the exchange entity
             @exch.update_attribute(:initComp, true)
           else
             # it is the targ user
	     #update the complete flag for the user on the exchange entity
             @exch.update_attribute(:targComp, true)
           end
           
           if @exch.targComp and @exch.initComp
             @exch.type = 'RateExchange'
             
             @exch = exch.becomes(RateExchange)
             @exch.save
           end
           # Send the ok text
           render 'recieve.xml.erb', :content_type => 'text/xml'
        else
           # Need to send an error text back to the user.
           render 'error.xml.erb', :content_type => 'text/xml'
        end
     end
   end 
  end  

end
