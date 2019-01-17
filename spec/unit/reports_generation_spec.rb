# Generate empty reports
# Load a seed/fixture file for more realistic scenarios
RSpec.feature 'Reports generation' do
  scenario 'generate an Economy report' do
    filename = "#{Time.now.to_f}_spec.xlsx"
    Report::Economy.new(filename: filename, from: Date.today - 2.years, to: Date.today).create!
    expect(read_report(filename)[0..1]).to eq 'PK'
  end

  scenario 'generate a Homes report' do
    filename = "#{Time.now.to_f}_spec.xlsx"
    Report::Homes.new(filename: filename, from: Date.today - 2.years, to: Date.today).create!
    expect(read_report(filename)[0..1]).to eq 'PK'
  end

  scenario 'generate a Placements report' do
    filename = "#{Time.now.to_f}_spec.xlsx"
    Report::Placements.new(filename: filename, from: Date.today - 2.years, to: Date.today).create!
    expect(read_report(filename)[0..1]).to eq 'PK'
  end

  scenario 'generate a Refugees report' do
    filename = "#{Time.now.to_f}_spec.xlsx"
    Report::Refugees.new(filename: filename, from: Date.today - 2.years, to: Date.today).create!
    expect(read_report(filename)[0..1]).to eq 'PK'
  end
end
