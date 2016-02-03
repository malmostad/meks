require 'rails_helper'

RSpec.describe TypeOfRelationship, type: :model do
  it "should be adding one" do
    expect { TypeOfRelationship.create(name: "Syster") }.to change(TypeOfRelationship, :count).by(+1)
  end

  describe 'validation' do
    it "should be valid" do
      expect(TypeOfRelationship.create(name: "Syster")).to be_valid
    end

    it "should require a name" do
      expect(TypeOfRelationship.new).not_to be_valid
    end

    it "should be valid with a not too long name" do
      expect(TypeOfRelationship.new name: "x" * 191).to be_valid
    end

    it "should not have a too long name" do
      expect(TypeOfRelationship.new name: "x" * 192).not_to be_valid
    end

    it "should have a unique name" do
      TypeOfRelationship.create(name: "Syster")
      expect(TypeOfRelationship.new name: "Syster").not_to be_valid
    end

    it "... just checking transactional support" do
      expect(TypeOfRelationship.count).to eq 0
    end
  end

  describe 'destroy' do
    it "should destroy a record" do
      expect { TypeOfRelationship.create(name: "Syster") }.to change(TypeOfRelationship, :count).by(+1)
      expect { TypeOfRelationship.where(name: "Syster").first.destroy }.to change(TypeOfRelationship, :count).by(-1)
    end
  end
end
