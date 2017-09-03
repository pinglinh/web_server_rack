require "my_rack_app"
require "capybara/rspec"

Capybara.app = MyRackApp.new

describe "the signup process" do
  include Capybara::DSL

  it "allows user to sign up and log in with the same credentials" do
    visit "/signup"
    fill_in "Username", with: "example@email.com"
    fill_in "Password", with: "password"
    click_button "Submit"
    expect(page).to have_content "Success"
  end
end
