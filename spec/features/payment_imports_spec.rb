RSpec.feature PaymentImport, type: :feature do
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario 'uploads a valid payment file' do
      create(:person,
             dossier_number: '8254980244',
             municipality: create(:municipality, our_municipality: true)
      )

      visit '/payment_imports'
      click_link 'Lägg till'
      expect(current_path).to eq new_payment_import_path

      attach_file('payment_import[file]', File.join(fixture_path, 'payments.csv'))

      click_button 'Spara'
      expect(current_path).to eq payment_imports_path
      expect(page).to have_selector('.notice', text: 'Importen sparades')
    end

    scenario 'deletes an import', js: true do
      payment_import = create(:payment_import)
      visit '/payment_imports'

      click_link 'Visa'
      expect(current_path).to eq payment_import_path(payment_import.id)

      accept_alert do
        click_button 'Radera permanent'
      end

      expect(page).to have_selector('.notice', text: 'raderades')
    end
  end

  feature 'reader role' do
    before(:each) do
      login_user(:reader)
    end

    scenario 'can’t add a language' do
      visit '/payment_imports'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario 'can’t add a language' do
      visit '/payment_imports'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
