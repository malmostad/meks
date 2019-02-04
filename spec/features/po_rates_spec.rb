RSpec.feature 'PoRates', type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'adds a po_rate' do
      visit '/po_rates/new'
      fill_in 'po_rate_rate_under_65', with: 30.74
      fill_in 'po_rate_rate_between_65_and_81', with: 31.74
      fill_in 'po_rate_rate_from_82', with: 2.12
      fill_in 'po_rate_start_date', with: '2019-01-01'
      fill_in 'po_rate_end_date', with: '2019-12-31'
      click_button 'Spara'

      expect(current_path).to eq po_rates_path
      expect(page).to have_selector('.notice', text: 'skapades')
    end

    scenario 'updates a po_rate' do
      po_rate = create(:po_rate)
      visit edit_po_rate_path(po_rate)
      fill_in 'po_rate_rate_under_65', with: 32.74
      click_button 'Spara'

      expect(current_path).to eq po_rates_path
      expect(page).to have_selector('.notice', text: 'uppdaterades')
      expect(page).to have_selector('td', text: '32,74')
    end

    scenario 'deletes a po_rate', js: true do
      create(:po_rate)
      visit '/po_rates'
      page.accept_alert 'Är du säker?' do
        first('.btn-danger').click
      end

      expect(page).to have_selector('.notice', text: 'raderades')
    end
  end

  feature 'reader role' do
    before(:each) do
      login_user(:reader)
    end

    scenario 'can’t add a po_rate' do
      visit '/po_rates/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario 'can’t add a po_rate' do
      visit '/po_rates/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
