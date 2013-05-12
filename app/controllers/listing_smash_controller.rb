class ListingSmashController < ApplicationController

	#POST /listingsmash/:id_y/over/:id_n/in/:time
	def add_listing_smash_result
		reactionTime = Time.now - params[:time]
		ListingSmash.add(current_user.id, params[:id_y], params[:id_n], reactionTime)
	end

	def show
		
	end

end
