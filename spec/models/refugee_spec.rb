require 'rails_helper'

RSpec.describe Refugee, type: :model do
  it "should be adding one" do
    expect { create(:refugee) }.to change(Refugee, :count).by(+1)
  end

  describe 'validation' do
    it "should be valid" do
      expect(build(:refugee)).to be_valid
    end

    it "should require a name" do
      expect(build(:refugee, name: nil)).not_to be_valid
    end

    it "should be valid with a not too long name" do
      expect(build(:refugee, name: "x" * 191)).to be_valid
    end

    it "should not have a too long name" do
      expect(build(:refugee, name: "x" * 192)).not_to be_valid
    end

    it "should have a unique dossier_number" do
      create(:refugee, dossier_number: "1234")
      expect(build(:refugee, dossier_number: "1234")).not_to be_valid
    end

    it "should have valid date_of_birth" do
      expect(build(:refugee, date_of_birth: "2016-01-01")).to be_valid
    end

    it "should not have an invalid date_of_birth" do
      expect(build(:refugee, date_of_birth: "1/1/1")).not_to be_valid
    end

    it "should have validate_date_of_birth" do
      expect(build(:refugee, date_of_birth: "2016-01-01")).to be_valid
    end

    it "... just checking transactional support" do
      expect(Refugee.count(true)).to eq 0
    end
  end

  describe 'associations' do
    let(:refugee) { create(:refugee) }

    it "should have a gender" do
      expect(refugee.gender).to be_present
    end

    it "should know some languages" do
      expect(refugee.languages).to be_present
    end

    it "should come from a country" do
      expect(refugee.countries).to be_present
    end

    it "should be assigned to a municipality" do
      expect(refugee.municipality).to be_present
    end

    it "should still be there if her municipality is destroyed" do
      municipality = refugee.municipality
      expect{ municipality.destroy }.to change(Municipality, :count).by(-1)
      expect(refugee).to be_present
    end

    it "should still be there if her language is destroyed" do
      language = refugee.languages.first
      expect{ language.destroy }.to change(Language, :count).by(-1)
      expect(refugee).to be_present
    end

    it "should still be there if her country is destroyed" do
      country = refugee.countries.first
      expect{ country.destroy }.to change(Country, :count).by(-1)
      expect(refugee).to be_present
    end
  end

  describe 'placements' do
    let(:refugee) { create(:refugee) }

    before(:each) {
      refugee.placements << create(:placement, refugee: refugee)
    }

    it "should have a placement" do
      expect(refugee.placements).to be_present
    end

    it "should have a current_placements" do
      expect(refugee.current_placements.size).to eq(1)
    end

    it "should have a moved in date" do
      expect(refugee.placements.first.moved_in_at).to be_a(Date)
    end

    it "should not have a placement after the home is deleted" do
      home = refugee.placements.first.home
      home.destroy
      refugee.reload
      expect(refugee.placements).not_to be_present
    end

    it "the placement should not persist if the refugee is deleted" do
      home = refugee.placements.first.home
      refugee.destroy
      home.reload
      expect(home.placements).not_to be_present
      expect(home.current_placements).not_to be_present
    end

    it "the refugee should not have any placements if the placement is deleted" do
      placement = refugee.placements.first
      placement.destroy
      refugee.reload
      expect(refugee.placements).not_to be_present
    end
  end

  describe 'destroy' do
    it "should destroy a record" do
      expect { create(:refugee, name: "Refugee name") }.to change(Refugee, :count).by(+1)
      expect { Refugee.where(name: "Refugee name").first.destroy }.to change(Refugee, :count).by(-1)
    end
  end
end
