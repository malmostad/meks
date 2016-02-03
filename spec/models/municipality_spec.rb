require 'rails_helper'

RSpec.describe Municipality, type: :model do
  it "should be adding one" do
    expect { Municipality.create(name: "Umeå") }.to change(Municipality, :count).by(+1)
  end

  describe 'validation' do
    it "should be valid" do
      expect(Municipality.create(name: "Umeå")).to be_valid
    end

    it "should require a name" do
      expect(Municipality.new).not_to be_valid
    end

    it "should be valid with a not too long name" do
      expect(Municipality.new name: "x" * 191).to be_valid
    end

    it "should not have a too long name" do
      expect(Municipality.new name: "x" * 192).not_to be_valid
    end

    it "should have a unique name" do
      Municipality.create(name: "Umeå")
      expect(Municipality.new name: "Umeå").not_to be_valid
    end

    it "... just checking transactional support" do
      expect(Municipality.count).to eq 0
    end
  end

  describe 'destroy' do
    it "should destroy a record" do
      expect { Municipality.create(name: "Umeå") }.to change(Municipality, :count).by(+1)
      expect { Municipality.where(name: "Umeå").first.destroy }.to change(Municipality, :count).by(-1)
    end
  end
end
