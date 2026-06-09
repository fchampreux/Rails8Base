RSpec.describe "User Login", type: :system, js: true do
    let!(:user) { create(:user, password: "Password123!") }
  
    it "logs in successfully" do
      visit new_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "Password123!"
      click_button "Log in"
  
      expect(page).to have_content("Dashboard")
    end
  end