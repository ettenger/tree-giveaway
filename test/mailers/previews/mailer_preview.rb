# Preview all emails at http://localhost:3000/rails/mailers/mailer
class MailerPreview < ActionMailer::Preview
  def conf_email_preview
    Mailer.conf_email(Request.first)
  end
end
