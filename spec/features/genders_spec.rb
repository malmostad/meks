RSpec.feature 'Genders', type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'adds a gender' do
      visit '/genders/new'
      fill_in 'gender_name', with: 'Foo'
      click_button 'Spara'

      expect(current_path).to eq genders_path
      expect(page).to have_selector('.notice', text: 'skapades')
    end

    scenario 'updates a gender' do
      gender = create(:gender, name: 'Foo')
      visit edit_gender_path(gender)
      fill_in 'gender_name', with: 'Bar'
      click_button 'Spara'

      expect(current_path).to eq genders_path
      expect(page).to have_selector('.notice', text: 'uppdaterades')
      expect(page).not_to have_selector('td', text: 'Foo')
      expect(page).to have_selector('td', text: 'Bar')
    end

    scenario 'deletes a gender', js: true do
      gender = create(:gender, name: 'Fox')
      visit '/genders'
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

    scenario "can't add a gender" do
      visit '/genders/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't add a gender" do
      visit '/genders/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
