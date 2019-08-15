# Import data from exported CSV files from Excel.
namespace :import do
  BASE_DIR = (Rails.env.development? ? '/home/vagrant/importer/' : '/home/app_runner/importer/').freeze

  # Place the following exported spreadsheet files for *new* people here:
  # people.csv placements.csv outpatient_contributions.csv extra_contributions.csv
  # Run the create tasks in chain with:
  # $ rake import:create_people_tasks
  CREATE_PEOPLE_DIR = File.join(BASE_DIR, 'create').freeze

  # Place the following exported spreadsheet files for *existing* people here:
  # people.csv placements.csv outpatient_contributions.csv extra_contributions.csv
  # Run the update tasks in chain with:
  # $ rake import:update_people_tasks
  UPDATE_PEOPLE_DIR = File.join(BASE_DIR, 'update').freeze

  # The sheet "Individdata" exported to "people.csv"
  #   has two heading rows and the following columns:
  # 0  Dossiernummer: dossier_number
  # 1  Kundnummer: procapita
  # 2  Namn: name
  # 3  Personnummer: split into date_of_birth and ssn_extension
  # 4  Extra personnummer: create one Ssn
  # 5  Kommentar till extra personnummer: name of a DeregisteredReason
  # 6  Kön: name of a Gender
  # 7  Nationalitet: name of a Country
  # 8  Ankomst Malmö: arrival
  # 9  Inledningsdatum: registered
  # 10 Socialtjänstområde: name of a Municipality
  # 11 Socialsekreterare: social_worker
  # 12 Anvisningsdatum: municipality_placement_migrationsverket_at
  # 13 PUT: residence_permit_at
  # 14 Kommunplaceringsdatum: checked_out_to_our_city
  # 15 TUT startar: temporary_permit_starts_at
  # 16 TUT slutar: temporary_permit_ends_at
  # 17 Medborgarskap erhölls citizenship_at
  desc 'Import people'
  task people: :environment do
    filename = 'people.csv'
    records = parse_file(filename)
    people = 0

    ActiveRecord::Base.transaction do
      records.each_with_index do |record, row_number|
        next if row_number < 2

        Person.create!(
          dossier_number: record[0],
          procapita: record[1],
          name: record[2],
          date_of_birth: record[3][0..9],
          ssn_extension: record[3][11..14],
          ssns: [(Ssn.new(date_of_birth: record[4][0..9], extension: record[4][11..14]) if record[4].present?)].compact,
          deregistered_reason: DeregisteredReason.where(name: record[5]).first,
          gender: Gender.where(name: record[6]).first,
          countries: Country.where(name: record[7]),
          arrival: (true if record[8] == 'Ja'),
          registered: record[9],
          municipality: Municipality.where(name: record[10]).first,
          social_worker: record[11],
          municipality_placement_migrationsverket_at: record[12],
          residence_permit_at: record[13],
          checked_out_to_our_city: record[14],
          temporary_permit_starts_at: record[15],
          temporary_permit_ends_at: record[16],
          citizenship_at: record[17],
          imported_at: Time.now
        )

        people += 1

      rescue ActiveRecord::RecordInvalid => e
        puts "Rad #{row_number + 1} i #{filename}: #{e}"
        raise 'Importen avbröts. Ingen data sparades.'
      end
    end

    puts "#{people} personer importerades"
  end

  # The sheet "Placeringar" exported to "placements.csv"
  #   has two heading rows and the following columns:
  # 0  Dossiernummer: dossier_number of a Person
  # 1  Boende: name of a Home
  # 2  Placeringsdatum: moved_in_at
  # 3  Utskrivningsdatum: moved_out_at
  # 4  Anledning till utskrivning: name of a MovedOutReason
  # 5  Placeringsspecifikation: specification
  # 6  Lagrum för placeringen: name of a LegalCode
  # 7  Placeringskostnad: cost
  # 8  Avtal familje-/-jour/nätverkshem utrett: FamilyAndEmergencyHomeCost.period_start
  # 9  Slutdatum Avtal: FamilyAndEmergencyHomeCost.period_end
  # 10 Arvode: FamilyAndEmergencyHomeCost.fee
  # 11 Omkostnad: FamilyAndEmergencyHomeCost.expense
  # 12 Uppdragstagare: FamilyAndEmergencyHomeCost.contractor_name
  # 13 Födelsedata: FamilyAndEmergencyHomeCost.contractor_birthday
  # 14 Anställningsnummer: FamilyAndEmergencyHomeCost.contactor_employee_number
  desc 'Import placements'
  task placements: :environment do |task|
    filename = 'placements.csv'
    records = parse_file(filename)
    placements = 0

    ActiveRecord::Base.transaction do
      records.each_with_index do |record, row_number|
        next if row_number < 2

        placement = Placement.create!(
          person: Person.where(dossier_number: record[0]).first,
          home: Home.where(name: record[1]).first,
          moved_in_at: record[2],
          moved_out_at: record[3],
          moved_out_reason: MovedOutReason.where(name: record[4]).first,
          specification: record[5],
          legal_code: LegalCode.where(name: record[6]).first,
          cost: record[7],
          imported_at: Time.now
        )

        if record[8].present?
          placement.family_and_emergency_home_costs << FamilyAndEmergencyHomeCost.create!(
            period_start: record[8],
            period_end: record[9],
            fee: record[10].sub(',', '.'),
            expense: record[11].sub(',', '.'),
            contractor_name: record[12],
            contractor_birthday: record[13],
            contactor_employee_number: record[14]
          )
          placement.save!
        end

        placements += 1

      rescue ActiveRecord::RecordInvalid => e
        puts "Rad #{row_number + 1} i #{filename}: #{e}"
        raise 'Importen avbröts. Ingen data sparades.'
      end
    end

    puts "#{placements} placeringar importerades"
  end

  # The sheet "Öppenvårdsinsatser" exported to "outpatient_contributions.csv"
  #   has two heading rows and the following columns:
  #
  # 0 Dossiernummer: dossier_number of a Person
  # 1 Startdatum: period_start
  # 2 Slutdatum: period_end
  # 3 Månadskostnad: monthly_cost
  # 4 Kommentar: comment
  #
  #  The task creates ExtraContribution objects of the outpatient type.
  desc 'Import outpatient contributions'
  task outpatient_contributions: :environment do
    filename = 'outpatient_contributions.csv'
    records = parse_file(filename)
    extra_contributions = 0

    ActiveRecord::Base.transaction do
      records.each_with_index do |record, row_number|
        next if row_number < 2

        ExtraContribution.create!(
          person: Person.where(dossier_number: record[0]).first,
          extra_contribution_type: ExtraContributionType.where(outpatient: true).first,
          period_start: record[1],
          period_end: record[2],
          monthly_cost: record[3].sub(',', '.'),
          comment: record[4],
          imported_at: Time.now
        )

        extra_contributions += 1

      rescue ActiveRecord::RecordInvalid => e
        puts "Rad #{row_number + 1} i #{filename}: #{e}"
        raise 'Importen avbröts. Ingen data sparades.'
      end
    end

    puts "#{extra_contributions} öppenvårdsinsatser importerades"
  end

  # The sheet "Övriga insatser" exported to "extra_contributions.csv"
  #   has two heading rows and the following columns:
  #
  # 0 Dossiernummer: dossier_number of a Person
  # 1 Insatsform: name of an ExtraContributionType
  # 2 Startdatum: period_start
  # 3 Slutdatum: period_end
  # 4 Arvode: fee
  # 5 Omkostnad: expense
  # 6 Uppdragstagare: contractor_name
  # 7 Födelsedata: contractor_birthday
  # 8 Anställningsnummer: contactor_employee_number
  desc 'Import extra contributions'
  task extra_contributions: :environment do
    filename = 'extra_contributions.csv'
    records = parse_file(filename)
    extra_contributions = 0

    ActiveRecord::Base.transaction do
      records.each_with_index do |record, row_number|
        next if row_number < 2

        ExtraContribution.create!(
          person: Person.where(dossier_number: record[0]).first,
          extra_contribution_type: ExtraContributionType.where(name: record[1]).first,
          period_start: record[2],
          period_end: record[3],
          fee: record[4].sub(',', '.'),
          expense: record[5].sub(',', '.'),
          contractor_name: record[6],
          contractor_birthday: record[7],
          contactor_employee_number: record[8],
          imported_at: Time.now
        )

        extra_contributions += 1

      rescue ActiveRecord::RecordInvalid => e
        puts "Rad #{row_number + 1} i #{filename}: #{e}"
        raise 'Importen avbröts. Ingen data sparades.'
      end
    end

    puts "#{extra_contributions} övriga insatser importerades"
  end

  # The sheet "Individdata" in the file with people that exitst in MEKS exported to "people.csv"
  #   has two heading rows and the following columns:
  #
  # 0 Dossiernummer: dossier_number of a Person
  # 1 Kundnummer: procapita
  desc 'Update people'
  task update_people: :environment do
    filename = 'people.csv'
    records = parse_file(filename)
    people = 0

    ActiveRecord::Base.transaction do
      records.each_with_index do |record, row_number|
        next if row_number < 2

        person = Person.where(dossier_number: record[0]).first
        raise ActiveRecord::RecordInvalid if person.nil?

        person.procapita = record[1]
        person.save!(validate: false)

        people += 1

      rescue ActiveRecord::RecordInvalid => e
        puts "Rad #{row_number + 1} i #{filename}: #{e}"
        raise 'Importen avbröts. Ingen data sparades.'
      end
    end

    puts "#{people} personer uppdaterades"
  end

  desc 'Create people and import data associated with them'
  task create_people_tasks: :environment do
    @directory = CREATE_PEOPLE_DIR
    ActiveRecord::Base.transaction do
      Rake::Task['import:people'].invoke
      Rake::Task['import:placements'].invoke
      Rake::Task['import:outpatient_contributions'].invoke
      Rake::Task['import:extra_contributions'].invoke
    end
  end

  desc 'Update exitsing people and import data associated with them'
  task update_people_tasks:  :environment do
    @directory = UPDATE_PEOPLE_DIR
    ActiveRecord::Base.transaction do
      Rake::Task[:environment].invoke
      Rake::Task['import:update_people'].invoke
      Rake::Task['import:placements'].invoke
      Rake::Task['import:outpatient_contributions'].invoke
      Rake::Task['import:extra_contributions'].invoke
    end
  end
end

# Basic parsing of the uploaded file
def parse_file(filename)
  contents = File.open(File.join(@directory, filename), 'r:bom|utf-8') { |f| f.read.gsub(/\r\n*/, "\n") }
  rows = contents.split(/\n/)
  extract_fields(rows)
end

def extract_fields(rows)
  rows.map do |row|
    # Remove quotes around row
    row.strip.gsub!(/^"|"$/, '')

    # Split row into fields separated with semicolon or tab
    fields = row.split(/\s*[;\t]\s*/)

    # All fields are blank, ignore
    next if fields.empty?

    fields
  end.compact
end
