require 'faker'

namespace :scramble do
  desc 'Scramble refugees'
  task refugees: :environment do |task|
    Refugee.find_each do |refugee|
      refugee.name = Faker::Name.name.gsub(/(Prof.|Dr.|PhD.|Mgr.|Sr.)/, '').strip
      refugee.date_of_birth = Faker::Time.between(DateTime.now - 18.year, DateTime.now - 4.year).to_s[0..9]
      refugee.ssn_extension = Faker::Number.number(4)
      refugee.ssns = []
      refugee.dossier_number = Faker::Number.number(10)
      refugee.dossier_numbers = []
      refugee.social_worker = ''
      refugee.countries = []
      refugee.languages = []
      refugee.deregistered_comment = ''
      refugee.municipality_placement_comment = ''
      refugee.other_relateds = ''
      refugee.secrecy = false
      refugee.save!
    end
  end

  desc 'Scramble home names'
  task homes: :environment do |task|
    home_names = 1.upto(40).map { Faker::Ancient.titan }
    home_names << 1.upto(40).map { Faker::Ancient.hero }
    home_names << 1.upto(40).map { Faker::Ancient.titan }
    home_names << 1.upto(40).map { Faker::Ancient.primordial }
    home_names << 1.upto(40).map { Faker::Superhero.name }
    home_names << 1.upto(40).map { Faker::Superhero.descriptor }
    home_names << 1.upto(40).map { Faker::Superhero.power }
    home_names << 1.upto(40).map { Faker::TwinPeaks.location }
    home_names << 1.upto(40).map { Faker::Space.nebula }
    home_names << 1.upto(40).map { Faker::Space.star }
    home_names << 1.upto(40).map { Faker::Space.meteorite }
    home_names.flatten!.uniq!

    Home.find_each.with_index do |home, index|
      home.name = "#{home_names[index]}-#{index}"
      home.phone = ''
      home.fax = ''
      home.address = ''
      home.post_code = ''
      home.postal_town = ''
      home.languages = []
      home.comment = ''
      home.save!
    end
  end

  desc 'Run all'
  task all: [:environment, 'scramble:refugees', 'scramble:homes']
end
