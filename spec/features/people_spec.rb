RSpec.feature 'People', type: :feature do
  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario 'adds a person' do
      visit '/people'
      first('.btn-primary', text: 'Registrera ny').click
      fill_in 'person_name', with: 'Foo'
      click_button 'Spara'

      expect(current_path).to eq person_path(Person.last)
      expect(page).to have_selector('.notice', text: 'Personen registrerades')
    end

    scenario 'updates a person' do
      person = create(:person, name: 'Foo')
      visit edit_person_path(person)
      fill_in 'person_name', with: 'Bar'
      click_button 'Spara'

      expect(current_path).to eq person_path(person)
      expect(page).to have_selector('.notice', text: 'uppdaterades')
      expect(page).to have_selector('.controls', text: 'Bar')
    end

    scenario 'set secrecy' do
      person = create(:person, name: 'Foo')
      visit edit_person_path(person)
      check 'person_secrecy'
      click_button 'Spara'

      expect(current_path).to eq person_path(person)
      expect(page).to have_selector('.secrecy', text: 'Sekretess')
    end

    scenario 'validates the uniqueness of the dossier number' do
      create(:person, dossier_number: '1234')
      visit '/people/new'

      fill_in 'person_name', with: 'Bar'
      fill_in 'person_dossier_number', with: '1234'
      click_button 'Spara'

      expect(page).to have_selector('.warning', text: 'Vänligen korrigera nedanstående markerade uppgifter.')
      expect(page).to have_selector('.person_dossier_number.warning .help-block', text: 'finns redan')
    end

    feature 'EKB fields', js: true do
      scenario 'should be visable in form' do
        person = create(:person, name: 'Foo')
        visit edit_person_path(person)

        expect(page).to have_selector("input[name='person[ekb]'][value='1']")

        expect(page).to have_selector('.ekb-only')
        expect(page).to have_selector('.person_dossier_number')
        expect(page).to have_selector('.person_special_needs')
        expect(page).to have_selector('.person_residence_permit_at')
        expect(page).to have_selector('.person_checked_out_to_our_city')
        expect(page).to have_selector('.person_temporary_permit_starts_at')
        expect(page).to have_selector('.person_temporary_permit_ends_at')
        expect(page).to have_selector('.person_citizenship_at')
        expect(page).to have_selector('.person_transferred')
        expect(page).to have_selector('.person_municipality_placement_migrationsverket_at')
        expect(page).to have_selector('.person_municipality_placement_comment')
        expect(page).to have_selector('.person_deregistered_reason')
      end

      scenario 'should not be visable in form' do
        person = create(:person, name: 'Foo')
        visit edit_person_path(person)
        uncheck 'person_ekb'

        expect(page).not_to have_selector('.ekb-only')
        expect(page).not_to have_selector('.person_ssns_date_of_birth')
        expect(page).not_to have_selector('.person_dossier_number')
        expect(page).not_to have_selector('.person_dossier_numbers_name')
        expect(page).not_to have_selector('.person_special_needs')
        expect(page).not_to have_selector('.person_residence_permit_at')
        expect(page).not_to have_selector('.person_checked_out_to_our_city')
        expect(page).not_to have_selector('.person_temporary_permit_starts_at')
        expect(page).not_to have_selector('.person_temporary_permit_ends_at')
        expect(page).not_to have_selector('.person_citizenship_at')
        expect(page).not_to have_selector('.person_transferred')
        expect(page).not_to have_selector('.person_municipality_placement_migrationsverket_at')
        expect(page).not_to have_selector('.person_municipality_placement_comment')
        expect(page).not_to have_selector('.person_deregistered_reason')
      end

      scenario 'should be visable in show view' do
        person = create(:person)
        visit person_path(person)

        expect(page).to have_selector('.control-label', text:  label('person.extra_ssns'))
        expect(page).to have_selector('.control-label', text:  label('person.dossier_number'))
        expect(page).to have_selector('.control-label', text:  label('person.dossier_numbers'))
        expect(page).to have_selector('.control-label', text:  label('person.special_needs'))
        expect(page).to have_selector('.control-label', text:  label('person.residence_permit_at'))
        expect(page).to have_selector('.control-label', text:  label('person.checked_out_to_our_city'))
        expect(page).to have_selector('.control-label', text:  label('person.temporary_permit_starts_at'))
        expect(page).to have_selector('.control-label', text:  label('person.temporary_permit_ends_at'))
        expect(page).to have_selector('.control-label', text:  label('person.citizenship_at'))
        expect(page).to have_selector('.control-label', text:  label('person.transferred'))
        expect(page).to have_selector('.control-label', text:  label('person.municipality_placement_migrationsverket_at'))
        expect(page).to have_selector('.control-label', text:  label('person.municipality_placement_comment'))
        expect(page).to have_selector('.control-label', text:  label('person.deregistered_reason'))
      end

      scenario 'should not be visable in show view' do
        person = create(:person, ekb: false)
        visit person_path(person)

        expect(page).not_to have_selector('.control-label', text:  label('person.extra_ssns'))
        expect(page).not_to have_selector('.control-label', text:  label('person.dossier_number'))
        expect(page).not_to have_selector('.control-label', text:  label('person.dossier_numbers'))
        expect(page).not_to have_selector('.control-label', text:  label('person.special_needs'))
        expect(page).not_to have_selector('.control-label', text:  label('person.residence_permit_at'))
        expect(page).not_to have_selector('.control-label', text:  label('person.checked_out_to_our_city'))
        expect(page).not_to have_selector('.control-label', text:  label('person.temporary_permit_starts_at'))
        expect(page).not_to have_selector('.control-label', text:  label('person.temporary_permit_ends_at'))
        expect(page).not_to have_selector('.control-label', text:  label('person.citizenship_at'))
        expect(page).not_to have_selector('.control-label', text:  label('person.transferred'))
        expect(page).not_to have_selector('.control-label', text:  label('person.municipality_placement_migrationsverket_at'))
        expect(page).not_to have_selector('.control-label', text:  label('person.municipality_placement_comment'))
      end
    end
  end

  feature 'reader role' do
    before(:each) do
      login_user(:reader)
    end

    scenario 'adding a person gets a draft status' do
      visit '/people'
      first('.btn-primary', text: 'Registrera ny').click
      fill_in 'person_name', with: 'Foo'
      click_button 'Spara'

      expect(Person.last.draft).to eq true
      expect(page).to have_selector('.notice', text: 'Personen registrerades')
    end
  end
end
