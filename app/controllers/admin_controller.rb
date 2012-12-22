class AdminController < ApplicationController

  before_filter :check_account

   def index
     @userCount = User.count()
     @exchCount = Exchange.count()
     @kirpointAmount = User.sum(:kirpoints)  
   end

   def credit
      @usr = User.where('email = ?', params[:email]).first!
      if @usr.nil? 
         flash[:error] = 'could not find the user'
         return redirect_to '/admin'
      end

      @usr.update_attribute(:kirpoints, @usr.kirpoints.to_f() + params[:amount].to_f())

      flash[:notice] = 'Good to go'
      return redirect_to '/admin'
   end

private
 
  def check_account
     if current_user.nil? then return redirect_to '/'  end
     if !current_user.email.end_with?("kirpeep.com") then return redirect_to root_path end
  end

end
