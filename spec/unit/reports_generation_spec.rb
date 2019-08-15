# Generate empty reports
RSpec.feature 'Reports generation' do
  scenario 'generate an Economy report' do
    filename = "#{Time.now.to_f}_spec.xlsx"
    EconomyReport.new(filename: filename, from: Date.today - 2.years, to: Date.today).generate!
    expect(read_report(filename)[0..1]).to eq 'PK'
  end

  scenario 'generate an Economy uppbokning report' do
    filename = "#{Time.now.to_f}_spec.xlsx"
    EconomyUppbokningReport.new(
      filename: filename, from: Date.today - 2.years, to: Date.today
    ).generate!
    expect(read_report(filename)[0..1]).to eq 'PK'
  end

  scenario 'generate a Homes report' do
    filename = "#{Time.now.to_f}_spec.xlsx"
    HomesReport.new(filename: filename, from: Date.today - 2.years, to: Date.today).generate!
    expect(read_report(filename)[0..1]).to eq 'PK'
  end

  scenario 'generate a Placements report' do
    filename = "#{Time.now.to_f}_spec.xlsx"
    PlacementsReport.new(filename: filename, from: Date.today - 2.years, to: Date.today).generate!
    expect(read_report(filename)[0..1]).to eq 'PK'
  end

  scenario 'generate a People report' do
    filename = "#{Time.now.to_f}_spec.xlsx"
    PeopleReport.new(filename: filename, from: Date.today - 2.years, to: Date.today).generate!
    expect(read_report(filename)[0..1]).to eq 'PK'
  end
end
