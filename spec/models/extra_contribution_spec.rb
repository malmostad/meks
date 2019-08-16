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

    it 'should require a person' do
      expect(build(:extra_contribution, person: nil)).not_to be_valid
    end

    it 'should require fee to be numericality' do
      expect(build(:extra_contribution, fee: 'foo')).not_to be_valid
    end

    it 'should require expense to be numericality' do
      expect(build(:extra_contribution, expense: 'foo')).not_to be_valid
    end
  end

  describe 'validation of outpatient type' do
    let(:outpatient_type) { create(:extra_contribution_type, outpatient: true) }
    let(:ecop) { create(:extra_contribution, extra_contribution_type: outpatient_type) }

    it 'should be valid' do
      expect(ecop).to be_valid
    end

    it 'should require a period_start' do
      ecop.period_start = nil
      expect(ecop).not_to be_valid
    end

    it 'should require a period_end' do
      ecop.period_end = nil
      expect(ecop).not_to be_valid
    end

    it 'should require monthly cost to be numericality' do
      ecop.monthly_cost = 'foo'
      expect(ecop).not_to be_valid
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:extra_contribution) }.to change(ExtraContribution, :count).by(+1)
      expect { ExtraContribution.first.destroy }.to change(ExtraContribution, :count).by(-1)
    end

    it 'should delete a extra_contribution reference for a person' do
      person = create(:person)
      extra_contribution = create(:extra_contribution, person: person)
      expect(extra_contribution.person).not_to be_blank
      person.destroy
      expect(ExtraContribution.where(id: extra_contribution.id)).to be_blank
    end

    it 'should not delete a person when deleted' do
      person = create(:person)
      extra_contribution = create(:extra_contribution, person: person)
      expect(extra_contribution).not_to be_blank
      extra_contribution.destroy
      person.reload
      expect(person).not_to be_blank
    end
  end
end
