RSpec.feature 'Countries', type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'adds a country' do
      visit '/countries/new'
      fill_in 'country_name', with: 'Foo'
      click_button 'Spara'

      expect(current_path).to eq countries_path
      expect(page).to have_selector('.notice', text: 'skapades')
    end

    scenario 'updates a country' do
      country = create(:country, name: 'Foo')
      visit edit_country_path(country)
      fill_in 'country_name', with: 'Bar'
      click_button 'Spara'

      expect(current_path).to eq countries_path
      expect(page).to have_selector('.notice', text: 'uppdaterades')
      expect(page).not_to have_selector('td', text: 'Foo')
      expect(page).to have_selector('td', text: 'Bar')
    end

    scenario 'deletes a country', js: true do
      country = create(:country, name: 'Fox')
      visit '/countries'
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

    scenario "can't add a country" do
      visit '/countries/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't add a country" do
      visit '/countries/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
