RSpec.describe 'OneTimePayment calculation' do
  let(:municipality) { create(:municipality, our_municipality: true) }
  let(:one_time_payment) { create(:one_time_payment) }
  let(:interval) { { from: one_time_payment.start_date, to: one_time_payment.end_date } }
  let(:refugee) do
    create(:refugee,
      municipality: municipality,
      municipality_placement_migrationsverket_at: one_time_payment.start_date
    )
  end

  describe 'for other municipality' do
    it 'should not have a one time payment' do
      municipality.our_municipality = false
      expect(Economy::OneTimePayment.new(refugee).sum).to eq(nil)
      expect(Economy::OneTimePayment.new(refugee).as_formula).to eq('')
    end
  end

  describe 'for our municipality' do
    it 'should have a one time payment' do
      otp = ::Economy::OneTimePayment.new(refugee, interval)
      expect(otp.sum).to eq(one_time_payment.amount)
      expect(otp.as_formula).to eq(one_time_payment.amount.to_s)
    end

    it 'should not have a one time payment is before interval' do
      refugee.municipality_placement_migrationsverket_at = one_time_payment.start_date - 1.day

      otp = ::Economy::OneTimePayment.new(refugee, interval)
      expect(otp.sum).to eq(nil)
      expect(otp.as_formula).to eq('')
    end

    it 'should not have a one time payment is after interval' do
      refugee.municipality_placement_migrationsverket_at = one_time_payment.end_date + 1.day

      otp = ::Economy::OneTimePayment.new(refugee, interval)
      expect(otp.sum).to eq(nil)
      expect(otp.as_formula).to eq('')
    end

    it 'should not have a one time payment if transferred' do
      refugee.transferred = true

      otp = ::Economy::OneTimePayment.new(refugee, interval)
      expect(otp.sum).to eq(nil)
      expect(otp.as_formula).to eq('')
    end

    it 'should not have a one time payment if not EKB' do
      refugee.ekb = false

      otp = ::Economy::OneTimePayment.new(refugee, interval)
      expect(otp.sum).to eq(nil)
      expect(otp.as_formula).to eq('')
    end
  end

  describe 'class method all' do
    it 'should return one refugee' do
      refugee.save
      expect(Economy::OneTimePayment.all(interval).count).to eq(1)
    end
  end
end
