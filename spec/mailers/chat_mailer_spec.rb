require "spec_helper"

describe ChatMailer do
  describe '#send_conversation' do
    let(:mail) { ChatMailer.send_conversation(chat, user, 'to@example.com') }
    let(:chat) { stub(:chat, id: 1, created_at: Time.zone.now, messages: [stub(content: 'hello', author: user)]) }
    let(:user) { stub(:user) }

    it 'sets subject based on I18n' do
      mail.subject.should eq(I18n.t('chat_mailer.send_conversation.subject'))
    end

    it 'sends to specified recipient' do
      mail.to.should eq(['to@example.com'])
    end

    it 'includes review chat url in mail body' do
      mail.body.encoded.should include(review_chat_url(chat.id))
    end

    it 'includes chat message' do
      mail.body.encoded.should include('hello')
    end

  end

end
