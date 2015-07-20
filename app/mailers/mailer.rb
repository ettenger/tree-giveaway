class Mailer < ApplicationMailer
  default from: "phillytreegiveaway@gmail.com"

  def conf_email(request)
    @request = request
    mail(to: @request.email, subject: 'Tree Philly Confirmation')
  end

end
