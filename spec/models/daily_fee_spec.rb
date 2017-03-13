require 'rails_helper'

RSpec.describe DailyFee, type: :model do
  let(:daily_fee) { create(:daily_fee) }

  describe 'create' do
    it "should be adding one" do
      expect { create(:daily_fee) }.to change(DailyFee, :count).by(+1)
    end
  end

  describe 'validation' do
    it "should be valid" do
      expect(daily_fee).to be_valid
    end

    it "should require a fee" do
      expect(build(:daily_fee, fee: nil)).not_to be_valid
    end

    it "should require a start date" do
      expect(build(:daily_fee, start_date: nil)).not_to be_valid
    end

    it "should belong to a home" do
      expect(build(:daily_fee, home_id: nil)).not_to be_valid
    end
  end

  describe 'destroy' do
    it "should destroy a record" do
      expect { create(:daily_fee) }.to change(DailyFee, :count).by(+1)
      expect { DailyFee.last.destroy }.to change(DailyFee, :count).by(-1)
    end

    it "should delete a daily_fee reference for a home" do
      home = daily_fee.home
      expect(home).to be_present
      daily_fee.destroy
      home.reload
      expect(home.daily_fees).not_to be_present
    end
  end
end
