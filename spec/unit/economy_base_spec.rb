RSpec.describe Economy::Base do
  it 'should remove overlaps in intervals' do
    intervals = [
      { from: '2018-01-01'.to_date, to: '2018-03-01'.to_date },
      { from: '2018-02-01'.to_date, to: '2018-03-10'.to_date },
      { from: '2018-04-01'.to_date, to: '2018-05-01'.to_date },
      { from: '2018-04-02'.to_date, to: '2018-05-01'.to_date }
    ]
    no_overlaps = Economy::Base.new.send(:remove_overlaps_in_date_intervals, intervals)

    expect(no_overlaps).to eq [
      { from: '2018-01-01'.to_date, to: '2018-03-01'.to_date },
      { from: '2018-03-02'.to_date, to: '2018-03-10'.to_date },
      { from: '2018-04-01'.to_date, to: '2018-05-01'.to_date }
    ]
  end
end
