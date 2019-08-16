RSpec.feature 'ExtraContributions', type: :feature do
  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    feature 'Adds extra_contribution' do
      scenario 'returns the form with validation messsage' do
        extra_contribution_types = create_list(:extra_contribution_type, 3)
        person = create(:person)

        visit "/people/#{person.id}/show_costs"
        click_on 'Ny insats'
        expect(current_path).to eq new_person_extra_contribution_path(person)

        select(extra_contribution_types[1].name, from: 'extra_contribution_extra_contribution_type_id')
        fill_in 'extra_contribution_period_start', with: ''
        fill_in 'extra_contribution_period_end', with: (Date.today + 1.year).to_s
        fill_in 'extra_contribution_fee', with: 1234
        fill_in 'extra_contribution_expense', with: 2345

        fill_in 'extra_contribution_contractor_name', with: 'Firstname Familyname'
        fill_in 'extra_contribution_contractor_birthday', with: '1950-04-15'
        fill_in 'extra_contribution_contactor_employee_number', with: '987_543'
        click_button 'Spara'

        expect(current_path).to eq person_extra_contributions_path(person)
        expect(page).to have_selector('.warning', text: 'Vänligen korrigera nedanstående markerade uppgifter.')
        expect(page).to have_selector('.help-block', text: 'måste anges')
      end

      scenario 'save the form' do
        extra_contribution_types = create_list(:extra_contribution_type, 3)
        person = create(:person)

        visit "/people/#{person.id}/show_costs"
        click_on 'Ny insats'
        expect(current_path).to eq new_person_extra_contribution_path(person)

        select(extra_contribution_types[1].name, from: 'extra_contribution_extra_contribution_type_id')
        fill_in 'extra_contribution_period_start', with: Date.today.to_s
        fill_in 'extra_contribution_period_end', with: (Date.today + 1.year).to_s
        fill_in 'extra_contribution_fee', with: 1234
        fill_in 'extra_contribution_expense', with: 2345
        fill_in 'extra_contribution_contractor_name', with: 'Firstname Familyname'
        fill_in 'extra_contribution_contractor_birthday', with: '1950-04-15'
        fill_in 'extra_contribution_contactor_employee_number', with: '987_543'
        click_button 'Spara'

        expect(current_path).to eq person_show_costs_path(person)
        expect(page).to have_selector('.notice', text: 'Insatsen registrerades')
        expect(page).to have_selector('.extra_contribution .controls', text: extra_contribution_types[1].name)
      end

      scenario 'Outpatient type' do
        create_list(:extra_contribution_type, 2)
        extra_contribution_type_outpatient = create(:extra_contribution_type, outpatient: true)
        person = create(:person)

        visit "/people/#{person.id}/show_costs"
        click_on 'Ny insats'
        expect(current_path).to eq new_person_extra_contribution_path(person)

        select(extra_contribution_type_outpatient.name, from: 'extra_contribution_extra_contribution_type_id')
        fill_in 'extra_contribution_period_start', with: Date.today.to_s
        fill_in 'extra_contribution_period_end', with: (Date.today + 1.year).to_s
        fill_in 'extra_contribution_monthly_cost', with: 1234
        fill_in 'extra_contribution_comment', with: 'Foo bar'
        click_button 'Spara'

        expect(current_path).to eq person_show_costs_path(person)
        expect(page).to have_selector('.notice', text: 'Insatsen registrerades')
        expect(page).to have_selector('.extra_contribution .controls', text: extra_contribution_type_outpatient.name)
      end
    end

    feature 'Edit extra_contribution' do
      scenario 'for a person' do
        person = create(:person)
        extra_contribution_types = create_list(:extra_contribution_type, 3)
        create(:extra_contribution, person: person, extra_contribution_type: extra_contribution_types.first)

        visit "/people/#{person.id}/show_costs"
        click_link('Redigera insatsen')
        expect(current_path).to eq edit_person_extra_contribution_path(person, person.extra_contributions.first)

        select(extra_contribution_types[2].name, from: 'extra_contribution_extra_contribution_type_id')
        fill_in 'extra_contribution_period_start', with: Date.today.to_s
        fill_in 'extra_contribution_period_end', with: (Date.today + 2.year).to_s
        fill_in 'extra_contribution_fee', with: 321
        fill_in 'extra_contribution_expense', with: 123
        fill_in 'extra_contribution_contractor_name', with: 'Firstname Familyname'
        fill_in 'extra_contribution_contractor_birthday', with: '1950-04-15'
        fill_in 'extra_contribution_contactor_employee_number', with: '987_543'
        click_button 'Spara'

        expect(current_path).to eq person_show_costs_path(person)
        expect(page).to have_selector('.notice', text: 'Insatsen uppdaterades')
        expect(page).to have_selector('.extra_contribution .controls', text: extra_contribution_types[2].name)
      end
    end
  end

  feature 'reader role' do
    before(:each) do
      login_user(:reader)
    end

    scenario "can't add an extra contribution" do
      create_list(:extra_contribution_type, 3)
      person = create(:person)

      visit "/people/#{person.id}/extra_contributions/new"

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
