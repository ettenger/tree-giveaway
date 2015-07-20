class Mailer < ApplicationMailer
  default from: Rails.application.secrets.gmail_username

  def conf_email(request)
    @request = request
    mail(to: @request.email, subject: 'Tree Philly Confirmation')
  end

end
