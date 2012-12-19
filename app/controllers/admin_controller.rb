class AdminController < ApplicationController

  before_filter :check_account

   def index
     @userCount = User.count()  
   end

private
 
  def check_account
     if current_user.nil? then return redirect_to '/'  end
     if !current_user.email.end_with?("kirpeep.com") then return redirect_to root_path end
  end

end
