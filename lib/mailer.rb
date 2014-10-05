require 'action_mailer'

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address              => "mail.cs.helsinki.fi",
  :port                 => 587,
  :domain               => 'cs.helsinki.fi',
  :user_name            => ENV["SMTP_USERNAME"],
  :password             => ENV["SMTP_PASSWORD"],
  :authentication       => 'login',
  :enable_starttls_auto => true
}
ActionMailer::Base.view_paths = File.dirname(__FILE__)

class Mailer < ActionMailer::Base

  def alert(email, body)
    @body = body
    mail( :to      => email,
         :from    => "TMC PROBER <jarmoiso@cs.helsinki.fi>",
         :subject => "FYI: Some TMC probers has failed") do |format|
           format.html
         end
  end
end
