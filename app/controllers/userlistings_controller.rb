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
    elsif (listingType == "need")
      listing = user.profile.needs.new params[:need]
      listing.listingType = 'need' 
    else
      listing = user.profile.needs.new params[:kirpoint]
      listing.listingType = 'kirpoint' 
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

  def show_listing
    @listing = UserListing.find(params[:id]) 
    if signed_in?
      Action.log current_user.id, 'viewListingDetailsPage', @listing.id
    else
      Action.log nil, 'viewListingDetailsPage', @listing.id
    end
    render 'show'
  end

  #display user listing on the results page
  def show_listing_result
    listing = UserListing.find(params[:id]) 
    @user = listing.user
    posted_on = time_ago_in_words(listing.created_at)

    if listing.type == "Offer"
      render :partial => 'show_offer', :locals => {:listing => listing, :@user => @user, :posted_on => posted_on}
    else 
      render :partial => 'show_need', :locals => {:listing => listing, :@user => @user, :posted_on => posted_on}
    end
  end

  #display user listing on the exchange modals
  def show_listing_exchange
    if params[:id].to_i == -1 || params[:id].to_i == -2
      #item = ExchangeItem.find()
      render :partial => 'show_exchange_kirpoint'
    else
      listing = UserListing.find(params[:id]) 
      @user = listing.user
      targ = User.find(params[:targ])
      if listing.type == "Offer"
        render :partial => 'show_exchange_offer', :locals => {:listing => listing, :@user => @user, :targUser => targ }
      else 
        render :partial => 'show_exchange_need', :locals => {:listing => listing, :@user => @user, :targUser => targ }
      end
    end
  end

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

  def edit_location
    @listing = UserListing.find(params[:id]) 
    @marker = @listing.to_gmaps4rails
    
    if @listing.user.id != current_user.id
      flash[:error] = "There was an issue accessing specified listing"
      redirect_to current_user
    end
    respond_to do |format|
      format.html {render 'edit_listing_location'} 
      format.json 
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

    if listing.save(:validate => false)
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



      if listing.errors.any?
        listing.errors.full_messages.each do |msg|
          flash[:error] = msg
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

  def report
   @listing = UserListing.find(params[:id])
   UserMailer.report_email(@listing, current_user).deliver
 end

 def getListing
    #render :json => UserListing.find(params[:id])

    listing = UserListing.find(params[:id])
    targUser = User.find(params[:targ])
    initUser = User.find(params[:init])
    if params[:type] == "offer"
      render :partial => 'show_exchange_offer', :locals => {:listing => listing, :targUser => targUser, :initUser => initUser}
    else
      render :partial => 'show_exchange_need', :locals => {:listing => listing, :targUser => targUser, :initUser => initUser}
    end
  end

  def ditto
    @listing = UserListing.find(params[:id])

    user = current_user 
    
    if(@listing.type == "offer")
     @new_listing = user.profile.offers.new @listing.dup.attributes 
    else 
     @new_listing = user.profile.needs.new @listing.dup.attributes
    end

    begin  
      @new_listing.photo = open(@listing.photo(:url))
    rescue
      @new_listing.photo = nil
    end 

    if @new_listing.save(:validate => false)
      flash[:success] = "Listing Dittoed"
    else
     flash[:error] = @new_listing.errors.full_messages.first
   end

   respond_to do |format|
     format.html {redirect_to root_url}
     format.js {render 'ditto_success'}
   end
 end
end
