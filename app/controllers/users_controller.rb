####################################################
# Controller::UsersController                      #
# Desc:                                            #
# Comments:                                        #
####################################################

class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  # GET /users
  # GET /users.json

  before_filter :signed_in_user, :only => [:show, :edit, :update, :destroy], :except => [:forgot, :process_forgot, :reset_password, :process_reset_password, :new, :create, :activate]
  #before_filter :correct_user, :only => [:show, :edit, :update, :destroy]
  
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @title = @user.name
    
    
    if @user.id == current_user.id
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
    @user = User.new(params[:user])
    # A user must activate via an activation email
    # Before they are allowed to use the system - kyle
    @user.Active = false 
    @user.token = User.generateToken
    @user.profile = Profile.new

    respond_to do |format|
      if @user.save
        UserMailer.activate_email(@user).deliver
       # sign_in @user
        format.html { redirect_to @user, notice: 'User was successfully created and your activation email has been sent.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html {  redirect_to root_url, notice: 'User was not successfully created.'  }
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
        format.json { render json: @user.errors, status: :unprocessable_entity }
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

  def initiate_exchange
    @user = current_user
    @targ_listing = UserListing.find params[:targ]

    render :partial  => 'initiate_exchange'
  end

  def profile
    @user = User.find(params[:id])

    render :partial => 'profile', :locals => {:user => @user}
  end

  def exchanges
    @user = User.find(params[:id])

    render :partial => 'exchange', :locals => {:user => @user}
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
    @needs = current_user.needs
    respond_to do |format|
      format.json {render :json => @needs}
    end
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
       redirect_to('/forgot') 
    end
   	
    @user = User.find_by_email(params[:email])
    if @user.nil?
       flash[:error] = 'We were unable to find this email in our system.'
       redirect_to('/forgot')
    else
       @token = User.generateToken
       @user.update_attribute(:token, @token.to_s)
       UserMailer.forgot_email(@user).deliver
       flash[:notice] = 'An email was sent to your email account.'
       redirect_to('/forgot')
    end	
  end
  
  def reset_password
    if params[:id].nil? || params[:token].nil? 
      redirect_to root_path, notice: 'Missing Requirements'  
    else
      @user = User.where("id = ? AND token = ?", params[:id], params[:token]).first!
      if @user.nil?
        redirect_to root_path, notice: 'Missing Requirements'
      else
        respond_to do |format|
          format.html
        end
      end
    end
  end

  def process_reset_password
    if params[:id].nil? || params[:password].nil? || params[:confirm].nil?
      redirect_to '/resetpassword', error: 'Missing some information'
    else
      if params[:password] != params[:confirm]
        redirect_to '/resetpassword', error: 'Passwords do not match'
      else
        @user = User.find(params[:id])
        @user.update_attribute(:password, params[:password])
        redirect_to '/resetpassword', notice: 'Your password has been reset'
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
         sign_in @user
         redirect_to root_path
       end
    end
  end

  private 

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
