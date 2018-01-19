# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
first_maintainer_account = Presenter.create(email: 'admin@test.it', role: Account::Maintainer).account
first_maintainer_account.password = 's3cr3t'
first_maintainer_account.confirmed_at = Time.now
first_maintainer_account.save

PropileConfig.toggle PropileConfig::SUBMIT_SESSION_ACTIVE
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
