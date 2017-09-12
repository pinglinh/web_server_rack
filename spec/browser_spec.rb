require "my_rack_app"
require "capybara/rspec"
require "pry"

Capybara.app = MyRackApp.new

describe "the signup process" do
  include Capybara::DSL

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
    expect(page).to have_current_path("/dashboard?login=true")
    expect(page).to have_content "Hello user!"
  end
end
