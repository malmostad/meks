RSpec.feature 'Report', type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'queue a report' do
      visit '/reports'
      first(:button, 'Skapa rapport').click
      expect(page).to have_selector('p', text: 'Det kan ta flera minuter att skapa din rapport')
    end
  end

  feature 'reader role' do
    before(:each) do
      login_user(:reader)
    end

    scenario "can't access reports" do
      visit '/reports'
      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario 'can access reports' do
      visit '/reports'

      expect(current_path).to eq reports_path
      expect(page).to have_selector('h1', text: 'Generera rapporter')
    end
  end
end
