class ChatMailer < ActionMailer::Base
  default from: "no-reply@knojoe.com"

  def send_conversation(chat, user, email)
    @user = user
    @chat = chat

    mail to: email
  end
end
