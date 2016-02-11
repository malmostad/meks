require 'rails_helper'

RSpec.describe "Refugees", type: :feature do
  describe "writer role" do
    before(:each) do
      login_user(:writer)
    end

    scenario "adds a refugee" do
      visit "/refugees"
      first(".btn-primary", text: "Registrera ny").click
      fill_in "refugee_name", with: "Foo"
      click_button "Spara"

      expect(current_path).to eq refugee_path(Refugee.last)
      expect(page).to have_selector(".notice", text: "Ensamkommande barnet registrerat")
    end

    scenario "updates a refugee" do
      refugee = create(:refugee, name: "Foo")
      visit edit_refugee_path(refugee)
      fill_in "refugee_name", with: "Bar"
      click_button "Spara"

      expect(current_path).to eq refugee_path(refugee)
      expect(page).to have_selector(".notice", text: "uppdaterades")
      expect(page).to have_selector(".controls", text: "Bar")
    end

    scenario "validates the uniqueness of the dossier number" do
      create(:refugee, dossier_number: "1234")
      visit "/refugees/new"

      fill_in "refugee_name", with: "Bar"
      fill_in "refugee_dossier_number", with: "1234"
      click_button "Spara"

      expect(page).to have_selector(".warning", text: "Vänligen korrigera nedanstående markerade uppgifter.")
      expect(page).to have_selector(".refugee_dossier_number.warning .help-block", text: "finns redan")
    end
  end

  describe "reader role" do
    before(:each) do
      login_user(:reader)
    end

    scenario "adding a refugee gets a draft status" do
      visit "/refugees"
      first(".btn-primary", text: "Registrera ny").click
      fill_in "refugee_name", with: "Foo"
      click_button "Spara"

      expect(Refugee.last.draft).to eq true
      expect(page).to have_selector(".notice", text: "Ensamkommande barnet registrerat")
    end
  end
end
