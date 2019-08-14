RSpec.feature 'Type of housings', type: :feature do
  # Ability is currently disabled
  feature 'admin role' do
    before(:each) do
      login_user(:admin)
    end

    scenario "can't add a type_of_housing" do
      visit '/type_of_housings/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  # feature "admin role" do
  #   before(:each) do
  #     login_user(:admin)
  #   end
  #
  #   scenario "adds a type_of_housing" do
  #     visit "/type_of_housings/new"
  #     fill_in "type_of_housing_name", with: "Foo"
  #     click_button "Spara"
  #
  #     expect(current_path).to eq type_of_housings_path
  #     expect(page).to have_selector(".notice", text: "skapades")
  #   end
  #
  #   scenario "updates a type_of_housing" do
  #     type_of_housing = create(:type_of_housing, name: "Foo")
  #     visit edit_type_of_housing_path(type_of_housing)
  #     fill_in "type_of_housing_name", with: "Bar"
  #     click_button "Spara"
  #
  #     expect(current_path).to eq type_of_housings_path
  #     expect(page).to have_selector(".notice", text: "uppdaterades")
  #     expect(page).not_to have_selector("td", text: "Foo")
  #     expect(page).to have_selector("td", text: "Bar")
  #   end
  #
  #   scenario "deletes a type_of_housing", js: true do
  #     type_of_housing = create(:type_of_housing, name: "Fox")
  #     visit "/type_of_housings"
  #     page.accept_alert 'Är du säker?' do
  #       first(".btn-danger").click
  #     end
  #     expect(page).to have_selector(".notice", text: "raderades")
  #   end
  # end

  feature 'reader role' do
    before(:each) do
      login_user(:reader)
    end

    scenario "can't add a type_of_housing" do
      visit '/type_of_housings/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end

  feature 'writer role' do
    before(:each) do
      login_user(:writer)
    end

    scenario "can't add a type_of_housing" do
      visit '/type_of_housings/new'

      expect(current_path).to eq root_path
      expect(page).to have_selector('.alert', text: 'Din roll saknar behörighet')
    end
  end
end
