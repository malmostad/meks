require 'rails_helper'

RSpec.describe "Legal codes", type: :feature do
  describe "admin role" do
    before(:each) do
      login_user(:admin)
    end

    scenario "adds a legal_code" do
      visit "/legal_codes/new"
      fill_in "legal_code_name", with: "Foo"
      click_button "Spara"

      expect(current_path).to eq legal_codes_path
      expect(page).to have_selector(".notice", text: "skapades")
    end

    scenario "updates a legal_code" do
      legal_code = create(:legal_code, name: "Foo")
      visit edit_legal_code_path(legal_code)
      fill_in "legal_code_name", with: "Bar"
      click_button "Spara"

      expect(current_path).to eq legal_codes_path
      expect(page).to have_selector(".notice", text: "uppdaterades")
      expect(page).not_to have_selector("td", text: "Foo")
      expect(page).to have_selector("td", text: "Bar")
    end

    scenario "deletes a legal_code", js: true do
      create(:legal_code, name: "Fox")
      visit "/legal_codes"
      first("a.btn-danger").click

      page.evaluate_script("window.confirm()")
      expect(page).to have_selector(".notice", text: "raderades")
    end
  end

  describe "reader role" do
    before(:each) do
      login_user(:reader)
    end

    scenario "can't add a legal_code" do
      visit "/legal_codes/new"

      expect(current_path).to eq root_path
      expect(page).to have_selector(".alert", text: "Din roll saknar behörighet")
    end
  end

  describe "writer role" do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't add a legal_code" do
      visit "/legal_codes/new"

      expect(current_path).to eq root_path
      expect(page).to have_selector(".alert", text: "Din roll saknar behörighet")
    end
  end
end
