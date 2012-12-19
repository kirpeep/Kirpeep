####################################################
# Controller::MessagesController                   #
# Desc:                                            #
# Comments:                                        #
####################################################

require 'date'

class MessagesController < ApplicationController

  #Function creates a message that is sent to a user
  def create 
   
    message = Message.new params[:message]
    message.targUnread = true
    user = current_user
    toUser = User.find(params[:message][:targUser])
    
    if message.save  
    	flash[:notice] = 'message saved.'
        #UserMailer.message_email(toUser, user, user.name + " has just sent you an message in Kirpeep.", params[:message][:text] ).deliver
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

  #Function shows new message modal
  def new
    @user = current_user
    @message = Message.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  #Function replies to a message 
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

  #Function shows a message
  def show

  end
  
  #Function marks a message as read after user has opened it
  def markAsRead
    message = Message.find(params[:id])

    case params[:user]
      when message.initUser
        message.initUnread = false
      when message.targUser
        message.targUnread = false
      else
        #well
    end

    message.save   
    render :json => message
  end

  #Function marks a message as unread 
  def markAsUnread
    message = Message.find(params[:id])

    case params[:user]
      when message.initUser
        message.initUnread = true
      when message.targUser
        message.targUnread = true
      else
        #well
    end

    message.save
    render :json => message  
  end

  #Function destroys a message
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

