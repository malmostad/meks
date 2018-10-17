RSpec.describe ExtraContributionType, type: :model do
  it 'should be adding one' do
    expect { create(:extra_contribution_type) }.to change(ExtraContributionType, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:extra_contribution_type)).to be_valid
    end

    it 'should require a name' do
      expect(build(:extra_contribution_type, name: nil)).not_to be_valid
    end

    it 'should be valid with a not too long name' do
      expect(build(:extra_contribution_type, name: 'x' * 191)).to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:extra_contribution_type, name: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique name' do
      create(:extra_contribution_type, name: 'Kontaktperson')
      expect(build(:extra_contribution_type, name: 'Kontaktperson')).not_to be_valid
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:extra_contribution_type, name: 'Kontaktperson') }.to change(ExtraContributionType, :count).by(+1)
      expect { ExtraContributionType.where(name: 'Kontaktperson').first.destroy }.to change(ExtraContributionType, :count).by(-1)
    end

    it 'should delete a extra_contribution_type reference for a extra_contribution' do
      extra_contribution_type = create(:extra_contribution_type)
      extra_contribution = create(:extra_contribution, extra_contribution_type: extra_contribution_type)
      expect(extra_contribution.extra_contribution_type).not_to be_blank
      extra_contribution_type.destroy
      extra_contribution.reload
      expect(extra_contribution.extra_contribution_type).to be_blank
    end
  end
end
