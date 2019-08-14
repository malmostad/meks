RSpec.feature 'Municipalities', type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'adds a municipality' do
      visit '/municipalities/new'
      fill_in 'municipality_name', with: 'Foo'
      click_button 'Spara'

      expect(current_path).to eq municipalities_path
      expect(page).to have_selector('.notice', text: 'skapades')
    end

    scenario 'updates a municipality' do
      municipality = create(:municipality, name: 'Foo')
      visit edit_municipality_path(municipality)
      fill_in 'municipality_name', with: 'Bar'
      click_button 'Spara'

      expect(current_path).to eq municipalities_path
      expect(page).to have_selector('.notice', text: 'uppdaterades')
      expect(page).not_to have_selector('td', text: 'Foo')
      expect(page).to have_selector('td', text: 'Bar')
    end

    scenario 'deletes a municipality', js: true do
      municipality = create(:municipality, name: 'Fox')
      visit '/municipalities'
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

    scenario "can't add a municipality" do
      visit '/municipalities/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't add a municipality" do
      visit '/municipalities/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
