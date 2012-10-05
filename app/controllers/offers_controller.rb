####################################################
# Controller::OffersController                     #
# Desc:                                            #
# Comments:                                        #
####################################################

class OffersController < ApplicationController

  def new
    @user = current_user
    @offer = Offer.new

    5.times {@offer.assets.build}

    render :partial  => 'shared/list_offer' 
  end

  def create  
    user = User.find params[:user_id]  
    offer = user.profile.offers.new params[:offer]  

    if offer.save  
    	flash[:notice] = 'Offer saved'  
    	redirect_to user
    else

    	flash[:error] = offer.errors.full_messages.to_sentence

        if offer.errors.any?
            offer.errors.full_messages.each do |msg|
                puts msg
            end
        end

    	redirect_to user
    end

  end 
  
  def edit
    @offer = Offer.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @offer = Offer.find(params[:id])

    respond_to do |format|
      if @offer.update_attributes(params[:offer])
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
    offer = offer.find(params[:id])
    #change value of 'is_deleted' to true so that it no longer displays
    offer.is_deleted = true

    if offer.save
      flash[:notice] = 'Offer Deleted'  
      redirect_to current_user
    else

      flash[:error] = offer.errors

        if offer.errors.any?
            offer.errors.full_messages.each do |msg|
                puts msg
            end
        end

      redirect_to current_user
    end
  end 
end