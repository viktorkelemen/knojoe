# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    chat nil
    author_id 1
    content "MyText"
  end
end
