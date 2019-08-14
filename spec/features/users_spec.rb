RSpec.feature 'Users', type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'visit the user list page' do
      visit '/users'

      expect(current_path).to eq users_path
      expect(page).to have_selector('h1', text: 'Handläggare')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario 'visit the user list page' do
      visit '/users'

      expect(current_path).to eq users_path
      expect(page).to have_selector('h1', text: 'Handläggare')
    end
  end

  feature 'reader role' do
    before(:each) do
      login_user(:reader)
    end

    scenario 'visit the user list page' do
      visit '/users'

      expect(current_path).to eq users_path
      expect(page).to have_selector('h1', text: 'Handläggare')
    end
  end
end
