require 'rails_helper'

RSpec.describe OwnerType, type: :model do
  it "should be adding one" do
    expect { OwnerType.create(name: "Egen") }.to change(OwnerType, :count).by(+1)
  end

  describe 'validation' do
    it "should be valid" do
      expect(OwnerType.create(name: "Egen")).to be_valid
    end

    it "should require a name" do
      expect(OwnerType.new).not_to be_valid
    end

    it "should be valid with a not too long name" do
      expect(OwnerType.new name: "x" * 191).to be_valid
    end

    it "should not have a too long name" do
      expect(OwnerType.new name: "x" * 192).not_to be_valid
    end

    it "should have a unique name" do
      OwnerType.create(name: "Egen")
      expect(OwnerType.new name: "Egen").not_to be_valid
    end

    it "... just checking transactional support" do
      expect(OwnerType.count).to eq 0
    end
  end

  describe 'destroy' do
    it "should destroy a record" do
      expect { OwnerType.create(name: "Egen") }.to change(OwnerType, :count).by(+1)
      expect { OwnerType.where(name: "Egen").first.destroy }.to change(OwnerType, :count).by(-1)
    end
  end
end
