DIRECTORY = Rails.env.development? ? '/home/vagrant/importer/' : '/home/app_runner/importer/'

# Import data from exported CSV files from Excel
namespace :import do
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
        puts "Rad #{row_number + 1}: #{e}"
        raise 'Importen avbröts. Ingen data sparades.'
      end
    end

    puts "#{refugees} barn importerades"
  end

  desc 'Import placements'
  task placements: :environment do |task|
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
