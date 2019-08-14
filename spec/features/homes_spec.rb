RSpec.feature 'Homes', type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'adds a home' do
      visit '/homes'
      first('.btn-primary', text: 'Lägg till').click
      fill_in 'home_name', with: 'Foo'
      click_button 'Spara'

      expect(current_path).to eq home_path(Home.last)
      expect(page).to have_selector('.notice', text: 'skapades')
    end

    scenario 'updates a home' do
      home = create(:home, name: 'Foo')
      visit '/homes'
      click_link home.name
      click_link 'Redigera'
      fill_in 'home_name', with: 'Bar'
      click_button 'Spara'

      expect(current_path).to eq home_path(home)
      expect(page).to have_selector('.notice', text: 'uppdaterades')
      expect(page).to have_selector('.controls', text: 'Bar')
    end
  end

  feature 'reader role' do
    before(:each) do
      login_user(:reader)
    end

    scenario "can't add a home" do
      visit '/homes/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't add a home" do
      visit '/homes/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
