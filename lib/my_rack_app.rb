require "erb"
require "pry"

class Responder
  def response(code, vars, headers = {})
    [
      code,
      {'Content-Type' => 'text/html'}.merge(headers),
      [ERB.new(File.read(__dir__ + "/../views/layout.erb")).result_with_hash(vars)]
    ]
  end
end

class BaseController
  def initialize(responder, env)
    @responder = responder
    @env = env
  end

  def response(*args)
    @responder.response(*args)
  end
end

class WelcomeController < BaseController
  def get
    response(
      '200',
      {page_title: "Welcome Page",
        header: "Welcome",
        content: "button"})
  end
end

class LoginController < BaseController

  def initialize(responder, env, db)
    @db = db
    super(responder, env)
  end

  def get
    req = Rack::Request.new(@env)
    welcome = req.params["welcome"]
    response(
      '200',
      {page_title: "Login Page",
        header: "Login",
        content: <<-HTML})
      #{ "Successfully signed up! Please log in using the form below:" if welcome }
      <form action="/login" method="POST">
      <label for="username">Username</label>
      <input type="text" name="username" id="username">
      <label for="password">Password</label>
      <input type="password" name="password" id="password">
      <input type="submit" value="Submit">
      </form>
      HTML
  end

  def post
    rack_response = Rack::Response.new
    rack_response.redirect("/dashboard")
    rack_response.finish
    # response(
    #   '302',
    #   {
    #     page_title: "Dashboard",
    #     header: "Dashboard",
    #     content: "hello user"
    #   },
    #   {"Location" => "/dashboard"})
  end
end

class SignupController < BaseController

  def initialize(responder, env, db)
    @db = db
    super(responder, env)
  end

  def get
    response(
      '200',
      {
        page_title: "Signup",
        header: "Signup",
        content: <<-HTML})
      <form action="/signup" method="POST">
      <label for="username">Username</label>
      <input type="text" name="username" id="username">
      <label for="password">Password</label>
      <input type="password" name="password" id="password">
      <input type="submit" value="Submit">
      </form>
    HTML
  end

  def post
    rack_response = Rack::Response.new
    rack_response.redirect("/login?welcome=true")
    rack_response.finish
    req = Rack::Request.new(@env)
    username, password = req.params.values_at("username", "password")
    @db[:users] << {username: username, password: password}
    # response(
    #   '201',
    #   {
    #     page_title: "Success",
    #     header: "Success",
    #     content: "Successfully signed up! Please log in using the form below:"})

  end

end

class DashboardController < BaseController
  def get
      response(
      '200',
      {
        page_title: "Dashboard",
        header: "Dashboard",
        content: "Hello user!"
      })
  end
end

class ErrorController < BaseController
  def get
    response(
      '404',
      {page_title: "Error Page",
        header: "Error",
        content: "error"})
  end
end

class MyRackApp
  def initialize(db)
    @db = db
  end

  def call(env)
    responder = Responder.new
    login_controller = LoginController.new(responder, env, @db)
    dashboard_controller = DashboardController.new(responder, env)
    welcome_controller = WelcomeController.new(responder, env)
    error_controller = ErrorController.new(responder, env)
    signup_controller = SignupController.new(responder, env, @db)

    routes = {
      '/' => welcome_controller,
      '/login' => login_controller,
      '/dashboard' => dashboard_controller,
      '/signup' => signup_controller
    }

    controller = routes.fetch(env["PATH_INFO"], error_controller)
    controller.public_send(env["REQUEST_METHOD"].downcase)
  end
end
