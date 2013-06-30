# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, aliases: [:requester, :responder] do
    name 'knojoe'
    sequence :email do |n|
      "person#{n}@example.com"
    end
  end

  factory :chat do
    requester
    messages {
      [create(:message, author: requester)]
    }
  end

  factory :message do
    sequence(:content) {|n| "a user message #{n}" }
    status 'user'
  end

  factory :system_message, class: Message do
    author nil
    status 'system'
    sequence(:content) {|n| "a system message #{n}" }
  end
end
