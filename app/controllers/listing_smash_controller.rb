class ListingSmashController < ApplicationController

	#POST /listingsmash/:id_y/over/:id_n/in/:time
	def add_listing_smash_result
		reactionTime = Time.now.to_i - params[:time].to_i
		ListingSmash.add(current_user.id, params[:id_y], params[:id_n], reactionTime)
	end

	def show
		
	end

	#GET /listingsmash/newlistings
	def render_new_listings
		render 'listings';
	end

end
