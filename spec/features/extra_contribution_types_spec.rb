require 'rails_helper'

RSpec.describe "Extra contribution types", type: :feature do
  describe "admin role" do
    before(:each) do
      login_user(:admin)
    end

    scenario "adds a extra_contribution_type" do
      visit "/extra_contribution_types/new"
      fill_in "extra_contribution_type_name", with: "Foo"
      click_button "Spara"

      expect(current_path).to eq extra_contribution_types_path
      expect(page).to have_selector(".notice", text: "skapades")
    end

    scenario "updates a extra_contribution_type" do
      extra_contribution_type = create(:extra_contribution_type, name: "Foo")
      visit edit_extra_contribution_type_path(extra_contribution_type)
      fill_in "extra_contribution_type_name", with: "Bar"
      click_button "Spara"

      expect(current_path).to eq extra_contribution_types_path
      expect(page).to have_selector(".notice", text: "uppdaterades")
      expect(page).not_to have_selector("td", text: "Foo")
      expect(page).to have_selector("td", text: "Bar")
    end

    scenario "deletes a extra_contribution_type", js: true do
      create(:extra_contribution_type, name: "Fox")
      visit "/extra_contribution_types"
      first(".btn-danger").click

      page.evaluate_script("window.confirm()")
      expect(page).to have_selector(".notice", text: "raderades")
    end
  end

  describe "reader role" do
    before(:each) do
      login_user(:reader)
    end

    scenario "can't add a extra_contribution_type" do
      visit "/extra_contribution_types/new"

      expect(current_path).to eq root_path
      expect(page).to have_selector(".alert", text: "Din roll saknar behörighet")
    end
  end

  describe "writer role" do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't add a extra_contribution_type" do
      visit "/extra_contribution_types/new"

      expect(current_path).to eq root_path
      expect(page).to have_selector(".alert", text: "Din roll saknar behörighet")
    end
  end
end
