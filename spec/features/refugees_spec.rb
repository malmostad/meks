RSpec.feature "Refugees", type: :feature do
  feature "writer role" do
    before(:each) do
      login_user(:writer)
    end

    scenario "adds a refugee" do
      visit "/people"
      first(".btn-primary", text: "Registrera ny").click
      fill_in "refugee_name", with: "Foo"
      click_button "Spara"

      expect(current_path).to eq refugee_path(Refugee.last)
      expect(page).to have_selector(".notice", text: 'Personen registrerades')
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

    scenario "set secrecy" do
      refugee = create(:refugee, name: "Foo")
      visit edit_refugee_path(refugee)
      check "refugee_secrecy"
      click_button "Spara"

      expect(current_path).to eq refugee_path(refugee)
      expect(page).to have_selector(".secrecy", text: "Sekretess")
    end

    scenario "validates the uniqueness of the dossier number" do
      create(:refugee, dossier_number: "1234")
      visit "/people/new"

      fill_in "refugee_name", with: "Bar"
      fill_in "refugee_dossier_number", with: "1234"
      click_button "Spara"

      expect(page).to have_selector(".warning", text: "Vänligen korrigera nedanstående markerade uppgifter.")
      expect(page).to have_selector(".refugee_dossier_number.warning .help-block", text: "finns redan")
    end

    feature "EKB fields", js: true do
      scenario "should be visable in form" do
        refugee = create(:refugee, name: "Foo")
        visit edit_refugee_path(refugee)

        expect(page).to have_selector("input[name='refugee[ekb]'][value='1']")

        expect(page).to have_selector('.ekb-only')
        expect(page).to have_selector('.refugee_dossier_number')
        expect(page).to have_selector('.refugee_special_needs')
        expect(page).to have_selector('.refugee_residence_permit_at')
        expect(page).to have_selector('.refugee_checked_out_to_our_city')
        expect(page).to have_selector('.refugee_temporary_permit_starts_at')
        expect(page).to have_selector('.refugee_temporary_permit_ends_at')
        expect(page).to have_selector('.refugee_citizenship_at')
        expect(page).to have_selector('.refugee_transferred')
        expect(page).to have_selector('.refugee_municipality_placement_migrationsverket_at')
        expect(page).to have_selector('.refugee_municipality_placement_comment')
        expect(page).to have_selector('.refugee_deregistered_reason')
      end

      scenario "should not be visable in form" do
        refugee = create(:refugee, name: "Foo")
        visit edit_refugee_path(refugee)
        uncheck "refugee_ekb"

        expect(page).not_to have_selector('.ekb-only')
        expect(page).not_to have_selector('.refugee_ssns_date_of_birth')
        expect(page).not_to have_selector('.refugee_dossier_number')
        expect(page).not_to have_selector('.refugee_dossier_numbers_name')
        expect(page).not_to have_selector('.refugee_special_needs')
        expect(page).not_to have_selector('.refugee_residence_permit_at')
        expect(page).not_to have_selector('.refugee_checked_out_to_our_city')
        expect(page).not_to have_selector('.refugee_temporary_permit_starts_at')
        expect(page).not_to have_selector('.refugee_temporary_permit_ends_at')
        expect(page).not_to have_selector('.refugee_citizenship_at')
        expect(page).not_to have_selector('.refugee_transferred')
        expect(page).not_to have_selector('.refugee_municipality_placement_migrationsverket_at')
        expect(page).not_to have_selector('.refugee_municipality_placement_comment')
        expect(page).not_to have_selector('.refugee_deregistered_reason')
      end

      scenario "should be visable in show view" do
        refugee = create(:refugee)
        visit refugee_path(refugee)

        expect(page).to have_selector('.control-label', text:  label('refugee.extra_ssns'))
        expect(page).to have_selector('.control-label', text:  label('refugee.dossier_number'))
        expect(page).to have_selector('.control-label', text:  label('refugee.dossier_numbers'))
        expect(page).to have_selector('.control-label', text:  label('refugee.special_needs'))
        expect(page).to have_selector('.control-label', text:  label('refugee.residence_permit_at'))
        expect(page).to have_selector('.control-label', text:  label('refugee.checked_out_to_our_city'))
        expect(page).to have_selector('.control-label', text:  label('refugee.temporary_permit_starts_at'))
        expect(page).to have_selector('.control-label', text:  label('refugee.temporary_permit_ends_at'))
        expect(page).to have_selector('.control-label', text:  label('refugee.citizenship_at'))
        expect(page).to have_selector('.control-label', text:  label('refugee.transferred'))
        expect(page).to have_selector('.control-label', text:  label('refugee.municipality_placement_migrationsverket_at'))
        expect(page).to have_selector('.control-label', text:  label('refugee.municipality_placement_comment'))
        expect(page).to have_selector('.control-label', text:  label('refugee.deregistered_reason'))
      end

      scenario "should not be visable in show view" do
        refugee = create(:refugee, ekb: false)
        visit refugee_path(refugee)

        expect(page).not_to have_selector('.control-label', text:  label('refugee.extra_ssns'))
        expect(page).not_to have_selector('.control-label', text:  label('refugee.dossier_number'))
        expect(page).not_to have_selector('.control-label', text:  label('refugee.dossier_numbers'))
        expect(page).not_to have_selector('.control-label', text:  label('refugee.special_needs'))
        expect(page).not_to have_selector('.control-label', text:  label('refugee.residence_permit_at'))
        expect(page).not_to have_selector('.control-label', text:  label('refugee.checked_out_to_our_city'))
        expect(page).not_to have_selector('.control-label', text:  label('refugee.temporary_permit_starts_at'))
        expect(page).not_to have_selector('.control-label', text:  label('refugee.temporary_permit_ends_at'))
        expect(page).not_to have_selector('.control-label', text:  label('refugee.citizenship_at'))
        expect(page).not_to have_selector('.control-label', text:  label('refugee.transferred'))
        expect(page).not_to have_selector('.control-label', text:  label('refugee.municipality_placement_migrationsverket_at'))
        expect(page).not_to have_selector('.control-label', text:  label('refugee.municipality_placement_comment'))
        expect(page).not_to have_selector('.control-label', text:  label('refugee.deregistered_reason'))
      end
    end
  end

  feature "reader role" do
    before(:each) do
      login_user(:reader)
    end

    scenario "adding a refugee gets a draft status" do
      visit "/people"
      first(".btn-primary", text: "Registrera ny").click
      fill_in "refugee_name", with: "Foo"
      click_button "Spara"

      expect(Refugee.last.draft).to eq true
      expect(page).to have_selector(".notice", text: "Personen registrerades")
    end
  end
end
