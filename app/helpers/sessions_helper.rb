module SessionsHelper 

  #sign_in being used by devise, had to change global signin function
  def sign_in_(user)
     if user.Active == true
	cookies.permanent.signed[:remember_token] = [user.id, user.salt]
	self.current_user = user
	User.set_chat_status(current_user.id, "available")
	
     else
       flash[:error] = "This account has not yet been activated."
     end
  end

  def sign_out
    User.set_chat_status(current_user.id, "logged_off")
	  cookies.delete(:remember_token)
	  self.current_user = nil
  end

  def current_user=(user)
	@current_user = user
  end

  def current_user
	@current_user ||= user_from_remember_token
  end

  #returns true if the user passed
  #is the current user
  def is_current_user(user)
     if current_user
       current_user.id == user.id
     else
       false
     end
  end

  def signed_in?
	!current_user.nil?
  end

  def create
    user = User.authenticate(params[:session][:email], 
                params[:session][:password])

  	if user.nil?
  		flash[:error] = "Invalid email/password combination."
  		@title = "Sign In"
  		redirect_to root_path
  	else 
  	    sign_in_ user
  	    flash[:notice] = "Welcome, #{user.name}"
  	    redirect_to user
  	end
  end

  def destroy
  	sign_out
  	redirect_to root_path
  end	

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end
  
	private

		def user_from_remember_token
			User.authenticate_with_salt(*remember_token)
		end

		def remember_token
			cookies.signed[:remember_token] || [nil,nil]
		end  
end
