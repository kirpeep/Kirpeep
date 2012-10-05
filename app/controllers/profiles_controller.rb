####################################################
# Controller::ProfilesController                   #
# Desc:                                            #
# Comments:                                        #
####################################################

class ProfilesController < ApplicationController
  
  respond_to :html, :json
  #before_filter :signed_in_user, :only => [:show, :edit, :update, :destroy]

  def index
    @profile = User.current_user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @profile = Profile.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @profile = Profile.new 
  end

  # GET /users/1/edit
  def edit
    @profile = Profile.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @profile = Profile.find(params[:id])
    @profile.update_attributes(params[:profile])

    respond_with current_user

  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @profile = Profile.find(params[:id])

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to current_user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    
  end
end
