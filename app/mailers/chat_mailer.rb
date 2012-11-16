class ChatMailer < ActionMailer::Base
  default from: "no-reply@knojoe.com"

  def send_conversation(chat, user)
    @user = user
    @chat = chat

    mail to: user.email
  end
end
