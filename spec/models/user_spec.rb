require 'rails_helper'

RSpec.describe User, type: :model do
  it "should be adding one" do
    expect { User.create(username: "firlas", role: "writer") }.to change(User, :count).by(+1)
  end

  describe 'validation' do
    it "should be valid" do
      expect(User.create(username: "firlas", role: "writer")).to be_valid
    end

    it "should require a username" do
      expect(User.new(role: "writer")).not_to be_valid
    end

    it "should require a role" do
      expect(User.new(username: "firlas")).not_to be_valid
    end

    it "should be valid with a not too long username" do
      expect(User.new username: "x" * 191, role: "writer").to be_valid
    end

    it "should not have a too long username" do
      expect(User.new username: "x" * 192, role: "writer").not_to be_valid
    end

    it "should not have a too long name" do
      expect(User.new username: "firlas", name: "x" * 192, role: "writer").not_to be_valid
    end

    it "should not have a too long email" do
      expect(User.new username: "firlas", email: "x" * 192, role: "writer").not_to be_valid
    end

    it "should have a unique username" do
      User.create(username: "firlas")
      expect(User.new username: "firlas").not_to be_valid
    end

    it "... just checking transactional support" do
      expect(User.count).to eq 0
    end
  end

  describe 'destroy' do
    it "should destroy a record" do
      expect { User.create(username: "firlas", role: "writer") }.to change(User, :count).by(+1)
      expect { User.where(username: "firlas").first.destroy }.to change(User, :count).by(-1)
    end
  end

  describe 'methods' do
    it "should get the role right" do
      user = User.create(username: "firlas", role: "writer")
      expect(user.has_role? :writer).to be(true)
    end

    it "should get the false role right" do
      user = User.create(username: "firlas", role: "writer")
      expect(user.has_role? :admin).not_to be(true)
    end
  end
end
