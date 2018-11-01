RSpec.describe FamilyAndEmergencyHomeCost, type: :model do
  it 'should be adding one' do
    expect { create(:family_and_emergency_home_cost) }.to change(FamilyAndEmergencyHomeCost, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:family_and_emergency_home_cost)).to be_valid
    end

    it 'should require a period_start date' do
      expect(build(:family_and_emergency_home_cost, period_start: nil)).not_to be_valid
    end

    it 'should require a period_end date' do
      expect(build(:family_and_emergency_home_cost, period_end: nil)).not_to be_valid
    end

    it 'should require expense to be a number' do
      expect(build(:family_and_emergency_home_cost, expense: 'abc')).not_to be_valid
    end

    it 'should require fee to be a number' do
      expect(build(:family_and_emergency_home_cost, fee: 'abc')).not_to be_valid
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:family_and_emergency_home_cost) }.to change(FamilyAndEmergencyHomeCost, :count).by(+1)
      expect { FamilyAndEmergencyHomeCost.first.destroy }.to change(FamilyAndEmergencyHomeCost, :count).by(-1)
    end

    it 'should delete the family_and_emergency_home_cost reference for a placement' do
      home = create(:home, type_of_cost: :cost_for_family_and_emergency_home)
      placement = create(:placement, home: home)
      family_and_emergency_home_cost = create(:family_and_emergency_home_cost, placement: placement)
      expect(family_and_emergency_home_cost.placement).not_to be_blank
      placement.reload
      placement.destroy
      expect(FamilyAndEmergencyHomeCost.where(id: family_and_emergency_home_cost.id)).to be_blank
    end

    it 'should not delete a placement when deleted' do
      placement = create(:placement)
      family_and_emergency_home_cost = create(:family_and_emergency_home_cost, placement: placement)
      expect(family_and_emergency_home_cost).not_to be_blank
      family_and_emergency_home_cost.destroy
      placement.reload
      expect(placement).not_to be_blank
    end
  end
end
