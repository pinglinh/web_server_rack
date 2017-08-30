require "erb"

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
  def initialize(responder)
    @responder = responder
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
  def get
    response(
      '200',
      {page_title: "Login Page",
        header: "Login",
        content: <<-HTML})
      <form action="/login" method="POST">
      <label for="username">Username</label>
      <input type="text" name="username" id="username">
      <label for="password">Password</label>
      <input type="password" name="password" id="password">
      <input type="submit">
      </form>
      HTML
  end

  def post
    response(
      '302',
      {
        page_title: "Dashboard",
        header: "Dashboard",
        content: "hello user"
      },
      {"Location" => "/dashboard"})
  end
end

class DashboardController < BaseController
  def get
    response(
      '200',
      {
        page_title: "Dashboard",
        header: "Dashboard",
        content: "hello user"
      },
      {"Location" => "/dashboard"})
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
  def call(env)
    responder = Responder.new
    login_controller = LoginController.new(responder)
    dashboard_controller = DashboardController.new(responder)
    welcome_controller = WelcomeController.new(responder)
    error_controller = ErrorController.new(responder)

    routes = {
      '/' => welcome_controller,
      '/login' => login_controller,
      '/dashboard' => dashboard_controller,
    }

    controller = routes.fetch(env["PATH_INFO"], error_controller)
    controller.public_send(env["REQUEST_METHOD"].downcase)

    # case env["PATH_INFO"]
    # when '/'
    #   welcome_controller.get
    # when '/login'
    #   if env["REQUEST_METHOD"] == "GET"
    #     login_controller.get
    #   else
    #     login_controller.post
    #   end
    # when '/dashboard'
    #   dashboard_controller.get
    # else
    #   error_controller.get
    # end
  end
end
