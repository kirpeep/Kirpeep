class SearchController < ApplicationController

  def search
    flash[:error] = nil
    @userlistings = UserListing.GetAllByQuery(params[:search])
    if @userlistings.empty?
      flash[:error] = 'No results found. Instead browse our recent listings.'
      @userlistings = UserListing.search(nil, :conditions => {:is_deleted => '0'}, :order => :created_at, :per_page => 100)
    end

  	render "show"
  end
end
