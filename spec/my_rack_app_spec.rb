require 'rack/test'
require 'my_rack_app'
require 'pry'

describe MyRackApp do
  include Rack::Test::Methods

  def app
    MyRackApp.new
  end

  xdescribe "/" do
    it "renders the homepage at /" do
      get '/'
      expect(last_response).to be_ok
    end

    it "shows welcome message" do
      get '/'
      expect(last_response.body).to include("Welcome")
    end
  end

  describe "/login" do
    xit "renders the login page at /login" do
      get '/login'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Login")
    end

    context "when the user posts correct credentials" do
      it "takes the user to the dashboard" do
        post('/login', "username" => "hello@gmail.com", "password" => "hello1")
        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq("/dashboard")
        expect(last_response.body).to include("hello user")
        # expect(last_response.headers).to eq("Dashboard")
      end
    end

    context "when the user posts incorrect credentials" do
      it "re-renders the form and lets the user know there was an error"

    end
  end


  xit "return 404 when we go to any other page" do
    get '/fjdl'
    expect(last_response.status).to eq(404)
  end
end
