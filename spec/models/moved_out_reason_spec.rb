require 'rails_helper'

RSpec.describe MovedOutReason, type: :model do
  it "should be adding one" do
    expect { MovedOutReason.create(name: "18 år") }.to change(MovedOutReason, :count).by(+1)
  end

  describe 'validation' do
    it "should be valid" do
      expect(MovedOutReason.create(name: "18 år")).to be_valid
    end

    it "should require a name" do
      expect(MovedOutReason.new).not_to be_valid
    end

    it "should be valid with a not too long name" do
      expect(MovedOutReason.new name: "x" * 191).to be_valid
    end

    it "should not have a too long name" do
      expect(MovedOutReason.new name: "x" * 192).not_to be_valid
    end

    it "should have a unique name" do
      MovedOutReason.create(name: "18 år")
      expect(MovedOutReason.new name: "18 år").not_to be_valid
    end

    it "... just checking transactional support" do
      expect(MovedOutReason.count).to eq 0
    end
  end

  describe 'destroy' do
    it "should destroy a record" do
      expect { MovedOutReason.create(name: "18 år") }.to change(MovedOutReason, :count).by(+1)
      expect { MovedOutReason.where(name: "18 år").first.destroy }.to change(MovedOutReason, :count).by(-1)
    end
  end
end
