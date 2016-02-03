require 'rails_helper'

RSpec.describe TypeOfHousing, type: :model do
  it "should be adding one" do
    expect { TypeOfHousing.create(name: "Egen") }.to change(TypeOfHousing, :count).by(+1)
  end

  describe 'validation' do
    it "should be valid" do
      expect(TypeOfHousing.create(name: "Egen")).to be_valid
    end

    it "should require a name" do
      expect(TypeOfHousing.new).not_to be_valid
    end

    it "should be valid with a not too long name" do
      expect(TypeOfHousing.new name: "x" * 191).to be_valid
    end

    it "should not have a too long name" do
      expect(TypeOfHousing.new name: "x" * 192).not_to be_valid
    end

    it "should have a unique name" do
      TypeOfHousing.create(name: "Egen")
      expect(TypeOfHousing.new name: "Egen").not_to be_valid
    end

    it "... just checking transactional support" do
      expect(TypeOfHousing.count).to eq 0
    end
  end

  describe 'destroy' do
    it "should destroy a record" do
      expect { TypeOfHousing.create(name: "Egen") }.to change(TypeOfHousing, :count).by(+1)
      expect { TypeOfHousing.where(name: "Egen").first.destroy }.to change(TypeOfHousing, :count).by(-1)
    end
  end
end
