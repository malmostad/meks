RSpec.describe "Users", type: :feature do
  describe "admin role" do
    before(:each) do
      login_user(:admin)
    end

    scenario "visit the user list page" do
      visit "/users"

      expect(current_path).to eq users_path
      expect(page).to have_selector("h1", text: "Handläggare")
    end
  end

  describe "writer role" do
    before(:each) do
      login_user(:writer)
    end

    scenario "visit the user list page" do
      visit "/users"

      expect(current_path).to eq users_path
      expect(page).to have_selector("h1", text: "Handläggare")
    end
  end

  describe "reader role" do
    before(:each) do
      login_user(:reader)
    end

    scenario "visit the user list page" do
      visit "/users"

      expect(current_path).to eq users_path
      expect(page).to have_selector("h1", text: "Handläggare")
    end
  end
end
