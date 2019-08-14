RSpec.describe Cost, type: :model do
  let(:cost) { create(:cost) }

  describe 'create' do
    it 'should be adding one' do
      expect { create(:cost) }.to change(Cost, :count).by(+1)
    end
  end

  describe 'validation' do
    it 'should be valid' do
      expect(cost).to be_valid
    end

    it 'should require a cost' do
      expect(build(:cost, amount: nil)).not_to be_valid
    end

    it 'should require a start date' do
      expect(build(:cost, start_date: nil)).not_to be_valid
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:cost) }.to change(Cost, :count).by(+1)
      expect { Cost.last.destroy }.to change(Cost, :count).by(-1)
    end

    it 'should delete a cost reference for a home' do
      home = cost.home
      expect(home).to be_present
      cost.destroy
      home.reload
      expect(home.costs).not_to be_present
    end
  end
end
