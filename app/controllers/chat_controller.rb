class ChatController < ApplicationController

  def create
    @init_user = current_user
    @targ_user = User.find(params[:targ_id])

    chat = Chat.create({:init_user => @init_user.id,
		 :targ_user => @targ_user.id,
		 :message => @init_user.name+" requesting chat with "+@targ_user.name })
    @js = render_to_string("invite.js", :locals => { :username => current_user.name, :id => chat.id.to_s})

    PrivatePub.publish_to "/notify/"+@targ_user.id.to_s,  @js
    redirect_to :action => "show", :id => chat.id.to_s 
  end
  
  def show
    @chat = Chat.find(params[:id])
    if current_user.id != @chat.init_user && current_user.id != @chat.targ_user
        flash[:warning] = "there was an error procesing your request"
	redirect_to current_user
    end

    if @chat.init_user == current_user.id
      @user = User.find(@chat.targ_user)
    else
      @user = User.find(@chat.init_user)
    end
    @messages = @chat.chat_replys
  end

  def reply
    @chat = Chat.find(params[:chat_id])
    @reply = @chat.chat_replys.create params[:chat_reply]
    
    respond_to do |format|
      format.html {}
      format.js {render 'create'}
    end
  end
end

