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
      exch.initCode = 'c-' + User.generateToken()[0..5] 
      exch.targCode = 'c-' + User.generateToken()[0..5] 

      if exch.save
        # send SMS Messages Here
        @targUser = User.find(exch.targUser)
        @initUser = User.find(exch.initUser)

        # only send if we have verified phone numbers for both parties. 
        if (@targUser.profile.phone_number && @targUser.profile.number_verified == true) &&
            (@initUser.profile.phone_number && @initUser.profile.number_verified == true)

           #Then send SMS conf codes
           sendTxt(@targUser.profile.phone_number, "Your code is #{exch.targCode}. Text the other person's code when your are finished exchanging to let us it's complete. Thanks, Kirpeep!")
           sendTxt(@initUser.profile.phone_number, "Your code is #{exch.initCode}. Text the other person's code when your are finished exchanging to let us it's complete. Thanks, Kirpeep!")
        end

        flash[:notice] = 'exchange moved to .'  + (exch.type).to_s
        redirect_to current_user
        return
      else
        flash[:notice] = 'did not save'
        redirect_to current_user
        return
      end
    end

    flash[:notice] = 'exchange updated. user: ' + params[:user_id].to_s
    redirect_to current_user
  end

  #Acceptance of Performed Exchange
  def accept_perform
    exch = PerformExchange.find(params[:exch_id])

    if(exch.initUser == params[:user_id])
      exch.initComp = true
      flash[:notice] = 'exchange ' + (exch.id).to_s + ' updated. InitComp: ' + (exch.initComp).to_s
    else 
      exch.targComp = true
      flash[:notice] = 'exchange updated. TargAcptComp: ' + (exch.targComp).to_s
    end
      exch.save
    if(exch.initComp == true && exch.targComp == true)
      exch.type = 'RateExchange'
      exch.save 

      exch = exch.becomes(RateExchange)
      if exch.save
          flash[:notice] = 'exchange moved to .'  + (exch.type).to_s
          redirect_to current_user
          return
      else
          flash[:notice] = 'did not save'
          redirect_to current_user
          return
      end
    end
    flash[:notice] = 'exchange ' + (exch.id).to_s + ' updated. InitComp: ' + (exch.initComp).to_s + ' TargComp: ' + (exch.targComp).to_s
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
          flash[:notice] = 'exchange moved to .' + (exch.type).to_s
          redirect_to current_user
          return
      else
          flash[:notice] = 'did not save'
          redirect_to current_user
          return
      end
    end
    flash[:notice] = 'Rated exchange #' + (exch.id).to_s + "  " + (exch.initUser).to_s + ' == ' + (params[:user_id]).to_s + 'InitUserRate: ' + (exch.init_rating_overall != nil).to_s + ' TargUserRate: ' + (exch.targ_rating_overall != nil).to_s + (exch.init_rating_overall != nil && exch.targ_rating_overall != nil).to_s
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
    dropdownItems = [["Select an item", -9],[":Your Needs:", -9] ]  
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
    dropdownItems = [["Select an item", -9],[":Your Offers:", -9] ]  
    dropdownItems.concat( userOffers)
    dropdownItems = dropdownItems + [[":Their Needs:", -9]]
    dropdownItems.concat(targNeeds)

    render :partial => 'create_offer', :locals => {:initUser => initUser, :targUser => targUser, :dropdownItems => dropdownItems}   
  end
end
