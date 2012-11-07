####################################################
# Controller::ExchangesControler                   #
# Desc:                                            #
# Comments:                                        #
####################################################

class ExchangesController < ApplicationController

  def create
    @user = current_user
    @exchange = InitiateExchange.new params[:initiate_exchange]
    #@exchange.exchange_items.each.build
    #@exchange.build_message(params[:initiate_exchange][:message])
    @exchange.initAcpt = true
     
    
    if @exchange.save
        flash[:notice] = 'exchange saved.'
        redirect_to current_user
    else
  	  flash[:error] = @exchange.errors.full_messages.to_sentence
      redirect_to current_user
    end
  end

  def show
    @exch = Exchange.find(params[:id]) 
    @targUser = User.find(@exch.targUser )
    @initUser = User.find(@exch.initUser )
    @exchange_items = exchanged_items
    #not the greatest way to do this, with this code we will not be able to do \
    #multiparty exchanges. To resolve a migration should be made to include initUsers id 
    #so that it doesn't need to be pulled from the listing
    #for now the items with :targ_user_id will be assinged
    @targItems = @exchange_items.find_all_by_targ_user_id( @targUser.id)
    @initItems = @exchange_items.find_all_by_targ_user_id(@initUser.id)
  end

  def new
    @exchange = InitiateExchange.new
  end

  def initiate_exchange
    @initexch = InitiateExchange.new
    @user = current_user
    @targListing = UserListing.find params[:id]
    @targUser = @targListing.user
    UserMailer.message_email(@targUser, @user, @user.name + " would like to start an exchange with you.", "Go to your profile on kirpeep.com to see your new exchange!" ).deliver
    render :partial  => 'initiate_exchange'
  end

  #Acceptance of initiated Exchange
  def accept_exchange
    exch = InitiateExchange.find(params[:exch_id])

    if(exch.initUser == params[:user_id])
      exch.initAcpt = true
    else 
      exch.targAcpt = true
    end

    if(exch.initAcpt == true && exch.targAcpt == true)
    
      
      exch.type = 'PerformExchange'
      exch.save

      exch = exch.becomes(PerformExchange)

      #create codes and save
      initConfCode = 'c-' + User.generateToken()[0..5]
      targConfCode = 'c-' + User.generateToken()[0..5]
      exch.initConfCode = initConfCode.downcase
      exch.targConfCode = targConfCode.downcase

      if exch.save
        # send SMS Messages Here
        @targUser = User.find(exch.targUser)
        @initUser = User.find(exch.initUser)
        
        UserMailer.message_email(@targUser, @initUser, @initUser.name + " is ready to perform the exchange.", "Go to your profile on kirpeep.com to see accept the exchange or use our SMS confirmation during your meet up to confirm the trade." ).deliver
        UserMailer.message_email(@initUser, @targUser, @targUser.name + " is ready to perform the exchange.", "Go to your profile on kirpeep.com to see accept the exchange or use our SMS confirmation during your meet up to confirm the trade." ).deliver

        # only send if we have verified phone numbers for both parties. 
        if (@targUser.profile.phone_number && @targUser.profile.number_verified == true) &&
            (@initUser.profile.phone_number && @initUser.profile.number_verified == true)

           #Then send SMS conf codes
           sendTxt(@targUser.profile.phone_number, "Your code is #{exch.targConfCode}. Text the other person's code when your are finished exchanging to let us it's complete. -Kirpeep")
           sendTxt(@initUser.profile.phone_number, "Your code is #{exch.initConfCode}. Text the other person's code when your are finished exchanging to let us it's complete. -Kirpeep")
        end

        flash[:notice] = 'exchange moved to '  + (exch.type).to_s
        redirect_to current_user
        return
      else
        flash[:notice] = 'did not save'
        redirect_to current_user
        return
      end
    end

    flash[:notice] = 'exchange updated.'
    redirect_to current_user
  end

  #Acceptance of Performed Exchange
  def accept_perform
    exch = PerformExchange.find(params[:exch_id])
    
    @targUser = User.find(exch.targUser)
    @initUser = User.find(exch.initUser)
        
    if(exch.initUser == params[:user_id])
      UserMailer.message_email(@targUser, @initUser, @initUser.name + " is ready to be rated.", "Go to your profile on kirpeep.com to rate your exchange." ).deliver
      exch.initComp = true
      flash[:notice] = 'exchange updated.'
    else
      UserMailer.message_email(@initUser, @targUser, @targUser.name + " is ready to be rated.", "Go to your profile on kirpeep.com to rate your exchange." ).deliver  
      exch.targComp = true
      flash[:notice] = 'exchange updated.'
    end
      exch.save
    if(exch.initComp == true && exch.targComp == true)
      exch.type = 'RateExchange'
      exch.save 

      exch = exch.becomes(RateExchange)
      if exch.save
          flash[:notice] = 'exchange moved to '  + (exch.type).to_s
          redirect_to current_user
          return
      else
          flash[:notice] = 'did not save'
          redirect_to current_user
          return
      end
    end
    flash[:notice] = 'exchange updated.'
    redirect_to current_user
  end

  def rate_exchange
    exch = RateExchange.find(params[:exch_id])

    if(exch.initUser == params[:user_id])
      exch.init_rating_time    = params[:time]
      exch.init_rating_cost    = params[:cost]
      exch.init_rating_ease    = params[:ease]
      exch.init_rating_overall = params[:overall]
      exch.init_comments       = params[:comments]
    else
      exch.targ_rating_time    = params[:time]
      exch.targ_rating_cost    = params[:cost]
      exch.targ_rating_ease    = params[:ease]
      exch.targ_rating_overall = params[:overall]
      exch.targ_comments       = params[:comments]
    end
    exch.save
    if(exch.init_rating_overall != nil && exch.targ_rating_overall != nil)
      ex_type = exch.type
      exch.type = 'ArchivedExchange'
      exch.save 

      exch = exch.becomes(ArchivedExchange)
      exch.type_when_term = ex_type
      if exch.save
          flash[:notice] = 'exchange moved to ' + (exch.type).to_s
          redirect_to current_user
          return
      else
          flash[:notice] = 'did not save'
          redirect_to current_user
          return
      end
    end
    flash[:notice] = 'Rated exchange '
    redirect_to current_user
  end

  def exchanged_items
    ExchangeItem.where("exchange_id = ?", params[:id])
  end

  def add_need
    initUser = User.find(params[:init])
    targUser = User.find(params[:targ])

    userNeeds = initUser.needs.all.map { |need| [need.title, need.id] }
    targOffers = targUser.offers.all.map { |offer| [offer.title, offer.id] } 
    dropdownItems = [["Select an item", -9],["Kirpoints", -2],[":Your Needs:", -9] ]  
    dropdownItems.concat(userNeeds)
    dropdownItems = dropdownItems + [[":Their Offers:", -9]]
    dropdownItems.concat(targOffers)

    render :partial => 'create_need', :locals => {:initUser => initUser, :targUser => targUser, :dropdownItems => dropdownItems}    
  end

  def add_offer
    initUser = User.find(params[:init])
    targUser = User.find(params[:targ])

    userOffers = initUser.offers.all.map { |offer| [offer.title, offer.id] }
    targNeeds = targUser.needs.all.map { |need| [need.title, need.id] } 
    dropdownItems = [["Select an item", -9],["Kirpoints", -1],[":Your Offers:", -9] ]  
    dropdownItems.concat( userOffers)
    dropdownItems = dropdownItems + [[":Their Needs:", -9]]
    dropdownItems.concat(targNeeds)

    render :partial => 'create_offer', :locals => {:initUser => initUser, :targUser => targUser, :dropdownItems => dropdownItems}   
  end


  #add kirpoints to the exchange on the fly
  def add_kirpoints_listing
      initUser = User.find(params[:init])
      targUser = User.find(params[:targ])
      type = params[:type]
      
      render :partial => 'create_kirpoints', :locals => {:initUser => initUser, :targUser => targUser, :listingType => type}   
      
  end
end
