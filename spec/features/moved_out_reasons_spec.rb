RSpec.feature 'Moved out reasons', type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'adds a moved_out_reason' do
      visit '/moved_out_reasons/new'
      fill_in 'moved_out_reason_name', with: 'Foo'
      click_button 'Spara'

      expect(current_path).to eq moved_out_reasons_path
      expect(page).to have_selector('.notice', text: 'skapades')
    end

    scenario 'updates a moved_out_reason' do
      moved_out_reason = create(:moved_out_reason, name: 'Foo')
      visit edit_moved_out_reason_path(moved_out_reason)
      fill_in 'moved_out_reason_name', with: 'Bar'
      click_button 'Spara'

      expect(current_path).to eq moved_out_reasons_path
      expect(page).to have_selector('.notice', text: 'uppdaterades')
      expect(page).not_to have_selector('td', text: 'Foo')
      expect(page).to have_selector('td', text: 'Bar')
    end

    scenario 'deletes a moved_out_reason', js: true do
      moved_out_reason = create(:moved_out_reason, name: 'Fox')
      visit '/moved_out_reasons'
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

    scenario "can't add a moved_out_reason" do
      visit '/moved_out_reasons/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't add a moved_out_reason" do
      visit '/moved_out_reasons/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
