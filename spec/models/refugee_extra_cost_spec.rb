RSpec.describe RefugeeExtraCost, type: :model do
  it 'should be adding one' do
    expect { create(:refugee_extra_cost) }.to change(RefugeeExtraCost, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:refugee_extra_cost)).to be_valid
    end

    it 'should require a date' do
      expect(build(:refugee_extra_cost, date: nil)).not_to be_valid
    end

    it 'should require amount to be numericality' do
      expect(build(:refugee_extra_cost, amount: 'foo')).not_to be_valid
    end

    it 'should limit comment to be 191 chars' do
      expect(build(:refugee_extra_cost, comment: 'x' * 200)).not_to be_valid
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:refugee_extra_cost) }.to change(RefugeeExtraCost, :count).by(+1)
      expect { RefugeeExtraCost.first.destroy }.to change(RefugeeExtraCost, :count).by(-1)
    end

    it 'should delete a refugee_extra_cost reference for a refugee' do
      refugee = create(:refugee)
      refugee_extra_cost = create(:refugee_extra_cost, refugee: refugee)
      expect(refugee_extra_cost.refugee).not_to be_blank
      refugee.destroy
      expect(RefugeeExtraCost.where(id: refugee_extra_cost.id)).to be_blank
    end

    it 'should not delete a refugee when deleted' do
      refugee = create(:refugee)
      refugee_extra_cost = create(:refugee_extra_cost, refugee: refugee)
      expect(refugee_extra_cost).not_to be_blank
      refugee_extra_cost.destroy
      refugee.reload
      expect(refugee).not_to be_blank
    end
  end
end
