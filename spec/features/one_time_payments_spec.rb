RSpec.feature 'OneTimePayment', type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'adds a one_time_payment' do
      visit '/one_time_payments/new'
      fill_in 'one_time_payment_amount', with: 321
      fill_in 'one_time_payment_start_date', with: '2019-01-01'
      fill_in 'one_time_payment_end_date', with: '2019-12-31'
      click_button 'Spara'

      expect(current_path).to eq one_time_payments_path
      expect(page).to have_selector('.notice', text: 'skapades')
    end

    scenario 'one_time_payment' do
      one_time_payment = create(:one_time_payment)
      visit edit_one_time_payment_path(one_time_payment)
      fill_in 'one_time_payment_amount', with: 234
      click_button 'Spara'

      expect(current_path).to eq one_time_payments_path
      expect(page).to have_selector('.notice', text: 'uppdaterades')
      expect(page).to have_selector('td', text: '234')
    end

    scenario 'deletes a one_time_payment', js: true do
      create(:one_time_payment)
      visit '/one_time_payments'
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

    scenario 'can’t add a one_time_payment' do
      visit '/one_time_payments/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario 'can’t add a one_time_payment' do
      visit '/one_time_payments/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
