RSpec.describe Payment, type: :model do
  let(:payment) { create(:payment) }

  describe 'create' do
    it 'should be adding one' do
      expect { create(:payment) }.to change(Payment, :count).by(+1)
    end
  end

  describe 'validation' do
    it 'should be valid' do
      expect(payment).to be_valid
    end

    it 'should require a amount' do
      expect(build(:payment, amount_as_string: nil)).not_to be_valid
    end

    it 'period_start should be a Date' do
      expect(payment.period_start).to be_a Date
    end

    it 'period_end should be a Date' do
      expect(payment.period_end).to be_a Date
    end

    it 'period_start should be before period_end' do
      expect(payment.period_start < payment.period_end).to be_truthy
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      create(:payment)
      expect { Payment.last.destroy }.to change(Payment, :count).by(-1)
    end
  end
end
