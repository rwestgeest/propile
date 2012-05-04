# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :presenter do
    sequence(:email) {|n| "presenter_#{n}@example.com" }
    sequence(:name) {|n| "presenter_#{n}"}
  end
  factory :session do
    sequence(:title) {|n| "title_#{n}"}
    sequence(:description) {|n| "description_#{n}"}
  end
end
