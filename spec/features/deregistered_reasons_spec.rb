RSpec.feature 'Deregistered reasons', type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'adds a deregistered_reason' do
      visit '/deregistered_reasons/new'
      fill_in 'deregistered_reason_name', with: 'Foo'
      click_button 'Spara'

      expect(current_path).to eq deregistered_reasons_path
      expect(page).to have_selector('.notice', text: 'skapades')
    end

    scenario 'updates a deregistered_reason' do
      deregistered_reason = create(:deregistered_reason, name: 'Foo')
      visit edit_deregistered_reason_path(deregistered_reason)
      fill_in 'deregistered_reason_name', with: 'Bar'
      click_button 'Spara'

      expect(current_path).to eq deregistered_reasons_path
      expect(page).to have_selector('.notice', text: 'uppdaterades')
      expect(page).not_to have_selector('td', text: 'Foo')
      expect(page).to have_selector('td', text: 'Bar')
    end

    scenario 'deletes a deregistered_reason', js: true do
      deregistered_reason = create(:deregistered_reason, name: 'Fox')
      visit '/deregistered_reasons'
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

    scenario "can't add a deregistered_reason" do
      visit '/deregistered_reasons/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't add a deregistered_reason" do
      visit '/deregistered_reasons/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
