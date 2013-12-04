class NotifierController < ActionMailer::Base

  def sendmail(recipient, body)
    mail(:from => 'Quem Vai Cair <quemvaicair@gmail.com>',
         :to => recipient,
         :subject => t(:confirm),
         :content_type => 'text/html',
         :body => t(:body_email) + body + t(:sorte)
    )
  end

end
