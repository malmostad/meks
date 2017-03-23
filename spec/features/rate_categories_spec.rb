require 'rails_helper'

RSpec.describe "Rate Category", type: :feature do
  describe "admin role" do
    before(:each) do
      login_user(:admin)
    end

    scenario "updates a rate_category" do
      rate_category = create(:rate_category, name: 'Foo')
      visit edit_rate_category_path(rate_category)
      fill_in "rate_category_name", with: "Bar"
      fill_in "rate_category_from_age", with: 18
      fill_in "rate_category_to_age", with: 20
      click_button "Spara"

      expect(current_path).to eq rate_categories_path
      expect(page).to have_selector(".notice", text: "uppdaterades")
      expect(page).not_to have_selector("td", text: "Foo")
      expect(page).to have_selector("td", text: "Bar")
    end
  end

  describe "reader role" do
    before(:each) do
      login_user(:reader)
    end
  end

  describe "writer role" do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't edit a rate_category" do
      rate_category = create(:rate_category)
      visit edit_rate_category_path(rate_category)
      expect(current_path).to eq root_path
      expect(page).to have_selector(".alert", text: "Din roll saknar behörighet")
    end
  end
end
