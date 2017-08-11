require 'rack/test'
require 'my_rack_app'

describe MyRackApp do
  include Rack::Test::Methods

  def app
    MyRackApp.new
  end

  it "renders the homepage at /" do
    get '/'
    expect(last_response).to be_ok
  end

  it "shows welcome message" do
    get '/'
    expect(last_response.body).to include("Welcome")
  end

  it "renders the login page at /
  login" do
    get '/login'
    expect(last_response.body).to include("Login")
  end

  it "return 404 when we go to any other page" do
    get '/fjdl'
    expect(last_response.status).to eq(404)
  end
end



# require 'rack'
# require 'yaml'

# app = Proc.new do |env|
#     ['200', {'Content-Type' => 'text/html'}, ['A barebones rack app.', env.to_yaml]]
# end

# Rack::Handler::WEBrick.run app
