RSpec.feature 'Owner types', type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'adds a owner_type' do
      visit '/owner_types/new'
      fill_in 'owner_type_name', with: 'Foo'
      click_button 'Spara'

      expect(current_path).to eq owner_types_path
      expect(page).to have_selector('.notice', text: 'skapades')
    end

    scenario 'updates a owner_type' do
      owner_type = create(:owner_type, name: 'Foo')
      visit edit_owner_type_path(owner_type)
      fill_in 'owner_type_name', with: 'Bar'
      click_button 'Spara'

      expect(current_path).to eq owner_types_path
      expect(page).to have_selector('.notice', text: 'uppdaterades')
      expect(page).not_to have_selector('td', text: 'Foo')
      expect(page).to have_selector('td', text: 'Bar')
    end

    scenario 'deletes a owner_type', js: true do
      create(:owner_type, name: 'Fox')
      visit '/owner_types'
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

    scenario "can't add a owner_type" do
      visit '/owner_types/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't add a owner_type" do
      visit '/owner_types/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
