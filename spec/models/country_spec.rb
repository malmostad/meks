require 'rails_helper'

RSpec.describe Country, type: :model do
  it "should be adding one" do
    expect { create(:country) }.to change(Country, :count).by(+1)
  end

  describe 'validation' do
    it "should be valid" do
      expect(build(:country)).to be_valid
    end

    it "should require a name" do
      expect(build(:country, name: nil)).not_to be_valid
    end

    it "should be valid with a not too long name" do
      expect(build(:country, name: "x" * 191)).to be_valid
    end

    it "should not have a too long name" do
      expect(build(:country, name: "x" * 192)).not_to be_valid
    end

    it "should have a unique name" do
      create(:country, name: "Sverige")
      expect(build(:country, name: "Sverige")).not_to be_valid
    end

    it "... just checking transactional support" do
      expect(Country.count).to eq 0
    end
  end

  describe 'destroy' do
    it "should destroy a record" do
      expect { create(:country, name: "Sverige") }.to change(Country, :count).by(+1)
      expect { Country.where(name: "Sverige").first.destroy }.to change(Country, :count).by(-1)
    end

    it "should delete a country reference for a refugee" do
      country = create(:country)
      refugee = create(:refugee, countries: [country])
      expect(refugee.countries).to be_present
      country.destroy
      refugee.reload
      expect(refugee.countries).to be_empty
    end

    it "should delete a citizenship reference from a refugee" do
      country = create(:country)
      refugee = create(:refugee, citizenship: country)
      expect(refugee.citizenship).to be_present
      expect(refugee.citizenship_id).to be_present
      country.destroy
      refugee.reload
      expect(refugee.citizenship).not_to be_present
      expect(refugee.citizenship_id).not_to be_present
    end
  end
end
