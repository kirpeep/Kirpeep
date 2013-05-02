####################################################
# Controller::SessionsController                   #
# Desc:                                            #
# Comments:                                        #
####################################################

class SessionsController < ApplicationController
  #include SessionsHelper

  def index
  	@title = "Kirpeep | Realize Yourself"
  end

  def new
  	render :partial  => 'shared/signin'
  end

  def signin
  	render :partial  => 'shared/signin'
  end

  def facebook_create
    user = User.from_omniauth(env['omniauth.auth'])
    if user.nil?
      flash[:error] = "Invalid email/password combination."
      @title = "Sign In"
      redirect_to root_path
    else 
      sign_in_ user
      flash[:notice] = "Welcome, #{user.name}"

      if user.created_at < 1.minute.ago
        redirect_to user + '?modalurl=/userlisting/new?type=offer'
      else
        redirect_to user
      end
    end
  end
end
