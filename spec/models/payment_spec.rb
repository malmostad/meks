require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:payment) { create(:payment) }

  describe 'create' do
    it 'should be adding one' do
      expect { create(:payment) }.to change(Payment, :count).by(+1)
    end
  end
end
