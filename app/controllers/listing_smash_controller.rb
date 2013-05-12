class ListingSmashController < ApplicationController

	#POST /listingsmash/:id_y/over/:id_n/in/:time
	def add_listing_smash_result
		ListingSmash.add(current_user.id, params[:id_y], params[:id_n], params[:time])
	end

	def show
		
	end
end
