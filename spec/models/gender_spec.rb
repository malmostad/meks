require 'rails_helper'

RSpec.describe Gender, type: :model do
  it "should be adding one" do
    expect { Gender.create(name: "Kvinna") }.to change(Gender, :count).by(+1)
  end

  describe 'validation' do
    it "should be valid" do
      expect(Gender.create(name: "Kvinna")).to be_valid
    end

    it "should require a name" do
      expect(Gender.new).not_to be_valid
    end

    it "should be valid with a not too long name" do
      expect(Gender.new name: "x" * 191).to be_valid
    end

    it "should not have a too long name" do
      expect(Gender.new name: "x" * 192).not_to be_valid
    end

    it "should have a unique name" do
      Gender.create(name: "Kvinna")
      expect(Gender.new name: "Kvinna").not_to be_valid
    end

    it "... just checking transactional support" do
      expect(Gender.count).to eq 0
    end
  end

  describe 'destroy' do
    it "should destroy a record" do
      expect { Gender.create(name: "Kvinna") }.to change(Gender, :count).by(+1)
      expect { Gender.where(name: "Kvinna").first.destroy }.to change(Gender, :count).by(-1)
    end
  end
end
