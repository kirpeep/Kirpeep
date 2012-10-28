####################################################
# Controller::OffersController                     #
# Desc:                                            #
# Comments:                                        #
####################################################

class UserlistingsController < ApplicationController

  def new
    @user = current_user
    @listing = nil
    if(params[:type] == "offer")
      @listing = Offer.new
      respond_to do |format|
        format.html {render 'new_offer'}
      end 
    else
      @listing = Need.new
      respond_to do |format|
        format.html {render 'new_need'}
      end 
    end

    5.times {@listing.assets.build}
  end

  def create  
    user = current_user 
    listingType = params[:type]
    listing = nil
    if(listingType == "offer")
      listing = user.profile.offers.new params[:offer] 
      listing.listingType = 'offer'
    else
      listing = user.profile.needs.new params[:need]
      listing.listingType = 'need' 
    end

    if listing.save
      if(listingType == "offer")
        flash[:notice] = 'Offer saved'   
      else
        flash[:notice] = 'Need saved'
      end  
    	 
      respond_to do |format|
    	 format.html {redirect_to user}
       format.json
      end
    else

    	flash[:error] = listing.errors.full_messages.to_sentence

        if listing.errors.any?
            listing.errors.full_messages.each do |msg|
                puts msg
            end
        end

    	respond_to do |format|
       format.html {redirect_to user}
       format.json #code to inform 
      end
    end
  end 

  def show
    @listing = UserListing.find(params[:id]) 
    
    if(params[:listing_type] == "offer")
      respond_to do |format|
        format.html { show_offer.html }# show.html.erb
        format.json 
      end
    else
      respond_to do |format|
        format.html {show_need.html}
        format.json 
      end
    end
  end

  #display user listing on the results page
  def show_listing_result
      listing = UserListing.find(params[:id]) 
      @user = listing.user
      
      if listing.type == "Offer"
        render :partial => 'show_offer', :locals => {:listing => listing, :@user => @user}
      else 
        render :partial => 'show_need', :locals => {:listing => listing, :@user => @user}
      end
  end

  #display user listing on the exchange modals
  #def show_listing_exchange
  #    listing = UserListing.find(params[:id]) 
  #    @user = listing.user
  #    targ = User.find(params[:targ])
  #    if listing.type == "Offer"
  #      render :partial => 'show_exchange_offer', :f => f, :locals => {:listing => listing, :@user => @user, :targ => targ }
  #    else 
  #      render :partial => 'show_exchange_need', :f => f, :locals => {:listing => listing, :@user => @user, :targ => targ }
  #    end
  #end

  def edit
    @listing = UserListing.find(params[:id]) 

    if(params[:listing_type] == "offer")
      respond_to do |format|
        format.html {render 'edit_offer'} # edit.html.erb
        format.json 
      end
    else
      respond_to do |format|
        format.html {render 'edit_need'} # edit.html.erb
        format.json 
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    
    @listing = UserListing.find(params[:id])
    
    if(@listing.type == "Offer")
      respond_to do |format|
        if @listing.update_attributes(params[:offer])
          format.html { redirect_to current_user, notice: 'Your offer was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: current_user.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        if @listing.update_attributes(params[:need])
          format.html { redirect_to current_user, notice: 'Your need was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: current_user.errors, status: :unprocessable_entity }
        end
      end
    end   
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    listing = UserListing.find(params[:id])
    #change value of 'is_deleted' to true so that it no longer displays
    listing.is_deleted = true

    if listing.save
      if(listing.type == "Offer")
        flash[:notice] = 'Offer Deleted'  
      else
        flash[:notice] = 'Need Deleted'  
      end

      respond_to do |format|
        format.html {redirect_to current_user}
        format.js 
      end
    else

      flash[:error] = listing.errors

        if listing.errors.any?
            listing.errors.full_messages.each do |msg|
                puts msg
            end
        end

      redirect_to current_user
    end
  end

  def share
    listing = UserListing.find(params[:id])
    @user_photo = listing.user.profile.photo.url
    render :partial => "share", :locals => {:@user_photo => @user_photo, :listing => listing}
  end 

  def getListing
    render :json => UserListing.find(params[:id])
  end
end
