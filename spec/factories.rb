# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :presenter do
    email {|n| "presenter_#{n}@example.com" }
    name {|n| "presenter_#{n}"}
  end
  factory :session do
    title {|n| "title_#{n}"}
    description {|n| "description_#{n}"}
  end
end
