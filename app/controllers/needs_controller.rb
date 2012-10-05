####################################################
# Controller::NeedsController                      #
# Desc:                                            #
# Comments:                                        #
####################################################

class NeedsController < ApplicationController

  def new
    @user = current_user
    @need = Need.new

    5.times {@need.assets.build}
    
    render :partial  => 'shared/list_need'
  end

  def create  
    user = User.find params[:user_id]  
    need = user.profile.needs.new params[:need]  
    
    if need.save  
    	flash[:notice] = 'Need saved'  
    	redirect_to user
    else

    	flash[:error] = need.errors.full_messages.to_sentence

        if need.errors.any?
            need.errors.full_messages.each do |msg|
                puts msg
            end
        end

    	redirect_to user
    end

  end 
  #def show
  #  @profile = Profile.find(params[:id]) 
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @user }
  #  end
  #end

  # GET /users/new
  # GET /users/new.json
  #def new
  #  @profile = Profile.new 
  #end

  # GET /users/1/edit
  def edit
    @need = Need.find(params[:id])
    @user = User.find(@need.user.id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @need = Need.find(params[:id])

    respond_to do |format|
      if @need.update_attributes(params[:need])
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
    need = Need.find(params[:id])
    #change value of 'is_deleted' to true so that it no longer displays
    need.is_deleted = true

    if need.save
      flash[:notice] = 'Need Deleted'  
      redirect_to current_user
    else

      flash[:error] = need.errors

        if need.errors.any?
            need.errors.full_messages.each do |msg|
                puts msg
            end
        end

      redirect_to current_user
    end
  end 

  def quicksale
    @listing = UserListing.find(params[:id])

    render :partial => 'shared/buy', :locals => {:listing => @listing}
  end

  def share
    @listing = UserListing.find(params[:id])

    render :partial => 'shared/share', :locals => {:listing => @listing}
  end
end
