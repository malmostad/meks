RSpec.feature 'Rate Category', type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'updates a rate_category', js: true do
      rate_category = create(:rate_category, name: 'Foo')
      visit edit_rate_category_path(rate_category)
      click_button 'Lägg till belopp'
      expect(page).to have_selector('input.integer[placeholder=kronor]')
      expect(page).to have_selector('input.date[placeholder=startdatum]')
      expect(page).to have_selector('input.date[placeholder=slutdatum]')
    end
  end

  feature 'reader role' do
    before(:each) do
      login_user(:reader)
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't edit a rate_category" do
      rate_category = create(:rate_category)
      visit edit_rate_category_path(rate_category)
      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
