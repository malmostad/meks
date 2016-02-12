require 'rails_helper'

RSpec.describe "Languages", type: :feature do
  describe "admin role" do
    before(:each) do
      login_user(:admin)
    end

    scenario "adds a language" do
      visit "/languages/new"
      fill_in "language_name", with: "Foo"
      click_button "Spara"

      expect(current_path).to eq languages_path
      expect(page).to have_selector(".notice", text: "skapades")
    end

    scenario "updates a language" do
      language = create(:language, name: "Foo")
      visit edit_language_path(language)
      fill_in "language_name", with: "Bar"
      click_button "Spara"

      expect(current_path).to eq languages_path
      expect(page).to have_selector(".notice", text: "uppdaterades")
      expect(page).not_to have_selector("td", text: "Foo")
      expect(page).to have_selector("td", text: "Bar")
    end

    scenario "deletes a language", js: true do
      language = create(:language, name: "Fox")
      visit "/languages"
      first("a.btn-danger").click

      page.evaluate_script("window.confirm()")
      expect(page).to have_selector(".notice", text: "raderades")
    end
  end

  describe "reader role" do
    before(:each) do
      login_user(:reader)
    end

    scenario "can't add a language" do
      visit "/languages/new"

      expect(current_path).to eq root_path
      expect(page).to have_selector(".alert", text: "Din roll saknar behörighet")
    end
  end

  describe "writer role" do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't add a language" do
      visit "/languages/new"

      expect(current_path).to eq root_path
      expect(page).to have_selector(".alert", text: "Din roll saknar behörighet")
    end
  end
end