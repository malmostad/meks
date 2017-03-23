require 'rails_helper'

RSpec.describe RateCategory, type: :model do
  let(:rate_category) { create(:rate_category) }

  describe 'create' do
    it "should be adding one" do
      expect { create(:rate_category) }.to change(RateCategory, :count).by(+1)
    end
  end

  describe 'validation' do
    it "should be valid" do
      expect(rate_category).to be_valid
    end

    it "should require a name" do
      expect(build(:rate_category, name: nil)).not_to be_valid
    end

    it "should require a from age" do
      expect(build(:rate_category, from_age: nil)).not_to be_valid
    end

    it "should require a to age" do
      expect(build(:rate_category, to_age: nil)).not_to be_valid
    end

    it "should require a legal code" do
      expect(build(:rate_category, legal_code: nil)).not_to be_valid
    end

    it "from age should be an integer" do
      expect(rate_category.from_age).to be_a Integer
    end

    it "to age should be an integer" do
      expect(rate_category.to_age).to be_a Integer
    end
  end

  describe 'destroy' do
    it "should destroy a record" do
      expect { create(:rate_category) }.to change(RateCategory, :count).by(+1)
      expect { RateCategory.last.destroy }.to change(RateCategory, :count).by(-1)
    end
  end

  it "should delete a rate referenced by a rate category" do
    rate = create(:rate, rate_category: rate_category)
    expect(rate_category).to be_present
    rate_category.reload
    rate_category.destroy
    expect(Rate.where(id: rate.id)).not_to be_present
  end
end
