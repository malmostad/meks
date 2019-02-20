RSpec.feature 'RefugeeExtraCost', type: :feature do
  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    feature 'Adds refugee_extra_cost' do
      scenario 'reload the form with validation message' do
        refugee = create(:refugee)

        visit "/refugees/#{refugee.id}/show_costs"
        click_on 'Ny extra kostnad'
        expect(current_path).to eq new_refugee_refugee_extra_cost_path(refugee)

        fill_in 'refugee_extra_cost_date', with: Date.today.to_s
        fill_in 'refugee_extra_cost_amount', with: ''
        fill_in 'refugee_extra_cost_comment', with: 'Foo bar'
        click_button 'Spara'

        expect(current_path).to eq refugee_refugee_extra_costs_path(refugee)
        expect(page).to have_selector('.warning', text: 'Vänligen korrigera nedanstående markerade uppgifter.')
        expect(page).to have_selector('.help-block', text: 'måste anges')
      end

      scenario 'saves the form' do
        refugee = create(:refugee)

        visit "/refugees/#{refugee.id}/show_costs"
        click_on 'Ny extra kostnad'
        expect(current_path).to eq new_refugee_refugee_extra_cost_path(refugee)

        fill_in 'refugee_extra_cost_date', with: Date.today.to_s
        fill_in 'refugee_extra_cost_amount', with: 1234
        fill_in 'refugee_extra_cost_comment', with: 'Foo bar'
        click_button 'Spara'

        expect(current_path).to eq refugee_show_costs_path(refugee)
        expect(page).to have_selector('.notice', text: 'Extra kostnaden registrerades')
      end
    end

    feature 'Edit refugee_extra_cost' do
      scenario 'for a refugee' do
        refugee = create(:refugee)
        create(:refugee_extra_cost, refugee: refugee)

        visit "/refugees/#{refugee.id}/show_costs"
        click_link('Redigera extra kostnaden')
        expect(current_path).to eq edit_refugee_refugee_extra_cost_path(refugee, refugee.refugee_extra_costs.first)

        fill_in 'refugee_extra_cost_date', with: Date.today.to_s
        fill_in 'refugee_extra_cost_amount', with: 321
        fill_in 'refugee_extra_cost_comment', with: 'Fox barx'
        click_button 'Spara'

        expect(current_path).to eq refugee_show_costs_path(refugee)
        expect(page).to have_selector('.notice', text: 'Extra kostnaden uppdaterades')
      end
    end
  end

  feature 'reader role' do
    before(:each) do
      login_user(:reader)
    end

    scenario "can't add an extra cost" do
      refugee = create(:refugee)

      visit "/refugees/#{refugee.id}/refugee_extra_costs/new"

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
