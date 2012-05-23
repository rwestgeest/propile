# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :presenter do
    sequence(:email) {|n| "presenter_#{n}@example.com" }
    sequence(:name) {|n| "presenter_#{n}"}
  end
  factory :session do
    sequence(:title) {|n| "title_#{n}"}
    sequence(:description) {|n| "description_#{n}"}
    factory :session_with_presenter do
      sequence(:first_presenter_email) { |n| "first_presenter_#{n}@presenters.com" }
    end
  end
  factory :review do
    sequence(:body) {|n| "review_body_#{n}"}
#    session
    presenter
  end
  factory :comment do
    sequence(:body) {|n| "comment_body_#{n}"}
#    review
    presenter
  end

  factory :account do
    sequence(:login) {|n| "login_name_#{n}"}
    role Account::Maintainer
    factory :confirmed_account do
      password 'secret'
      password_confirmation 'secret'
      after_create do |account|
        account.confirm!
      end
    end
    
  end
end
