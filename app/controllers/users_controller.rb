####################################################
# Controller::UsersController                      #
# Desc:                                            #
# Comments:                                        #
####################################################

class UsersController < ApplicationController
  include ActiveMerchant::Billing
  helper_method :sort_column, :sort_direction
  # GET /users
  # GET /users.json


  before_filter :signed_in_user, :only => [:show, :edit, :update, :destroy], :except => [:forgot, :process_forgot, :reset_password, :process_reset_password, :new, :create, :activate, :view]
  #before_filter :correct_user, :only => [:show, :edit, :update, :destroy]
  
  def index
    #@users = User.all

    #respond_to do |format|
    #  format.html {root_path}
    #  format.json { render json: @users }
    #end
    redirect_to root_path
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @title = @user.name
    @messagesTabTxt = (@user.numOfUnreadMessages > 0)? "Messages ("+@user.numOfUnreadMessages.to_s+")" : "Messages"
        
    if @user && @user.id == current_user.id
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
      end
    else
      redirect_to :action => "view", :id => @user.id
    end
  end

  def view
    @user = User.find(params[:id])
    @title = @user.name

    if signed_in?
      Action.log current_user.id, 'viewOtherUsersProfile', @user.id
    else
      Action.log nil, 'viewOtherUsersProfile', @user.id
    end
    respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @profile = Profile.new 

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    if params[:password] != params[:password_confirmation]
      flash[:error] = "Passwords do not match"
      redirect_to root_url
      return
    end

    if params[:password].to_s().length < 6
     flash[:error] = "Password must be at least 6 characters in length."
     redirect_to root_url
     return
    end

    @user = User.new
    # A user must activate via an activation email
    # Before they are allowed to use the system - kyle
    @user.email = params[:email]
    @user.name = params[:name]
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    @user.Active = false 
    @user.token = User.generateToken
    @user.profile = Profile.new

    respond_to do |format|
      if @user.save
        UserMailer.activate_email(@user).deliver
       # sign_in @user
        flash[:notice] = 'Thank you for creating an account. Please check your email to activate it.'
        format.html { redirect_to root_url }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html {  redirect_to root_url, error: 'User was not successfully created.'  }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update

    @user = User.find(params[:id])
    @user.update_attributes(params[:user])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def profile
    @user = User.find(params[:id])

    render :partial => 'profile', :locals => {:user => @user}
  end

  def exchanges
    @user = User.find(params[:id])
    @exch = Exchange.where("is_deleted = false AND type != ? AND initUser = ? OR targUser = ? ", 'ArchivedExchange', @user.id, @user.id).all 
    @pastExch = Exchange.where("type = ? AND initUser = ? OR targUser = ? ", 'ArchivedExchange', @user.id, @user.id).all
    
    render :partial => 'exchange', :locals => {:user => @user, :exch => @exch, :pastExch => @pastExch}
  end

  def messages
    @user = current_user
    @messages = Message.order("updated_at DESC").where("responseToMsgID = ? AND (initUser = ? OR targUser = ?)", "start", current_user.id, current_user.id).all

    #@messages = Message.all#where("responseToMsgID = ?", "start").all
    render :partial => 'messages', :locals => {:user => @user, :messages => @messages}
  end

  def needs
    # This method is meant to be an ajax
    #call to get all the users needs in JSON format
    if params[:id].nil?
      flash[:error] = "Missing Requirements: ID"
    else
      @needs = User.find(params[:id]).needs
      respond_to do |format|
        format.json {render :json => @needs}
      end
    end
  end

  def get_need
    @needs = User.find(params[:id]).needs
    @need = @needs.find(params[:listing])
    respond_to do |format|
      format.json {render :json => @need}
    end
  end

  def offers
    if params[:id].nil?
      flash[:error] = "Missing Requirements: ID"
    else
      @offers = User.find(params[:id]).offers
      respond_to do |format|
        format.json {render :json => @offers}
      end
    end
  end

  def get_offer
    @offers = User.find(params[:id]).offers
    @offer = @offers.find(params[:listing])
    respond_to do |format|
      format.json {render :json => @offer}
    end
  end

  def chat_status
    User.set_chat_status(params[:id], params[:status])
  end

  def forgot
    respond_to do |format|
      format.html
    end 
  end

  def process_forgot
    # First thing we need to do is check the user account
    if params[:email].nil?
       flash[:error] = 'We are sorry something went wrong. Please try again.'
       redirect_to('/') 
    end
    @user = User.find_by_email(params[:email])
    if @user.nil?
       flash[:error] = 'We were unable to find this email in our system.'
       redirect_to('/')
    else
       @token = User.generateToken
       @user.update_attribute(:token, @token.to_s)
       @user.update_attribute(:Active, true)
       UserMailer.forgot_email(@user).deliver
       flash[:notice] = 'An email was sent to your email account.'
       redirect_to('/')
    end	
  end
  
  def reset_password
    if !(params[:id] && params[:token]) 
      redirect_to root_path, error: 'Missing Requirements'
      return
    else
      @user = User.where("id = ? AND token = ?", params[:id], params[:token]).first!
      if @user.nil?
        redirect_to root_path, error: 'Could not find the user'
        return
      else
        respond_to do |format|
          format.html
        end
      end
    end
  end

  def process_reset_password
    if !(params[:id] && params[:password] && params[:confirm])
      redirect_to '/resetpassword', error: 'Missing some information'
      return
    else
      if params[:password] != params[:confirm]
        redirect_to '/resetpassword', error: 'Passwords do not match'
        return
      else
        debugger
        @user = User.find(params[:id])
        if @user.resetPassword(params[:confirm])
          flash[:notice] = 'Your password has been reset'
        else
          flash[:error] = "There was an issue resetting your password"
        end
        redirect_to root_url
      end
    end 
  end

  def activate
    if params[:id].nil? || params[:token].nil?
	redirect_to root_path, notice: 'Missing Requirements'
    else
       @user = User.where("id = ? AND token = ?", params[:id], params[:token]).first!
       if @user.nil?
         redirect_to root_path, notice: 'Missing Requirements'
       else
         @user.update_attribute(:Active, true)
         sign_in_ @user
         redirect_to root_path(@user, :modalurl => '/userlistings/new?type=offer')
       end
    end
  end

   def add_kirpoints
      amount = params[:kirpoints].to_i() * 100
   
      #if amount >= 2500
	      setup_response = gateway.setup_purchase(amount,
		    :ip                => request.remote_ip,
		    :description => 'Yor are buying ' + params[:kirpoints] + ' Kirpoint(s)',
		    :return_url        => url_for(:action => 'confirm', :only_path => false),
		    :cancel_return_url => url_for(:action => 'index', :only_path => false)
		  )
		  redirect_to gateway.redirect_url_for(setup_response.token)
      #end
   end

   def kirpoints
        respond_to do |format|
            format.html { render "kirpoints.html" }
        end
   end

   def confirm
	 redirect_to :action => 'index' unless params[:token]
  
         details_response = gateway.details_for(params[:token])
  
         if !details_response.success?
           @message = details_response.message
           render :action => 'error'
           return
         end
        @token = params[:token]
        @payer_id = params[:PayerID]
        @total = details_response.params['order_total']
        @address = details_response.address
   end

  def complete
    amount = params[:total].to_i() * 100
    purchase = gateway.purchase(amount,
      :ip       => request.remote_ip,
      :payer_id => params[:payer_id],
      :token    => params[:token]
    )
  
    if !purchase.success?
      @message = purchase.message
      render :action => 'error'
      return
    end
    
    Transaction.add_transaction current_user.id, amount
    kirpoints = current_user.kirpoints.to_f() + params[:total].to_f()
    current_user.update_attribute(:kirpoints, kirpoints)
  end

  def cashout_kirpoints
    respond_to do |format|
        format.html { render "cashout_kirpoints.html" }
    end
  end

  def process_cashout_kirpoints
    #does our params exist?
    if (!params[:amount] || params[:amount] == '') && (!params[:ppemail] || params[:ppemail == ''])
      flash[:error] = 'Must enter an amount and your paypal email to cashout'
      redirect_to '/kirpoints/cashout'
      return
    #is it a number
    elsif params[:amount].to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == false
      flash[:error] = 'Must be a number'
      redirect_to '/kirpoints/cashout'
      return
    #is it a value over 50
    elsif params[:amount].to_f() < 50
      flash[:error] = 'The cashout value must be at least $25'
      redirect_to '/kirpoints/cashout'
      return
    #do you have enough money to cover this
    elsif current_user.kirpoints.to_f() < params[:amount].to_f()
      flash[:error] = 'Insufficient kirpoints'
      redirect_to '/kirpoints/cashout'
      return
    end
    
    #Calculate out the amount - our 5% cut
    @amount = (params[:amount].to_f() * 100) - (params[:amount].to_f() * 100 * 0.05)
    #Store the email
    @rec = params[:ppemail]
    #Make the transfer
    transfer = gateway.transfer(@amount,@rec, :subject => "Kirpoints Cashout", :note => "You are cashing out kirpoints into your paypal account.")
    
    if transfer.success?
     flash[:notice] = 'Your kirpoints have been cashed out.  Please check your paypal account.'
     current_user.kirpoints = current_user.kirpoints.to_f() - params[:amount].to_f()
     current_user.save
    else
     flash[:error] = 'Transfer failed'
    end
    redirect_to '/kirpoints/cashout'
  end

  def gift_kirpoints
    render 'gift'    
  end
  #TODO: Move logic to model
  #Returns true if user has an exchange with the current user
  def hasExchangeWithUser(user)
    @exchanges = exchange_list(user.id)
    for exch in @exchanges
      if current_user.id = exch.initUser || current_user.id = exch.targUser
        return true
      end
    end
    #user does not have exchange with 'user' if reached
   return false 
  end

  #TODO: Move logic to model
  #Returns array of exchanges with user
  def exchangesWithUser(user)
    @exchanges = exchange_list(user.id)
    @exchangesWithCurrentUser 
    for exch in @exchanges
      if current_user.id = exch.initUser || current_user.id = exch.targUser
        @exchangesWithCurrentUser = @exchangesWithCurrentUser + exch
      end
    end
    #user does not have exchange with 'user' if reached
   return @exchangesWithCurrentUser 
  end

  def oauth_failure
    falsh[:error] = "Unable to authenticate with Facebook"
    redirect_to root_url
  end


  def review_list(user)
    @exchanges = exchange_list(user.id)

    @reviews = nil
    for exch in @exchanges
      @reviews_from_exchange = Review.find_by_exchange_id(exch.id)
      if !@reviews_from_exchange.nil? 
        @review = @review + @reviews_from_exchange 
      end
    end

    return @reviews
  end

  def exchange_list(id)
    @exchanges = Exchange.where("initUser = ? || targUser=?", id, id)
  end
  private 

    def gateway
       @gateway ||= PaypalExpressGateway.new(
         :login => $pplogin,
         :password => $pppwd,
         :signature => $ppsig
       )
    end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to root_path, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end


    #Search
    def sort_column
      Offer.column_names.include?(params[:sort]) ? params[:sort] : "title"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
