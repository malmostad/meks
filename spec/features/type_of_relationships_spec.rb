RSpec.feature 'Type of relationships', type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'adds a type_of_relationship' do
      visit '/type_of_relationships/new'
      fill_in 'type_of_relationship_name', with: 'Foo'
      click_button 'Spara'

      expect(current_path).to eq type_of_relationships_path
      expect(page).to have_selector('.notice', text: 'skapades')
    end

    scenario 'updates a type_of_relationship' do
      type_of_relationship = create(:type_of_relationship, name: 'Foo')
      visit edit_type_of_relationship_path(type_of_relationship)
      fill_in 'type_of_relationship_name', with: 'Bar'
      click_button 'Spara'

      expect(current_path).to eq type_of_relationships_path
      expect(page).to have_selector('.notice', text: 'uppdaterades')
      expect(page).not_to have_selector('td', text: 'Foo')
      expect(page).to have_selector('td', text: 'Bar')
    end

    scenario 'deletes a type_of_relationship', js: true do
      type_of_relationship = create(:type_of_relationship, name: 'Fox')
      visit '/type_of_relationships'
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

    scenario "can't add a type_of_relationship" do
      visit '/type_of_relationships/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't add a type_of_relationship" do
      visit '/type_of_relationships/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
