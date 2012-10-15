class UserMailer < ActionMailer::Base
  default from: "noreply@kirpeep.com"

  def forgot_email(user)
     @url = $domain + '/resetpassword?id=' + user.id.to_s + '&token=' + user.token.to_s
     mail(:to => user.email, :subject => 'Kirpeep password reset')
  end
end
