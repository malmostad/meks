RSpec.describe Placement, type: :model do
  it 'should be adding one' do
    expect { create(:placement) }.to change(Placement, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:placement)).to be_valid
    end

    it 'should require a home' do
      expect(build(:placement, home: nil)).not_to be_valid
    end

    it 'should require person' do
      expect(build(:placement, person: nil)).not_to be_valid
    end

    it 'should require a moved_in_at' do
      expect(build(:placement, moved_in_at: nil)).not_to be_valid
    end

    it 'should require a legal_code' do
      expect(build(:placement, legal_code: nil)).not_to be_valid
    end

    it 'should have moved_in_at later than moved_out_at' do
      expect(build(:placement, moved_in_at: Date.today, moved_out_at: Date.today - 1.day)).not_to be_valid
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:placement) }.to change(Placement, :count).by(+1)
      expect { Placement.first.destroy }.to change(Placement, :count).by(-1)
    end

    it 'should delete a placement reference for a person' do
      person = create(:person)
      placement = create(:placement, person: person)
      expect(placement.person).not_to be_blank
      person.destroy
      expect(Placement.where(id: placement.id)).to be_blank
    end

    it 'should not delete a person when deleted' do
      person = create(:person)
      placement = create(:placement, person: person)
      expect(placement).not_to be_blank
      placement.destroy
      person.reload
      expect(person).not_to be_blank
    end

    describe 'unit examples' do
      it 'should include a placement within_range' do
        placement = create(:placement, moved_in_at: Date.today)
        placements = Placement.within_range(Date.today - 30.days, Date.today)
        expect(placements).to include(placement)
      end

      it 'should include a placement within_range with a future moved_out_at date' do
        placement = create(:placement, moved_in_at: Date.today, moved_out_at: Date.today + 30.days)
        placements = Placement.within_range(Date.today - 30.days, Date.today)
        expect(placements).to include(placement)
      end

      it 'should not include a placement before the range' do
        placement = create(:placement, moved_in_at: Date.today)
        placements = Placement.within_range(Date.today - 30.days, Date.today - 1.day)
        expect(placements).not_to include(placement)
      end

      it 'should detect overlapping placements for a person' do
        person = create(:person)
        placement1 = create(:placement, moved_in_at: Date.today, person: person)
        placement2 = create(:placement, moved_in_at: Date.yesterday, person: person)
        overlapping = Placement.overlapping_by_person(Date.yesterday, Date.today)
        expect(overlapping).to include(placement1)
        expect(overlapping).to include(placement2)
      end

      it 'should include placement in current placements' do
        placement = create(:placement, moved_in_at: Date.today)
        expect(Placement.current_placements).to include(placement)
      end

      it 'should not include placement in current placements' do
        placement = create(:placement, moved_out_at: Date.today)
        expect(Placement.current_placements).not_to include(placement)
      end

      it 'should include placement in current quarter' do
        placement = create(:placement, moved_in_at: Date.yesterday)
        expect(Placement.current_quarter).to include(placement)
      end

      it 'should not include placement in current quarter' do
        placement = create(:placement, moved_in_at: Date.today + 4.months)
        expect(Placement.current_quarter).to include(placement)
      end

      it 'should return correct placement time' do
        placement = create(:placement, moved_in_at: Date.today - 30.days)
        expect(placement.placement_time).to be 31
      end
    end
  end

  describe 'use_placement_specification' do
    it 'placement not should have specification after home change' do
      home = create(:home, use_placement_specification: true)
      create(:placement, specification: 'foo', home: home)
      home.reload
      expect(home.placements.last.specification).to eq 'foo'

      home.update_attribute(:use_placement_specification, false)
      home.reload
      expect(home.placements.last.specification).to be_nil
    end
  end

  describe 'homes type_of_cost' do
    let(:home_cost_per_day) do
      home = create(:home, type_of_cost: :cost_per_day)
      create(:cost, home: home)
      home.reload
    end

    let(:home_cost_per_placement) do
      home = create(:home, type_of_cost: :cost_per_placement)
      create(:placement, cost: 123, home: home)
      home.reload
    end

    let(:home_cost_for_family_and_emergency_home) do
      home = create(:home, type_of_cost: :cost_for_family_and_emergency_home)
      placement = create(:placement, home: home)
      create(:placement_extra_cost, placement: placement)
      create(:family_and_emergency_home_cost, placement: placement)
      home.reload
    end

    describe 'cost_per_day' do
      it 'should have costs destroyed after changed home to type of cost_per_placement' do
        home = home_cost_per_day
        expect(home.costs).not_to be_empty

        home.update_attribute(:type_of_cost, :cost_per_placement)
        home.reload
        expect(home.costs).to be_empty
      end
    end

    describe 'cost_per_placement' do
      it 'should have costs destroyed after changed home to type of cost_per_day' do
        home = home_cost_per_placement
        expect(home.placements.first.cost).not_to be_nil

        home.update_attribute(:type_of_cost, :cost_per_day)
        home.reload
        expect(home.placements.first.cost).to be_nil
      end
    end

    describe 'cost_for_family_and_emergency_home' do
      it 'should not destroy after changed home to type of cost_per_day' do
        home = home_cost_for_family_and_emergency_home
        expect(home.placements.first.placement_extra_costs).not_to be_empty

        home.update_attribute(:type_of_cost, :cost_per_day)
        home.reload
        expect(home.placements.first.placement_extra_costs).not_to be_empty
      end

      it 'should destroy after changed home to type of cost_per_day' do
        home = home_cost_for_family_and_emergency_home
        expect(home.placements.first.family_and_emergency_home_costs).not_to be_empty

        home.update_attribute(:type_of_cost, :cost_per_day)
        home.reload
        expect(home.placements.first.family_and_emergency_home_costs).to be_empty
      end

      it 'should destroy after changed home to type of cost_per_placement' do
        home = home_cost_for_family_and_emergency_home
        expect(home.placements.first.family_and_emergency_home_costs).not_to be_empty

        home.update_attribute(:type_of_cost, :cost_per_placement)
        home.reload
        expect(home.placements.first.family_and_emergency_home_costs).to be_empty
      end
    end
  end
end
