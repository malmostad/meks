RSpec.feature 'Target groups', type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'adds a target_group' do
      visit '/target_groups/new'
      fill_in 'target_group_name', with: 'Foo'
      click_button 'Spara'

      expect(current_path).to eq target_groups_path
      expect(page).to have_selector('.notice', text: 'skapades')
    end

    scenario 'updates a target_group' do
      target_group = create(:target_group, name: 'Foo')
      visit edit_target_group_path(target_group)
      fill_in 'target_group_name', with: 'Bar'
      click_button 'Spara'

      expect(current_path).to eq target_groups_path
      expect(page).to have_selector('.notice', text: 'uppdaterades')
      expect(page).not_to have_selector('td', text: 'Foo')
      expect(page).to have_selector('td', text: 'Bar')
    end

    scenario 'deletes a target_group', js: true do
      target_group = create(:target_group, name: 'Fox')
      visit '/target_groups'
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

    scenario "can't add a target_group" do
      visit '/target_groups/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't add a target_group" do
      visit '/target_groups/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
