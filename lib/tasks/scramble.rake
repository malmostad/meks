require 'faker'

namespace :scramble do
  desc 'Scramble fields in database'
  task test_db: :environment do |task|
    Refugee.find_each do |refugee|
      refugee.name = Faker::Name.name.gsub(/(Prof.|Dr.|PhD.|Mgr.|Sr.)/, '').strip
      refugee.date_of_birth = Faker::Time.between(DateTime.now - 18.year, DateTime.now - 4.year).to_s[0..9],
      refugee.ssn_extension = Faker::Number.number(4)
      refugee.ssns = []
      refugee.dossier_number = Faker::Number.number(10)
      Refugee.dossier_numbers = []
      refugee.social_worker = ''
      refugee.countries = []
      refugee.languages = []
      refugee.save
    end

    home_names = 1.upto(20).map { Faker::Ancient.titan }
    home_names << 1.upto(20).map { Faker::Ancient.hero }
    home_names << 1.upto(20).map { Faker::Ancient.titan }
    home_names << 1.upto(20).map { Faker::Ancient.primordial }
    home_names.flatten.uniq!

    Home.find_each.with_index do |home, index|
      home.name = home_names[index]
      home.phone = ''
      home.fax = ''
      home.address = ''
      home.post_code = ''
      home.postal_town = ''
      home.languages = []
      home.save
    end
  end
end
