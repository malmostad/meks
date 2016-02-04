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
      expect(Refugee.count).to eq 0
    end
  end

  describe 'destroy' do
    it "should destroy a record" do
      expect { create(:refugee, name: "Refugee name") }.to change(Refugee, :count).by(+1)
      expect { Refugee.where(name: "Refugee name").first.destroy }.to change(Refugee, :count).by(-1)
    end
  end
end
