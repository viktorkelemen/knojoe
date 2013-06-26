# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, aliases: [:requester, :responder] do
    name 'knojoe'
  end

  factory :chat do
    requester
    messages {
      [create(:message, author: requester)]
    }
  end

  factory :message do
    content 'a message'
  end

end
