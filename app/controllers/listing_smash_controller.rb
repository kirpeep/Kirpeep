class ListingSmashController < ApplicationController

	#POST /listingsmash/:id_y/over/:id_n/in/:time
	def add_listing_smash_result
		reactionTime = Time.now.to_i - params[:time].to_i
		ListingSmash.add(current_user.id, params[:id_y], params[:id_n], reactionTime)
		render:nothing => true, :status => 200, :content_type => 'text/html'
	end

	def show
		
	end

	#GET /listingsmash/newlistings
	def render_new_listings
		render :partial => 'listings';
	end

end
