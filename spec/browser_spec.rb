require "my_rack_app"
require "capybara/rspec"
require "pry"

db = {
  users: []
}
Capybara.app = MyRackApp.new(db)

describe "the signup process" do
  include Capybara::DSL

  before do
    db[:users].clear
  end

  it "allows user to sign up and log in with the same credentials" do
    visit "/signup"
    fill_in "Username", with: "example@email.com"
    fill_in "Password", with: "password"
    click_button "Submit"
    expect(page).to have_current_path("/login?welcome=true")
    expect(page).to have_content "Successfully signed up! Please log in using the form below:"
    fill_in "Username", with: "example@email.com"
    fill_in "Password", with: "password"
    click_button "Submit"
    expect(page).to have_current_path("/dashboard")
    expect(page).to have_content "Hello user!"
  end

  it "rejects logins from users that haven't signed up" do
    visit "/login"
    fill_in "Username", with: "example@email.com"
    fill_in "Password", with: "password"
    click_button "Submit"
    expect(page).to have_content "Invalid credentials"
  end

  it "prevents non-users from going to the dashboard" do
    visit "/dashboard"
    expect(page).to have_current_path("/login")
  end
end
