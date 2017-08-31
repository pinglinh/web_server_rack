require 'rack/test'
require 'my_rack_app'
require 'pry'

describe MyRackApp do
  include Rack::Test::Methods

  def app
    MyRackApp.new
  end

  describe "/" do
    it "renders the homepage at /" do
      get '/'
      expect(last_response).to be_ok
    end

    it "shows welcome message" do
      get '/'
      expect(last_response.body).to include("Welcome")
    end
  end

  describe "signing up" do
    it "renders the signup page" do
      get "/signup"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Sign up")
    end
  end

  describe "logging in" do
    it "renders the login page at /login" do
      get '/login'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Login")
    end

    context "when the user posts correct credentials" do
      it "takes the user to the dashboard" do
        post('/login', "username" => "hello@gmail.com", "password" => "hello1")
        follow_redirect!
        expect(last_response.body).to include("hello user")
      end
    end

    context "when the user posts incorrect credentials" do
      it "re-renders the form and lets the user know there was an error"

    end
  end

  it "return 404 when we go to any other page" do
    get '/fjdl'
    expect(last_response.status).to eq(404)
  end
end
