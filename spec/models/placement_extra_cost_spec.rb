RSpec.describe PlacementExtraCost, type: :model do
  it 'should be adding one' do
    expect { create(:placement_extra_cost) }.to change(PlacementExtraCost, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:placement_extra_cost)).to be_valid
    end

    it 'should require a date' do
      expect(build(:placement_extra_cost, date: nil)).not_to be_valid
    end

    it 'should require an amount' do
      expect(build(:placement_extra_cost, amount: nil)).not_to be_valid
    end

    it 'should require amount to be numericality' do
      expect(build(:placement_extra_cost, amount: 'foo')).not_to be_valid
    end

    it 'should limit comment length' do
      expect(build(:placement_extra_cost, comment: 'x' * 200)).not_to be_valid
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:placement_extra_cost) }.to change(PlacementExtraCost, :count).by(+1)
      expect { PlacementExtraCost.first.destroy }.to change(PlacementExtraCost, :count).by(-1)
    end

    it 'should delete the placement_extra_cost reference for a placement' do
      home = create(:home, type_of_cost: :cost_for_family_and_emergency_home)
      placement = create(:placement, home: home)
      placement_extra_cost = create(:placement_extra_cost, placement: placement)
      expect(placement_extra_cost.placement).not_to be_blank
      placement.reload
      placement.destroy
      expect(PlacementExtraCost.where(id: placement_extra_cost.id)).to be_blank
    end

    it 'should not delete a placement when deleted' do
      placement = create(:placement)
      placement_extra_cost = create(:placement_extra_cost, placement: placement)
      expect(placement_extra_cost).not_to be_blank
      placement_extra_cost.destroy
      placement.reload
      expect(placement).not_to be_blank
    end
  end
end
