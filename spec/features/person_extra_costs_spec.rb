RSpec.feature 'PersonExtraCost', type: :feature do
  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    feature 'Adds person_extra_cost' do
      scenario 'reload the form with validation message' do
        person = create(:person)

        visit "/people/#{person.id}/show_costs"
        click_on 'Ny extra kostnad'
        expect(current_path).to eq new_person_person_extra_cost_path(person)

        fill_in 'person_extra_cost_date', with: Date.today.to_s
        fill_in 'person_extra_cost_amount', with: ''
        fill_in 'person_extra_cost_comment', with: 'Foo bar'
        click_button 'Spara'

        expect(current_path).to eq person_person_extra_costs_path(person)
        expect(page).to have_selector('.warning', text: 'Vänligen korrigera nedanstående markerade uppgifter.')
        expect(page).to have_selector('.help-block', text: 'måste anges')
      end

      scenario 'saves the form' do
        person = create(:person)

        visit "/people/#{person.id}/show_costs"
        click_on 'Ny extra kostnad'
        expect(current_path).to eq new_person_person_extra_cost_path(person)

        fill_in 'person_extra_cost_date', with: Date.today.to_s
        fill_in 'person_extra_cost_amount', with: 1234
        fill_in 'person_extra_cost_comment', with: 'Foo bar'
        click_button 'Spara'

        expect(current_path).to eq person_show_costs_path(person)
        expect(page).to have_selector('.notice', text: 'Extra kostnaden registrerades')
      end
    end

    feature 'Edit person_extra_cost' do
      scenario 'for a person' do
        person = create(:person)
        create(:person_extra_cost, person: person)

        visit "/people/#{person.id}/show_costs"
        click_link('Redigera extra kostnaden')
        expect(current_path).to eq edit_person_person_extra_cost_path(person, person.person_extra_costs.first)

        fill_in 'person_extra_cost_date', with: Date.today.to_s
        fill_in 'person_extra_cost_amount', with: 321
        fill_in 'person_extra_cost_comment', with: 'Fox barx'
        click_button 'Spara'

        expect(current_path).to eq person_show_costs_path(person)
        expect(page).to have_selector('.notice', text: 'Extra kostnaden uppdaterades')
      end
    end
  end

  feature 'reader role' do
    before(:each) do
      login_user(:reader)
    end

    scenario "can't add an extra cost" do
      person = create(:person)

      visit "/people/#{person.id}/person_extra_costs/new"

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
