require 'rails_helper'

RSpec.describe Home, type: :model do
  it "should be adding one" do
    expect { Home.create(name: "Home name") }.to change(Home, :count).by(+1)
  end

  describe 'validation' do
    it "should be valid" do
      expect(Home.create(name: "Home name")).to be_valid
    end

    it "should require a name" do
      expect(Home.new).not_to be_valid
    end

    it "should be valid with a not too long name" do
      expect(Home.new name: "x" * 191).to be_valid
    end

    it "should not have a too long name" do
      expect(Home.new name: "x" * 192).not_to be_valid
    end

    it "should have a unique name" do
      Home.create(name: "Home name")
      expect(Home.new name: "Home name").not_to be_valid
    end

    it "... just checking transactional support" do
      expect(Home.count).to eq 0
    end
  end

  describe 'destroy' do
    it "should destroy a record" do
      expect { Home.create(name: "Home name") }.to change(Home, :count).by(+1)
      expect { Home.where(name: "Home name").first.destroy }.to change(Home, :count).by(-1)
    end
  end

  describe 'calcution' do
    it "should get number of seats right" do
      home = Home.create(name: "Home name", guaranteed_seats: 9, movable_seats: 7)
      expect(home.seats).to eq(16)
    end
  end
end
