RSpec.describe 'RefugeeExtraCost', type: :feature do
  describe 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    describe 'Adds refugee_extra_cost' do
      scenario 'for a refugee' do
        refugee = create(:refugee)

        visit "/refugees/#{refugee.id}"
        click_on 'Ny extra kostnad'
        expect(current_path).to eq new_refugee_refugee_extra_cost_path(refugee)

        fill_in 'refugee_extra_cost_date', with: Date.today.to_s
        fill_in 'refugee_extra_cost_amount', with: 1234
        fill_in 'refugee_extra_cost_comment', with: 'Foo bar'
        click_button 'Spara'

        expect(current_path).to eq refugee_path(refugee)
        expect(page).to have_selector('.notice', text: 'Extra kostnaden registrerades')
      end
    end

    describe 'Edit refugee_extra_cost' do
      scenario 'for a refugee' do
        refugee = create(:refugee)
        create(:refugee_extra_cost, refugee: refugee)

        visit "/refugees/#{refugee.id}"
        click_link('Redigera extra kostnaden')
        expect(current_path).to eq edit_refugee_refugee_extra_cost_path(refugee, refugee.refugee_extra_costs.first)

        fill_in 'refugee_extra_cost_date', with: Date.today.to_s
        fill_in 'refugee_extra_cost_amount', with: 321
        fill_in 'refugee_extra_cost_comment', with: 'Fox barx'
        click_button 'Spara'

        expect(current_path).to eq refugee_path(refugee)
        expect(page).to have_selector('.notice', text: 'Extra kostnaden uppdaterades')
      end
    end
  end
end
