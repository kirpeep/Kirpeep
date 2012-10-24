####################################################
# Controller::ExchangesControler                   #
# Desc:                                            #
# Comments:                                        #
####################################################

class ExchangesController < ApplicationController

  def create

    @exchange = InitiateExchange.new params[:initiate_exchange]
    @exchange.initAcpt = true
    @user = current_user 
    @message = Message.new params[:message]
    if @exchange.save  
      @message.exchange_id = @exchange.id
      if @message.save 
        @exch_message_link = ExchangeMessageLink.new
        @exch_message_link.exchange_id = @exchange.id
        @exch_message_link.message_id = @message.id
        if @exch_message_link.save
          flash[:notice] = 'exchange saved.'
          redirect_to current_user
        end
      end
    else
    	flash[:error] = exchange.errors.full_messages.to_sentence
      redirect_to user
    end
  end

  def show

  end

  def new
    respond_to do |format|
      format.html
      if params[:type] == "init"
        render "new_init.js"
        return
      else
        render "new_targ.js"
        return
      end
    end
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

  def exchanged_items(id)
    return ExchangeItem.where("exchange_id = ?", id).allfind { |e|  }

  end

  #creates partial for additional offer listing when initiating an exchange
  def add_offer
    @targUser = User.find(params[:targ])
    @initUser = User.find(params[:init])

    render  :partial => 'create_offer', :locals => {:@targUser => @targUser, :@initUser => @initUser}
  end

  #creates partial for additional need listing when initiating an exchange
  def add_need
    @targUser = User.find(params[:targ])
    @initUser = User.find(params[:init])

    render  :partial => 'create_need', :locals => {:@targUser => @targUser, :@initUser => @initUser}
  end
end