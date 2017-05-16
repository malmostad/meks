require 'rails_helper'

RSpec.describe 'Cost calculation' do
  let(:amount) { 1234 }
  let(:home) { create(:home) }
  let(:refugee) { create(:refugee) }
  let(:cost) { create(:cost, home: home, start_date: Date.today - 30, end_date: Date.today, amount: amount) }
  let(:placement) { create(:placement, moved_in_at: Date.today - 60, refugee: refugee, home: home) }
  let(:home_without_cost) { create(:home, use_placement_cost: true) }
  let(:placement_with_cost) { create(:placement, cost: amount, moved_in_at: Date.today - 60, refugee: refugee, home: home_without_cost) }

  before(:each) do
    home.reload
    refugee.reload
    cost.reload
    placement.reload
  end

  it "should have an amount" do
    expect(cost.amount).not_to be nil
  end

  describe 'Cost calculations for a home without use_placement_cost' do
    it "home should have a cost" do
      expect(home.costs.to_a.size).to eq 1
    end

    it "refugee should have a total cost limited by cost range" do
      expect(refugee.total_cost).to eq 37_020 + amount
    end

    it "refugee should have a total cost limited by placement range" do
      cost = create(:cost, start_date: Date.today - 60, end_date: Date.today, amount: amount)
      placement = create(:placement, moved_in_at: Date.today - 30, home: cost.home)
      expect(placement.refugee.total_cost).to eq 37_020 + amount
    end

    it "should get the first placements cost for a refugee" do
      expect(refugee.placements_costs_and_days.first[:cost]).to eq amount
    end

    it "should get the first placements days for a refugee" do
      expect(refugee.placements_costs_and_days.first[:days]).to eq 31
    end

    it "should get the first placements days for a refugee" do
      expect(refugee.placement_home_costs(placement).first[:days]).to eq 31
    end

    it "should not get the a cost directly from a placement" do
      expect(refugee.placement_cost(placement)[:cost]).to eq 0
    end
  end

  describe 'Cost calculations for a home with use_placement_cost' do
    it "should not get the a cost for a home" do
      expect(refugee.placement_cost(placement)[:cost]).to eq 0
    end

    it "should get the a cost for a placement" do
      expect(refugee.placement_cost(placement_with_cost)[:cost]).to eq amount
    end

    it "should get the first placements cost for a refugee" do
      expect(refugee.placements_costs_and_days.first[:cost]).to eq amount
    end

    it "should get the first placements days for a refugee" do
      expect(refugee.placements_costs_and_days.first[:days]).to eq 31
    end
  end
end
