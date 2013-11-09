# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

[ Account, ArchivedPresenter, Comment, Presenter, ProgramEntry, Program, PropileConfig, Review, Session, Vote ].each &:delete_all

module ActiveModel 
  module MassAssignmentSecurity 
    class Sanitizer 
      def sanitize(attributes, authorizer) 
        attributes 
      end 
    end 
  end 
end

Account.create!(
  id: 1,
  email: 'rob@qwan.it',
  role: 'maintainer',
  encrypted_password: '$2a$10$DGTDwo7Y0knxK8FSYufG6OQE9jaMsUGxsuSJw71V.9MFRAZbPA6eK',
  password_salt: '$2a$10$DGTDwo7Y0knxK8FSYufG6O',
  authentication_token: 'a19a45ad-0a47-67c8-31a2-e6ea89dd26a3',
  confirmed_at: Time.new( 2012, 5, 29, 12, 32 ),
  reset_at: nil,
  created_at: Time.new( 2012, 5, 24, 21, 47 ),
  updated_at: Time.new( 2012, 5, 29, 12, 32 ),
  last_login: nil,
)

Account.create!(
  id: 2,
  email: 'vera.peeters@qwan.it',
  role: 'presenter',
  encrypted_password: nil,
  password_salt: nil,
  authentication_token: nil,
  confirmed_at: nil,
  reset_at: nil,
  created_at: Time.new( 2012, 5, 24, 21, 47 ),
  updated_at: Time.new( 2012, 5, 24, 21, 47 ),
  last_login: nil,
)


Presenter.create!(
  id: 3,
  name: nil,
  bio: nil,
  created_at: Time.new( 2012, 5, 4, 8, 43 ),
  updated_at: Time.new( 2012, 5, 24, 21, 47 ),
  account_id: 1,
  twitter_id: nil,
  profile_image: nil,
  website: nil,
)

Presenter.create!(
  id: 4,
  name: nil,
  bio: nil,
  created_at: Time.new( 2012, 5, 4, 8, 43 ),
  updated_at: Time.new( 2012, 5, 24, 21, 47 ),
  account_id: 2,
  twitter_id: nil,
  profile_image: nil,
  website: nil,
)


Session.create!(
  id: 2,
  title: "Rob en Vera's brand new session",
  description: "Eerst gaan we kleuern\r\n\r\nen dan \r\n\r\nGaan we tekenen \r\n\r\nof andersom",
  created_at: Time.new( 2012, 5, 9, 8, 43 ),
  updated_at: Time.new( 2013, 11, 9, 11, 10 ),
  sub_title: nil,
  short_description: nil,
  session_type: nil,
  topic: 'other',
  duration: nil,
  intended_audience: nil,
  experience_level: nil,
  max_participants: nil,
  laptops_required: 'no',
  other_limitations: nil,
  room_setup: nil,
  materials_needed: nil,
  session_goal: nil,
  outline_or_timetable: nil,
  first_presenter_id: 3,
  second_presenter_id: 4,
  material_description: nil,
  material_url: nil,
  state: 0,
)


Review.create!(
  id: 1,
  things_i_like: 'asdasd',
  score: 10,
  session_id: 2,
  presenter_id: 3,
  created_at: Time.new( 2012, 5, 23, 19, 30 ),
  updated_at: Time.new( 2012, 5, 23, 19, 30 ),
  things_to_improve: nil,
)

Review.create!(
  id: 2,
  things_i_like: '123123',
  score: 8,
  session_id: 2,
  presenter_id: 4,
  created_at: Time.new( 2012, 5, 29, 9, 19 ),
  updated_at: Time.new( 2012, 5, 29, 9, 19 ),
  things_to_improve: 'foo',
)


Comment.create!(
  id: 1,
  body: 'gee thanks',
  review_id: 2,
  presenter_id: 4,
  created_at: Time.new( 2012, 05, 29, 9, 20 ),
  updated_at: Time.new( 2012, 05, 29, 9, 20 ),
)

Comment.create!(
  id: 2,
  body: 'nog een comment',
  review_id: 2,
  presenter_id: 3,
  created_at: Time.new( 2012, 5, 29, 10, 4 ),
  updated_at: Time.new( 2012, 5, 29, 10, 4 ),
)

Comment.create!(
  id: 3,
  body: 'asdasdasd',
  review_id: 2,
  presenter_id: 3,
  created_at: Time.new( 2012, 5, 29, 12, 37 ),
  updated_at: Time.new( 2012, 5, 29, 12, 37 ),
)


