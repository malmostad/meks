require 'rails_helper'

RSpec.describe "Placements", type: :feature do
  # testing with out js to get rid of the testing problems with the chosen widget

  describe "writer role" do
    before(:each) do
      login_user(:writer)
    end

    describe "Adds placement" do
      scenario "for a refugee" do
        refugee     = create(:refugee)
        homes       = create_list(:home, 10)
        legal_codes = create_list(:legal_code, 10)

        visit "/refugees/#{refugee.id}"
        click_on "Ny placering"
        expect(current_path).to eq new_refugee_placement_path(refugee)

        select(homes[1].name, from: "placement_home_id")
        select(legal_codes[1].name, from: "legal_code_id")
        fill_in "placement_moved_in_at", with: Date.today.to_s
        click_button "Spara"

        expect(current_path).to eq refugee_path(refugee)
        expect(page).to have_selector(".notice", text: "Placeringen registrerades")
        expect(page).to have_selector(".placement a", text: homes[1].name)
        expect(page).to have_selector(".placement .controls", text: legal_code[1].name)
      end

      scenario "show and hide specification field", js: true do
        refugee = create(:refugee)
        homes = create_list(:home, 10)
        homes << create(:home, use_placement_specification: true)

        visit "/refugees/#{refugee.id}"
        click_on "Ny placering"

        expect(page).to have_selector('.placement_specification', visible: false)

        page.execute_script("$('#placement_home_id').val(#{homes.last.id}).change()")
        expect(page).to have_selector('.placement_specification', visible: true)

        page.execute_script("$('#placement_home_id').val(#{homes.first.id}).change()")
        expect(page).to have_selector('.placement_specification', visible: false)
      end
    end

    describe "Edit placement" do
      scenario "for a refugee" do
        refugee     = create(:refugee)
        homes       = create_list(:home, 10)
        legal_codes = create_list(:legal_code, 10)
        placement   = create(:placement, refugee: refugee, home: homes.first, legal_code: legal_codes.first)

        visit "/refugees/#{refugee.id}"
        click_link("Redigera placeringen")
        expect(current_path).to eq edit_refugee_placement_path(refugee, refugee.placements.first)

        select(homes[3].name, from: "placement_home_id")
        select(legal_codes[3].name, from: "legal_code_id")
        fill_in "placement_moved_in_at", with: Date.today.to_s
        click_button "Spara"

        expect(current_path).to eq refugee_path(refugee)
        expect(page).to have_selector(".notice", text: "Placeringen uppdaterades")
        expect(page).to have_selector(".placement a", text: homes[3].name)
        expect(page).to have_selector(".placement .controls", text: legal_codes[3].name)
      end

      scenario "show and hide specification field", js: true do
        refugee = create(:refugee)
        homes = create_list(:home, 10)
        homes << create(:home, use_placement_specification: true)

        placement = create(:placement, refugee: refugee, home: homes.last)

        visit "/refugees/#{refugee.id}"
        click_link("Redigera placeringen")

        expect(page).to have_selector('.placement_specification', visible: true)

        page.execute_script("$('#placement_home_id').val(#{homes.last.id}).change()")
        expect(page).to have_selector('.placement_specification', visible: true)
      end
    end

    describe "Ends placement" do
      scenario "for a refugee" do
        refugee     = create(:refugee)
        homes       = create_list(:home, 10)
        legal_codes = create_list(:legal_code, 10)
        placement   = create(:placement, refugee: refugee, home: homes.first, legal_code: legal_codes.first)
        moved_out_reasons = create_list(:moved_out_reason, 5)

        visit "/refugees/#{refugee.id}"
        click_link("Utskrivning")

        select(moved_out_reasons[3].name, from: "placement_moved_out_reason_id")
        fill_in "placement_moved_out_at", with: Date.today.to_s
        click_button "Spara"

        expect(current_path).to eq refugee_path(refugee)
        expect(page).to have_selector(".notice", text: "Placeringen uppdaterades")
        expect(page).to have_selector(".placement .controls", text: Date.today.to_s)
      end

      scenario "can't end before it was started" do
        refugee     = create(:refugee)
        homes       = create_list(:home, 10)
        legal_codes = create_list(:legal_code, 10)
        placement   = create(:placement, refugee: refugee, home: homes.first, legal_code: legal_codes.first)
        moved_out_reasons = create_list(:moved_out_reason, 5)

        visit "/refugees/#{refugee.id}"
        click_link("Utskrivning")

        select(moved_out_reasons[3].name, from: "placement_moved_out_reason_id")
        fill_in "placement_moved_out_at", with: (Date.today - 10.day).to_s
        click_button "Spara"

        expect(current_path).to eq refugee_placement_path(refugee, placement)
        expect(page).to have_selector(".warning", text: "måste vara senare än inskrivningen")
      end
    end
  end
end
