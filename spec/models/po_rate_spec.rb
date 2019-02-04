RSpec.describe PoRate, type: :model do
  it 'should be adding one' do
    expect { create(:po_rate) }.to change(PoRate, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:po_rate)).to be_valid
    end

    it 'should require a name' do
      expect(build(:po_rate, rate_between_65_and_81: nil)).not_to be_valid
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:po_rate, start_date: '2019-01-01') }.to change(PoRate, :count).by(+1)
      expect { PoRate.where(start_date: '2019-01-01').first.destroy }.to change(PoRate, :count).by(-1)
    end
  end
end
