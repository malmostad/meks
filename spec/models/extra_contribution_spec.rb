RSpec.describe ExtraContribution, type: :model do
  it 'should be adding one' do
    expect { create(:extra_contribution) }.to change(ExtraContribution, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:extra_contribution)).to be_valid
    end

    it 'should require a period_start' do
      expect(build(:extra_contribution, period_start: nil)).not_to be_valid
    end

    it 'should require a period_end' do
      expect(build(:extra_contribution, period_end: nil)).not_to be_valid
    end

    it 'should require a extra_contribution_type' do
      expect(build(:extra_contribution, extra_contribution_type: nil)).not_to be_valid
    end

    it 'should require a refugee' do
      expect(build(:extra_contribution, refugee: nil)).not_to be_valid
    end

    it 'should require fee to be numericality' do
      expect(build(:extra_contribution, fee: 'foo')).not_to be_valid
    end

    it 'should require amount to be numericality' do
      expect(build(:extra_contribution, expense: 'foo')).not_to be_valid
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:extra_contribution) }.to change(ExtraContribution, :count).by(+1)
      expect { ExtraContribution.first.destroy }.to change(ExtraContribution, :count).by(-1)
    end

    it 'should delete a extra_contribution reference for a refugee' do
      refugee = create(:refugee)
      extra_contribution = create(:extra_contribution, refugee: refugee)
      expect(extra_contribution.refugee).not_to be_blank
      refugee.destroy
      expect(ExtraContribution.where(id: extra_contribution.id)).to be_blank
    end

    it 'should not delete a refugee when deleted' do
      refugee = create(:refugee)
      extra_contribution = create(:extra_contribution, refugee: refugee)
      expect(extra_contribution).not_to be_blank
      extra_contribution.destroy
      refugee.reload
      expect(refugee).not_to be_blank
    end
  end
end
