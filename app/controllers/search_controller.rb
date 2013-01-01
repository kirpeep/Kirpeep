class SearchController < ApplicationController

	def search
    if signed_in?
      @userlistings = searchAll(params[:search])#, :conditions => {:is_deleted => '0', :category => params[:category]}, :per_page => 100)
    else
      @userlistings = UserListing.search(params[:search], :conditions => {:is_deleted => '0'}, :per_page => 100)
    end

    if @userlistings.empty?
      flash[:error] = 'No results found. Instead browse our recent listings.'
      @userlistings = UserListing.search(nil, :conditions => {:is_deleted => '0'}, :per_page => 100)
    end

  	render "show"
	end

  private
    def searchNeeds(search_query)
    
      if params[:category] && params[:category] != ""
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

    def searchOffers(search_query)
      if params[:category] && params[:category] != ""
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

    def searchUsers(search_query)
      @users= User.search(search_query, :conditions => {:is_deleted => '0'}, :per_page => 100)
      if signed_in?
        Action.log current_user.id, 'searched_users', search_query.to_s()
      else
        Action.log 0, 'searched_users', search_query.to_s()
      end  

      return @users
    end

    def searchAll(search_query)
      @all = searchOffers(search_query).flatten+searchNeeds(search_query).flatten+searchUsers(search_query).flatten
      #TODO Add independant action
    end
end
