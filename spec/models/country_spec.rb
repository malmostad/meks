require 'rails_helper'

RSpec.describe Country, type: :model do
  it "should be adding one" do
    expect { Country.create(name: "Sverige") }.to change(Country, :count).by(+1)
  end

  describe 'validation' do
    it "should be valid" do
      expect(Country.create(name: "Sverige")).to be_valid
    end

    it "should require a name" do
      expect(Country.new).not_to be_valid
    end

    it "should be valid with a not too long name" do
      expect(Country.new name: "x" * 191).to be_valid
    end

    it "should not have a too long name" do
      expect(Country.new name: "x" * 192).not_to be_valid
    end

    it "should have a unique name" do
      Country.create(name: "Sverige")
      expect(Country.new name: "Sverige").not_to be_valid
    end

    it "... just checking transactional support" do
      expect(Country.count).to eq 0
    end
  end

  describe 'destroy' do
    it "should destroy a record" do
      expect { Country.create(name: "Sverige") }.to change(Country, :count).by(+1)
      expect { Country.where(name: "Sverige").first.destroy }.to change(Country, :count).by(-1)
    end
  end
end
