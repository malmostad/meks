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

    it 'should require refugee' do
      expect(build(:placement, refugee: nil)).not_to be_valid
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

    it 'should delete a placement reference for a refugee' do
      refugee = create(:refugee)
      placement = create(:placement, refugee: refugee)
      expect(placement.refugee).not_to be_blank
      refugee.destroy
      expect(Placement.where(id: placement.id)).to be_blank
    end

    it 'should not delete a refugee when deleted' do
      refugee = create(:refugee)
      placement = create(:placement, refugee: refugee)
      expect(placement).not_to be_blank
      placement.destroy
      refugee.reload
      expect(refugee).not_to be_blank
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

      it 'should detect overlapping placements for a refugee' do
        refugee = create(:refugee)
        placement1 = create(:placement, moved_in_at: Date.today, refugee: refugee)
        placement2 = create(:placement, moved_in_at: Date.yesterday, refugee: refugee)
        overlapping = Placement.overlapping_by_refugee(Date.yesterday, Date.today)
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
end
