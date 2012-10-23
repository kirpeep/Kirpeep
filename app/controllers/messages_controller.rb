####################################################
# Controller::MessagesController                   #
# Desc:                                            #
# Comments:                                        #
####################################################

require 'date'

class MessagesController < ApplicationController

  def create

    message = Message.new params[:message]
    message.targUnread = true
    user = current_user 
    
    if message.save  
    	flash[:notice] = 'message saved.'
      
      message.updateStartingMessage

    	respond_to do |format|
        format.html {redirect_to user}
        format.js 
      end
    else
    	flash[:error] = message.errors.full_messages.to_sentence
    	#redirect_to user
    end
  end

  def new
    @user = current_user
    @message = Message.new

  end

  def reply
    user = current_user
    #message =Message.find(params[:message_id])
    #reply = message.message 
    reply = Message.new params[:message]

    if( is_current_user(message.initUser))
      message.targUnread = true
    else
      message.initUnread = true
    end

    if message.save  
      flash[:notice] = 'message saved.'
      
      respond_to do |format|
        format.html {redirect_to user}
        format.js 
      end
    else
      flash[:error] = message.errors.full_messages.to_sentence
      respond_to do |format|
        format.html {redirect_to user}
        format.js 
      end
    end
  end

  def show

  end
  

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    message = Message.find(params[:id])
    #change value of 'is_deleted' to true so that it no longer displays
    message.is_deleted = true

    if message.save
      flash[:notice] = 'Message Deleted'  
      redirect_to current_user
    else

      flash[:error] = message.errors

        if message.errors.any?
            message.errors.full_messages.each do |msg|
                puts msg
            end
        end
      respond_to do |format|
        fotmat.html { redirect_to current_user}
      end
    end
  end 

end

