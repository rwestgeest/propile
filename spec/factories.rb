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
    sequence(:things_i_like) {|n| "things_i_like_#{n}"}
    sequence(:things_to_improve) {|n| "things_to_improve_#{n}"}
    score 5
    association :session, factory: :session_with_presenter
    presenter
  end

  factory :comment do
    sequence(:body) {|n| "comment_body_#{n}"}
    association :review, factory: :review
    presenter
  end

  factory :account, :aliases => [:maintainer_account] do
    sequence(:email) {|n| "maintainer_#{n}@example.com"}
    role Account::Maintainer
    factory :confirmed_account do
      password 'secret'
      password_confirmation 'secret'
      after_create do |account|
        account.confirm!
      end
    end
  end

  factory :presenter_account, :class => Account do
    sequence( :email ) { |n| "presenter_#{n}@example.com" }
    role Account::Presenter
  end

  factory :vote do
    association :session, factory: :session_with_presenter
    presenter
  end

  factory :propile_config do
    sequence(:name) {|n| "propile_config_name_#{n}" }
    sequence(:value) {|n| "propile_config_value_#{n}"}
  end

  factory :program do
    sequence(:version) {|n| "program_version_#{n}" }
  end

  factory :program_entry do
    sequence(:slot) {|n| "#{n}" }
    sequence(:track) {|n| "#{n}" }
    association :session, factory: :session_with_presenter
    association :program, factory: :program
  end

  factory :program_entry_wo_session, :class => ProgramEntry  do
    sequence(:slot) {|n| "#{n}" }
    sequence(:track) {|n| "#{n}" }
    association :program, factory: :program
  end

end
