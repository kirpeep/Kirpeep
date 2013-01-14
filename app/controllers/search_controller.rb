class SearchController < ApplicationController

	def search
    flash[:error] = nil
    debugger
    if(signed_in? && !params[:catagory])
      if params[:search] && params[:search] != '' 
        @userlistings = searchAll(params[:search], params[:catagory])#, :conditions => {:is_deleted => '0', :category => params[:category]}, :per_page => 100)
      else
        @userlistings = searchListings(params[:search], params[:catagory])
      end
    else
      @userlistings = searchListings(params[:search], params[:catagory])
    end

    if @userlistings.empty?
      flash[:error] = 'No results found. Instead browse our recent listings.'
      @userlistings = UserListing.search(nil, :conditions => {:is_deleted => '0'}, :per_page => 100)
    end

  	render "show"
	end

  private
    def searchNeeds(search_query, catagory)
    
      if catagory && catagory != ''
        @needs = UserListing.search(search_query, :conditions => {:type => 'Need', :is_deleted => '0', :category => params[:category]}, :per_page => 100)
      else
        @needs = UserListing.search(search_query, :conditions => {:type => 'Need', :is_deleted => '0'}, :per_page => 100)
      end

      if signed_in?
        Action.log current_user.id, 'searched_needs', search_query.to_s()
      else
        Action.log 0, 'searched_needs', search_query.to_s()
      end

      return @needs
    end

    def searchOffers(search_query, catagory)
      if catagory && catagory != ''
        @offers = UserListing.search(search_query, :conditions => {:type => 'Offer', :is_deleted => '0', :category => params[:category]}, :per_page => 100)
      else
        @offers = UserListing.search(search_query, :conditions => {:type => 'Offer', :is_deleted => '0'}, :per_page => 100)
      end

      if signed_in?
        Action.log current_user.id, 'searched_offers', search_query.to_s()
      else
        Action.log 0, 'searched_offers', search_query.to_s()
      end      

      return @offers
    end

    def searchUsers(search_query, catagory)
      @users= User.search(search_query, :conditions => {:is_deleted => '0'}, :per_page => 100)
      if signed_in?
        Action.log current_user.id, 'searched_users', search_query.to_s()
      else
        Action.log 0, 'searched_users', search_query.to_s()
      end  

      return @users
    end

    def searchListings(search_query, catagory)
        return searchOffers(search_query, catagory).flatten + searchNeeds(search, catagory).flatten
        
    end

    def searchAll(search_query, catagory)
      @all = searchOffers(search_query, catagory).flatten+searchNeeds(search_query, catagory).flatten+searchUsers(search_query, catagory).flatten
      #TODO Add independant action to be logged
    end
end