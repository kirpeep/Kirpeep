####################################################
# Controller::ExchangeItemsController              #
# Desc:                                            #
# Comments:                                        #
####################################################

class ExchangeItemsController < ApplicationController

	def create
		if [:exchange_item][:kirpoints] != nil
			@exchange_item = ExchangeItemKirpoint.new params[:exchange_item_kirpoint]
		else
			@exchange_item = ExchangeItem.new params[:exchange_item]
			
		end

		if @exchange_item.save
	          flash[:notice] = 'exchange item saved.'
	          redirect_to current_user
	        
	    else
	    	flash[:error] =error+@exchange_item.errors.full_messages.to_sentence
	        redirect_to current_user
	    end
	end

	def new
		@exchange_item = ExchangeItem.new
	end
	
	def show

	end

	
end
