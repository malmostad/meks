require 'rails_helper'

RSpec.describe PaymentImport, type: :model do
  let(:payment_import) { create(:payment_import) }
  let(:payment_import_with_payment) { create(:payment_import_with_payment) }

  describe 'create' do
    it 'should be adding one' do
      expect { create(:payment_import) }.to change(PaymentImport, :count).by(+1)
    end
  end
end
