RSpec.describe Rate, type: :model do
  let(:rate) { create(:rate) }

  describe 'create' do
    it 'should be adding one' do
      expect { create(:rate) }.to change(Rate, :count).by(+1)
    end
  end

  describe 'validation' do
    it 'should be valid' do
      expect(rate).to be_valid
    end

    it 'should require a amount' do
      expect(build(:rate, amount: nil)).not_to be_valid
    end

    it 'should have a start date earlier than the end date' do
      expect(build(:rate, start_date: '2018-04-01', end_date: '2018-03-01')).not_to be_valid
    end

    it 'start date should be a Date' do
      expect(rate.start_date).to be_a Date
    end

    it 'end date should be a Date' do
      expect(rate.end_date).to be_a Date
    end

    it 'start date must be before end date' do
      expect(rate.start_date < rate.end_date).to be_truthy
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:rate) }.to change(Rate, :count).by(+1)
      expect { Rate.last.destroy }.to change(Rate, :count).by(-1)
    end
  end
end
