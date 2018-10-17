RSpec.describe PaymentImport, type: :model do
  let(:payment_import) { create(:payment_import) }

  describe 'create' do
    it 'should be adding one' do
      expect { create(:payment_import) }.to change(PaymentImport, :count).by(+1)
    end
  end

  describe 'validation' do
    it 'should be valid' do
      expect(payment_import).to be_valid
    end

    it 'should have a imported_at' do
      expect(build(:payment_import, user: nil)).not_to be_valid
    end

    it 'imported_at should be a Time' do
      expect(payment_import.imported_at).to be_a Time
    end
  end

  describe 'association' do
    it 'should have a user' do
      expect(payment_import.user).to be_present
    end

    it 'should have a payment' do
      payment_import_with_payment = create(:payment_import_with_payment)
      payment_import_with_payment.reload
      expect(payment_import_with_payment.payments).to be_present
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      create(:payment_import)
      expect { PaymentImport.last.destroy }.to change(PaymentImport, :count).by(-1)
    end

    it 'should delete a payment referenced' do
      payment = create(:payment, payment_import: payment_import)
      expect(payment_import).to be_present
      payment_import.reload
      payment_import.destroy
      expect(PaymentImport.where(id: payment.id)).not_to be_present
    end
  end
end
