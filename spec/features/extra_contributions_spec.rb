RSpec.describe 'ExtraContributions', type: :feature do
  describe 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    describe 'Adds extra_contribution' do
      scenario 'for a refugee' do
        refugee = create(:refugee)
        extra_contribution_types = create_list(:extra_contribution_type, 3)

        visit "/refugees/#{refugee.id}"
        click_on 'Ny extra insats'
        expect(current_path).to eq new_refugee_extra_contribution_path(refugee)

        select(extra_contribution_types[1].name, from: 'extra_contribution_extra_contribution_type_id')
        fill_in 'extra_contribution_period_start', with: Date.today.to_s
        fill_in 'extra_contribution_period_end', with: (Date.today + 1.year).to_s
        fill_in 'extra_contribution_fee', with: 1234
        fill_in 'extra_contribution_expense', with: 2345
        click_button 'Spara'

        expect(current_path).to eq refugee_path(refugee)
        expect(page).to have_selector('.notice', text: 'Extra insatsen registrerades')
        expect(page).to have_selector('.extra_contribution .controls', text: extra_contribution_types[1].name)
      end
    end

    describe 'Edit extra_contribution' do
      scenario 'for a refugee' do
        refugee = create(:refugee)
        extra_contribution_types = create_list(:extra_contribution_type, 3)
        create(:extra_contribution, refugee: refugee, extra_contribution_type: extra_contribution_types.first)

        visit "/refugees/#{refugee.id}"
        click_link('Redigera extra insatsen')
        expect(current_path).to eq edit_refugee_extra_contribution_path(refugee, refugee.extra_contributions.first)

        select(extra_contribution_types[2].name, from: 'extra_contribution_extra_contribution_type_id')
        fill_in 'extra_contribution_period_start', with: Date.today.to_s
        fill_in 'extra_contribution_period_end', with: (Date.today + 2.year).to_s
        fill_in 'extra_contribution_fee', with: 321
        fill_in 'extra_contribution_expense', with: 123
        click_button 'Spara'

        expect(current_path).to eq refugee_path(refugee)
        expect(page).to have_selector('.notice', text: 'Extra insatsen uppdaterades')
        expect(page).to have_selector('.extra_contribution .controls', text: extra_contribution_types[2].name)
      end
    end
  end
end
