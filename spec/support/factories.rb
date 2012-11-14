# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chat do
  end

  factory :message do
    content 'a message'
  end
end
