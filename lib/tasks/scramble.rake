require 'faker'

namespace :scramble do
  desc 'Scramble people'
  task people: :environment do
    countries = Country.where(id: [313, 251, 318])

    Person.find_each do |person|
      person.name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
      person.date_of_birth =
        person.date_of_birth.to_s[0..3] +
        Faker::Time.between(DateTime.now.beginning_of_year, DateTime.now.end_of_year).to_s[4..9]
      person.ssn_extension = Faker::Number.number(4)
      person.ssns = []
      person.dossier_number = Faker::Number.number(10)
      person.dossier_numbers = []
      person.procapita = nil
      person.social_worker = ''
      person.countries = [countries[rand(3)]]
      person.languages = []
      person.deregistered_comment = ''
      person.municipality_placement_comment = ''
      person.other_relateds = ''
      person.secrecy = false
      person.save!
    end
  end

  desc 'Scramble home names'
  task homes: :environment do
    home_names = 1.upto(40).map { Faker::Ancient.titan }
    home_names << 1.upto(40).map { Faker::Ancient.hero }
    home_names << 1.upto(40).map { Faker::Ancient.titan }
    home_names << 1.upto(40).map { Faker::Ancient.primordial }
    home_names << 1.upto(40).map { Faker::Superhero.name }
    home_names << 1.upto(40).map { Faker::Superhero.descriptor }
    home_names << 1.upto(40).map { Faker::Superhero.power }
    home_names << 1.upto(40).map { Faker::TvShows::TwinPeaks.location }
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

  desc 'Scramble placements'
  task placements: :environment do
    Placement.find_each do |placement|
      placement.specification = nil
      placement.save!
    end
  end

  desc 'Run all'
  task all: [:environment, 'scramble:people', 'scramble:homes', 'scramble:placements']
end
