####################################################
# Controller::ProfilesController                   #
# Desc:                                            #
# Comments:                                        #
####################################################

class ProfilesController < ApplicationController
  
  respond_to :html, :json
  #before_filter :signed_in_user, :only => [:show, :edit, :update, :destroy]

  #Function shows users profile and shows read only version of profile if current_user != profile being viewed
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

  #Function edits users profile
  def edit
    @profile = Profile.find(params[:id])
  end

  #Function creates a new profile
  def create
    
    @profile = Profile.find(params[:id])
    @profile.update_attributes(params[:profile])

    respond_with current_user

  end

  #Function updates a users profile
  def update
    @profile = Profile.find(params[:id])
    params[:profile][:phone_number] = params[:profile][:phone_number].gsub(/[^0-9]/, '')
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

  #TODO no way to destroy profile at this time
  def destroy
    
  end

end
