class ReviewsController < ApplicationController

	def new
		@review = Review.new
	end

	def create
		@review = Review.new params[:initiate_review]
   
	    if @review.save 
	        flash[:notice] = 'review saved.'
	        redirect_to current_user
	    else
	  	  flash[:error] = @review.errors.full_messages.to_sentence
	      redirect_to current_user
	    end
	end
end
