DIRECTORY = Rails.env.development? ? '/home/vagrant/importer/' : '/home/app_runner/importer/'

# Import data from exported CSV files from Excel.
namespace :import do
  # The sheet "Individdata" exported to "refugees.csv", has two heading rows and the following columns:
  # 0  Namn: name
  # 1  Personnummer: split into date_of_birth and ssn_extension
  # 2  Extra personnummer: create one Ssn
  # 3  Kommentar till extra personnummer: ignored
  # 4  Dossiernummer: dossier_number
  # 5  Kön: name of a Gender
  # 6  Nationalitet: name of a Country
  # 7  Ankomst Malmö: arrival
  # 8  Inledningsdatum: registered
  # 9  Socialtjänstområde: name of a Municipality
  # 10 Socialsekreterare: social_worker
  # 11 Anvisningsdatum: checked_out_to_our_city
  # 12 PUT: residence_permit_at
  # 13 Kommunplaceringsdatum: municipality_placement_migrationsverket_at
  # 14 TUT startar: temporary_permit_starts_at
  # 15 TUT slutar: temporary_permit_ends_at
  # 16 Medborgarskap erhölls citizenship_at
  desc 'Import refugees'
  task refugees: :environment do
    records = parse_file('refugees.csv')
    refugees = 0

    ActiveRecord::Base.transaction do
      records.each_with_index do |record, row_number|
        next if row_number < 2

        Refugee.create!(
          name: record[0],
          date_of_birth: record[1][0..9],
          ssn_extension: record[1][11..14],
          ssns: [(Ssn.new(date_of_birth: record[2][0..9], extension: record[2][11..14]) if record[2].present?)].compact,
          dossier_number: record[4],
          gender: Gender.where(name: record[5]).first,
          countries: Country.where(name: record[6]),
          arrival: (true if record[7] == 'Ja'),
          registered: record[8],
          municipality: Municipality.where(name: record[9]).first,
          social_worker: record[10],
          checked_out_to_our_city: record[11],
          residence_permit_at: record[12],
          municipality_placement_migrationsverket_at: record[13],
          temporary_permit_starts_at: record[14],
          temporary_permit_ends_at: record[15],
          citizenship_at: record[16],
          imported_at: Time.now
        )

        refugees += 1

      rescue ActiveRecord::RecordInvalid => e
        puts "Rad #{row_number + 1} i csv-filen: #{e}"
        raise 'Importen avbröts. Ingen data sparades.'
      end
    end

    puts "#{refugees} barn importerades"
  end

  # The sheet "Placeringar" exported to "placements.csv", has two heading rows and the following columns:
  # 0  Dossiernummer: dossier_number of a Refugee
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
    records = parse_file('placements.csv')
    placements = 0

    ActiveRecord::Base.transaction do
      records.each_with_index do |record, row_number|
        next if row_number < 2

        placement = Placement.create!(
          refugee: Refugee.where(dossier_number: record[0]).first,
          home: Home.where(name: record[1]).first,
          moved_in_at: record[2],
          moved_out_at: record[3],
          moved_out_reason: MovedOutReason.where(name: record[4]).first,
          specification: record[5],
          legal_code: LegalCode.where(name: record[6]).first,
          cost: record[7]
        )

        if record[8].present?
          placement.family_and_emergency_home_costs << FamilyAndEmergencyHomeCost.create!(
            period_start: record[8],
            period_end: record[9],
            fee: record[10],
            expense: record[11],
            contractor_name: record[12],
            contractor_birthday: record[13],
            contactor_employee_number: record[14]
          )
          placement.save!
        end

        placements += 1

      rescue ActiveRecord::RecordInvalid => e
        puts "Rad #{row_number + 1} i csv-filen: #{e}"
        raise 'Importen avbröts. Ingen data sparades.'
      end
    end

    puts "#{placements} placeringar importerades"
  end

  desc 'Import outpatient contributions'
  task outpatient_contributions: :environment do |task|
  end

  desc 'Import extra contributions'
  task extra_contributions: :environment do |task|
  end
end

# Basic parsing of the uploaded file
def parse_file(filename)
  contents = File.open(File.join(DIRECTORY, filename), 'r:bom|utf-8') { |f| f.read.gsub(/\r\n*/, "\n") }
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

def refugee_by_dossier_number(str, row_number)
  dossier_number = str.gsub(/\D/, '')
  Refugee.where(dossier_number: dossier_number).first
end

# Assumes the format YYYYMMDD and other characters like spaces and hyphens that will be removed
def parse_date(str, row_number)
  date = str.gsub(/\D/, '')
  begin
    date.to_date
  rescue
    parsing_error "Datumet #{str} har inte korrekt format (ÅÅÅÅ-MM-DD) [rad #{row_number}]"
    return
  end
end

def parse_amount(str, row_number)
  # Cleanup
  amount = str.gsub(/[^\d\-+,\.]/, '')
  # Change from Swedish to US float
  amount.gsub!(/,/, '.')
  unless amount.match(/\A[+-]?[\d\.]+\z/)
    parsing_error "Beloppet #{str} kunde inte tolkas [rad #{row_number}]"
    return
  end
  amount.to_f
end

def parsing_error(msg)
  @parsing_errors ||= []
  @parsing_errors << msg
end
