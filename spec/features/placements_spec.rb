RSpec.feature 'Placements', type: :feature do
  feature 'writer role' do
    let(:person) { create(:person) }
    let(:legal_codes) { create_list(:legal_code, 10) }
    let(:homes) { create_list(:home, 10) }
    let(:placement) { create(:placement, person: person, home: homes.first, legal_code: legal_codes.first) }
    let(:moved_out_reasons) { create_list(:moved_out_reason, 5) }
    let(:cost_per_day_home) { create(:home, type_of_cost: 'cost_per_day') }
    let(:cost_per_placement_home) { create(:home, type_of_cost: 'cost_per_placement') }
    let(:cost_for_family_and_emergency_home_home) { create(:home, type_of_cost: 'cost_for_family_and_emergency_home') }
    let(:po_rate) {
      create(
        :po_rate,
        rate_under_65: 30.32,
        rate_between_65_and_81: 30.64,
        rate_from_82: 2.12,
        start_date: '2018-01-01',
        end_date: '2018-12-31'
      )
    }

    before(:each) do
      login_user(:writer)

      [person, placement, cost_per_day_home, cost_per_placement_home,
       cost_for_family_and_emergency_home_home, po_rate].each(&:reload)
      [legal_codes, homes, moved_out_reasons].each { |list| list.each(&:reload) }
    end

    feature 'Adds placement' do
      scenario 'for a person' do
        visit "/people/#{person.id}/show_placements"
        click_on 'Ny placering'
        expect(current_path).to eq new_person_placement_path(person)

        select(homes[1].name, from: 'placement_home_id')
        select(legal_codes[1].name, from: 'placement_legal_code_id')
        fill_in 'placement_moved_in_at', with: Date.today.to_s
        click_button 'Spara'

        expect(current_path).to eq person_show_placements_path(person)
        expect(page).to have_selector('.notice', text: 'Placeringen registrerades')
        expect(page).to have_selector('.placement a', text: homes[1].name)
        expect(page).to have_selector('.placement .controls', text: legal_codes[1].name)
      end

      scenario 'with extra cost', js: true do
        visit "/people/#{person.id}/show_placements"
        click_on 'Ny placering'
        expect(current_path).to eq new_person_placement_path(person)

        select_from_chosen(homes[1].name, from: 'placement_home_id')
        select(legal_codes[1].name, from: 'placement_legal_code_id')
        fill_in 'placement_moved_in_at', with: Date.today.to_s

        click_on 'Ny extra utgift'
        page.all('.placement_placement_extra_costs_date input').first.fill_in with: '2018-12-01'
        page.all('.placement_placement_extra_costs_amount input').first.fill_in with: 123
        page.all('.placement_placement_extra_costs_comment input').first.fill_in with: 'Foo bar kommentar'

        click_button 'Spara'

        expect(page).to have_selector(
          'div', text: 'Datum: 2018-12-01, belopp: 123,00 kr, kommentar: Foo bar kommentar'
        )
      end

      scenario 'with cost for family and emergency_home', js: true do
        visit "/people/#{person.id}/show_placements"
        click_on 'Ny placering'
        expect(current_path).to eq new_person_placement_path(person)

        select_from_chosen(cost_for_family_and_emergency_home_home.name, from: 'placement_home_id')
        select(legal_codes[1].name, from: 'placement_legal_code_id')
        fill_in 'placement_moved_in_at', with: Date.today.to_s

        click_on 'Ny familje/jourhemskostnad'
        page.all('.placement_family_and_emergency_home_costs_period_start input').first.fill_in with: '2018-12-01'
        page.all('.placement_family_and_emergency_home_costs_period_end input').first.fill_in with: '2018-12-31'
        page.all('.placement_family_and_emergency_home_costs_fee input').first.fill_in with: 4567
        page.all('.placement_family_and_emergency_home_costs_expense input').first.fill_in with: 1234
        page.all('.placement_family_and_emergency_home_costs_contractor_name input').first.fill_in with: 'Firstname Familyname'
        page.all('.placement_family_and_emergency_home_costs_contractor_birthday input').first.fill_in with: '1950-04-15'
        page.all('.placement_family_and_emergency_home_costs_contactor_employee_number input').first.fill_in with: '987_543'
        click_button 'Spara'

        expect(page).to have_content('Avtalsperiod: 2018-12-01–2018-12-31, arvode: 4 567,00 kr, arbetsgivaravgift: 1 399,33 kr, omkostnad: 1 234,00 kr, uppdragstagare: Firstname Familyname, uppdragstagares födelsedag: 1950-04-15, uppdragstagares anställningsnummer: 987543')
      end

      scenario 'shows and hides the specification field', js: true do
        homes << create(:home, use_placement_specification: true)

        visit "/people/#{person.id}/show_placements"
        click_on 'Ny placering'

        expect(page).to have_selector('.placement_specification', visible: false)

        page.execute_script("$('#placement_home_id').val(#{homes.last.id}).change()")
        expect(page).to have_selector('.placement_specification', visible: true)

        page.execute_script("$('#placement_home_id').val(#{homes.first.id}).change()")
        expect(page).to have_selector('.placement_specification', visible: false)
      end

      scenario 'shows and hides family_and_emergency_home_cost field', js: true do
        visit "/people/#{person.id}/show_placements"
        click_on 'Ny placering'

        expect(page.all('.family_and_emergency_home_costs', visible: true)).to be_empty

        page.execute_script("$('#placement_home_id').val(#{cost_per_day_home.id}).change()")
        expect(page.all('.family_and_emergency_home_costs', visible: true)).to be_empty

        page.execute_script("$('#placement_home_id').val(#{cost_per_placement_home.id}).change()")
        expect(page.all('.family_and_emergency_home_costs', visible: true)).to be_empty

        page.execute_script("$('#placement_home_id').val(#{cost_for_family_and_emergency_home_home.id}).change()")
        expect(page.all('.family_and_emergency_home_costs', visible: true)).not_to be_empty

        page.execute_script("$('#placement_home_id').val(#{cost_per_placement_home.id}).change()")
        expect(page.all('.family_and_emergency_home_costs', visible: true)).to be_empty
      end

      scenario 'shows and hides family_and_emergency_home_cost form fields', js: true do
        visit "/people/#{person.id}/show_placements"
        click_on 'Ny placering'
        page.execute_script("$('#placement_home_id').val(#{cost_for_family_and_emergency_home_home.id}).change()")
        expect(page.all('.family_and_emergency_home_costs', visible: true)).not_to be_empty
        expect(page).not_to have_selector('.family_and_emergency_home_costs .terms .form-group .form-group')

        click_on 'Ny familje/jourhemskostnad'
        expect(page.all('.family_and_emergency_home_costs .terms .form-group .form-group', visible: true)).not_to be_empty

        click_on 'Radera familje/jourhemskostnad'
        expect(page.all('.family_and_emergency_home_costs .terms .form-group .form-group', visible: true)).to be_empty
      end

      scenario 'shows and hides extra_costs form fields', js: true do
        visit "/people/#{person.id}/show_placements"
        click_on 'Ny placering'

        click_on 'Ny extra utgift'
        expect(page.all('.placement_placement_extra_costs_date', visible: true)).not_to be_empty

        click_on 'Radera extra utgiften'
        expect(page.all('.placement_placement_extra_costs_date', visible: true)).to be_empty
      end
    end

    feature 'Edit placement' do
      scenario 'for a person' do
        visit "/people/#{person.id}/show_placements"
        click_link('Redigera placeringen')
        expect(current_path).to eq edit_person_placement_path(person, person.placements.first)

        select(homes[3].name, from: 'placement_home_id')
        select(legal_codes[3].name, from: 'placement_legal_code_id')
        fill_in 'placement_moved_in_at', with: Date.today.to_s
        click_button 'Spara'

        expect(current_path).to eq person_show_placements_path(person)
        expect(page).to have_selector('.notice', text: 'Placeringen uppdaterades')
        expect(page).to have_selector('.placement a', text: homes[3].name)
        expect(page).to have_selector('.placement .controls', text: legal_codes[3].name)
      end

      scenario 'show and hide specification field', js: true do
        homes << create(:home, use_placement_specification: true)
        placement.update_attribute(:home, homes.last)

        visit "/people/#{person.id}/show_placements"
        click_link('Redigera placeringen')

        expect(page).to have_selector('.placement_specification', visible: false)

        page.execute_script("$('#placement_home_id').val(#{homes.last.id}).change()")
        expect(page).to have_selector('.placement_specification', visible: true)
      end
    end

    feature 'Ends placement' do
      scenario 'for a person' do
        visit "/people/#{person.id}/show_placements"
        click_link('Utskrivning')

        select(moved_out_reasons[3].name, from: 'placement_moved_out_reason_id')
        fill_in 'placement_moved_out_at', with: Date.today.to_s
        click_button 'Spara'

        expect(current_path).to eq person_show_placements_path(person)
        expect(page).to have_selector('.notice', text: 'Placeringen uppdaterades')
        expect(page).to have_selector('.placement .controls', text: Date.today.to_s)
      end

      scenario 'can’t end before it was started' do
        visit "/people/#{person.id}/show_placements"
        click_link('Utskrivning')

        select(moved_out_reasons[3].name, from: 'placement_moved_out_reason_id')
        fill_in 'placement_moved_out_at', with: (Date.today - 10.day).to_s
        click_button 'Spara'

        expect(current_path).to eq person_placement_path(person, placement)
        expect(page).to have_selector('.warning', text: 'måste vara senare än inskrivningen')
      end
    end
  end
end
