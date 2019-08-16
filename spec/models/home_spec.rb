RSpec.describe Home, type: :model do
  it 'should be adding one' do
    expect { create(:home) }.to change(Home, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:home)).to be_valid
    end

    it 'should require a name' do
      expect(build(:home, name: nil)).not_to be_valid
    end

    it 'should be valid with a not too long name' do
      expect(build(:home, name: 'x' * 191)).to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:home, name: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique name' do
      create(:home, name: 'home')
      expect(build(:home, name: 'home')).not_to be_valid
    end

    it '... just checking transactional support' do
      expect(Home.count).to eq 0
    end
  end

  describe 'associations' do
    let(:home) { create(:home) }

    it 'should have a languages' do
      expect(home.languages).to be_present
    end

    it 'should have target_groups' do
      expect(home.target_groups).to be_present
    end

    it 'should have type_of_housings' do
      expect(home.type_of_housings).to be_present
    end

    it 'should have owner_type' do
      expect(home.owner_type).to be_present
    end

    it 'should still be there if the languages is destroyed' do
      languages = home.languages
      expect(home.languages).to be_present
      languages.each { |lang| lang.destroy }
      home.reload
      expect(home.languages).not_to be_present
      expect(home).to be_present
    end

    it 'should still be there if the type_of_housings are destroyed' do
      type_of_housings = home.type_of_housings
      expect(home.type_of_housings).to be_present
      type_of_housings.each { |toh| toh.destroy }
      home.reload
      expect(home.type_of_housings).not_to be_present
      expect(home).to be_present
    end

    it 'should still be there if the target_groups are destroyed' do
      target_groups = home.target_groups
      expect(home.target_groups).to be_present
      target_groups.each { |tg| tg.destroy }
      home.reload
      expect(home.target_groups).not_to be_present
      expect(home).to be_present
    end

    it 'should still be there if the owner_types are destroyed' do
      owner_type = home.owner_type
      expect(home.owner_type).to be_present
      owner_type.destroy
      home.reload
      expect(home.owner_type).not_to be_present
      expect(home).to be_present
    end
  end

  describe 'placements' do
    let(:home) { create(:home) }

    before(:each) {
      home.placements << create(:placement, home: home)
    }

    it 'should have a placement' do
      expect(home.placements).to be_present
    end

    it 'should have a current_placements' do
      expect(home.current_placements.size).to eq(1)
    end

    it 'should have a moved in date' do
      expect(home.placements.first.moved_in_at).to be_a(Date)
    end

    it 'home placement should have specification' do
      home2 = create(:home, use_placement_specification: true)
      home2.placements << create(:placement, specification: 'foo', home: home2)

      expect(home2.placements.last.specification).to eq 'foo'
    end

    it 'home placement should not have specification after home change' do
      home2 = create(:home, use_placement_specification: true)
      home2.placements << create(:placement, specification: 'foo', home: home2)
      expect(home2.placements.last.specification).not_to eq nil

      home2.update_attribute(:use_placement_specification, false)
      expect(home2.placements.last.specification).to eq nil
    end

    it 'should not have a placement after the home is deleted' do
      person = home.placements.first.person
      person.destroy
      home.reload
      expect(home.placements).not_to be_present
    end

    it 'the placement should not persist if the home is deleted' do
      person = home.placements.first.person
      home.destroy
      person.reload
      expect(person.placements).not_to be_present
      expect(person.current_placements).not_to be_present
    end

    it 'the home should not have any placements if the placement is deleted' do
      placement = home.placements.first
      placement.destroy
      home.reload
      expect(home.placements).not_to be_present
    end

    it 'the home should not have any people if the placement is deleted' do
      expect(home.people).to be_present
      home.placements.each(&:destroy)
      home.reload
      expect(home.people).not_to be_present
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:home, name: 'Home name') }.to change(Home, :count).by(+1)
      expect { Home.where(name: 'Home name').first.destroy }.to change(Home, :count).by(-1)
    end
  end

  describe 'calcution' do
    it 'should get number of seats right' do
      home = create(:home, guaranteed_seats: 9, movable_seats: 7)
      expect(home.seats).to eq(16)
    end
  end

  describe 'type_of_cost' do
    describe ' cost_per_day' do
      it 'should have costs destroyed after changed to cost_per_placement' do
        home = create(:home, type_of_cost: :cost_per_day)
        create(:cost, home: home)
        home.reload
        expect(home.costs).not_to be_empty

        home.update_attribute(:type_of_cost, :cost_per_placement)
        home.reload
        expect(home.costs).to be_empty
      end

      it 'should not have costs destroyed after other attribute change' do
        home = create(:home, type_of_cost: :cost_per_day)
        create(:cost, home: home)
        home.reload
        expect(home.costs).not_to be_empty

        home.update_attribute(:name, 'Foo')
        home.reload
        expect(home.costs).not_to be_empty
      end

      it 'should have costs destroyed after changed to cost_for_family_and_emergency_home' do
        home = create(:home, type_of_cost: :cost_per_day)
        create(:cost, home: home)
        home.reload
        expect(home.costs).not_to be_empty

        home.update_attribute(:type_of_cost, :cost_for_family_and_emergency_home)
        home.reload
        expect(home.costs).to be_empty
      end

      it 'should allow costs after changed to cost_per_day' do
        home = create(:home, type_of_cost: :cost_for_family_and_emergency_home)

        home.update_attribute(:type_of_cost, :cost_per_day)
        create(:cost, home: home)
        home.reload
        expect(home.costs).not_to be_empty
      end
    end

    describe 'cost_per_placement' do
      it 'should have home costs destroyed after changed to cost_per_placement' do
        home = create(:home, type_of_cost: :cost_per_placement)
        create(:placement, home: home, cost: 123)
        home.reload
        expect(home.placements.first.cost).not_to be_nil

        home.update_attribute(:type_of_cost, :cost_per_day)
        home.reload
        expect(home.placements.first.cost).to be_nil
      end

      it 'should not have home costs destroyed after other attribute change' do
        home = create(:home, type_of_cost: :cost_per_placement)
        create(:placement, home: home, cost: 123)
        home.reload
        expect(home.placements.first.cost).not_to be_nil

        home.update_attribute(:name, 'Foo')
        home.reload
        expect(home.placements.first.cost).not_to be_nil
      end

      it 'should have home costs destroyed after changed to cost_for_family_and_emergency_home' do
        home = create(:home, type_of_cost: :cost_per_placement)
        create(:placement, home: home, cost: 123)
        home.reload
        expect(home.placements.first.cost).not_to be_nil

        home.update_attribute(:type_of_cost, :cost_for_family_and_emergency_home)
        home.placements.first.reload
        expect(home.placements.first.cost).to be_nil
      end

      it 'should allow costs after changed to cost_per_day' do
        home = create(:home, type_of_cost: :cost_per_day)

        home.update_attribute(:type_of_cost, :cost_per_placement)
        home.reload
        create(:placement, home: home, cost: 123)
        home.reload
        expect(home.placements.first.cost).not_to be_nil
      end
    end

    describe 'cost_for_family_and_emergency_home' do
      describe 'placement_extra_costs' do
        it 'should not destroy after changed to cost_per_day' do
          home = create(:home, type_of_cost: :cost_for_family_and_emergency_home)
          placement = create(:placement, home: home)
          create(:placement_extra_cost, placement: placement)
          home.reload
          expect(home.placements.first.placement_extra_costs).not_to be_nil

          home.update_attribute(:type_of_cost, :cost_per_day)
          home.reload
          expect(home.placements.first.placement_extra_costs).not_to be_empty
        end

        it 'should not destroy after other attribute change' do
          home = create(:home, type_of_cost: :cost_for_family_and_emergency_home)
          placement = create(:placement, home: home)
          create(:placement_extra_cost, placement: placement)
          home.reload
          expect(home.placements.first.placement_extra_costs).not_to be_nil

          home.update_attribute(:name, 'Foo')
          home.reload
          expect(home.placements.first.placement_extra_costs).not_to be_empty
        end

        it 'should not destroy after changed to cost_per_placement' do
          home = create(:home, type_of_cost: :cost_for_family_and_emergency_home)
          placement = create(:placement, home: home)
          create(:placement_extra_cost, placement: placement)
          home.reload
          expect(home.placements.first.placement_extra_costs).not_to be_nil

          home.update_attribute(:type_of_cost, :cost_per_placement)
          home.reload
          expect(home.placements.first.placement_extra_costs).not_to be_empty
        end

        it 'should allow after changed to cost_for_family_and_emergency_home' do
          home = create(:home, type_of_cost: :cost_per_day)

          home.update_attribute(:type_of_cost, :cost_for_family_and_emergency_home)
          placement = create(:placement, home: home)
          create(:placement_extra_cost, placement: placement)
          home.reload
          expect(home.placements.first.placement_extra_costs).not_to be_nil
        end
      end

      describe 'family_and_emergency_home_cost' do
        it 'should destroy after changed to cost_per_day' do
          home = create(:home, type_of_cost: :cost_for_family_and_emergency_home)
          placement = create(:placement, home: home)
          create(:family_and_emergency_home_cost, placement: placement)
          home.reload
          expect(home.placements.first.family_and_emergency_home_costs).not_to be_nil

          home.update_attribute(:type_of_cost, :cost_per_day)
          home.reload
          expect(home.placements.first.family_and_emergency_home_costs).to be_empty
        end

        it 'should not destroy after other attribute change' do
          home = create(:home, type_of_cost: :cost_for_family_and_emergency_home)
          placement = create(:placement, home: home)
          create(:family_and_emergency_home_cost, placement: placement)
          home.reload
          expect(home.placements.first.family_and_emergency_home_costs).not_to be_empty

          home.update_attribute(:name, 'Foo')
          home.reload
          expect(home.placements.first.family_and_emergency_home_costs).not_to be_empty
        end

        it 'should destroy after changed to cost_per_placement' do
          home = create(:home, type_of_cost: :cost_for_family_and_emergency_home)
          placement = create(:placement, home: home)
          create(:family_and_emergency_home_cost, placement: placement)
          home.reload
          expect(home.placements.first.family_and_emergency_home_costs).not_to be_empty

          home.update_attribute(:type_of_cost, :cost_per_placement)
          home.reload
          expect(home.placements.first.family_and_emergency_home_costs).to be_empty
        end

        it 'should allow after changed to cost_for_family_and_emergency_home' do
          home = create(:home, type_of_cost: :cost_per_day)

          home.update_attribute(:type_of_cost, :cost_for_family_and_emergency_home)
          placement = create(:placement, home: home)
          create(:family_and_emergency_home_cost, placement: placement)
          home.reload
          expect(home.placements.first.family_and_emergency_home_costs).not_to be_empty
        end
      end
    end
  end
end
