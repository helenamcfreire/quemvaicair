class NotifierController < ActionMailer::Base

  def sendmail(recipient, body)
    mail(:from => 'Helena Freire <helenamcfreire@gmail.com>',
         :to => recipient,
         :subject => t(:confirm),
         :content_type => 'text/html',
         :body => t(:body_email) + body + t(:sorte)
    )
  end

end
