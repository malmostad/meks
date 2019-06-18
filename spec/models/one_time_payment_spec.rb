RSpec.describe OneTimePayment, type: :model do
  it 'should be adding one' do
    expect { create(:one_time_payment) }.to change(OneTimePayment, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:one_time_payment)).to be_valid
    end

    it 'should require an amount' do
      expect(build(:one_time_payment, amount: nil)).not_to be_valid
    end

    it 'should require a start_date' do
      expect(build(:one_time_payment, start_date: nil)).not_to be_valid
    end

    it 'should require an end_date' do
      expect(build(:one_time_payment, end_date: nil)).not_to be_valid
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:one_time_payment, start_date: '2019-01-01') }.to change(OneTimePayment, :count).by(+1)
      expect { OneTimePayment.where(start_date: '2019-01-01').first.destroy }.to change(OneTimePayment, :count).by(-1)
    end
  end
end
