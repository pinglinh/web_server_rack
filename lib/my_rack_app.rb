require "erb"
require "pp"
require "pry"

class WelcomeController
  def get
    response(
      '200',
      {page_title: "Welcome Page",
        header: "Welcome",
        content: "button"})
  end

  def response(code, vars, headers = {})
    [
      code,
      {'Content-Type' => 'text/html'}.merge(headers),
      [ERB.new(File.read(__dir__ + "/../views/layout.erb")).result_with_hash(vars)]
    ]
  end
end

class LoginController
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

  def response(code, vars, headers = {})
    [
      code,
      {'Content-Type' => 'text/html'}.merge(headers),
      [ERB.new(File.read(__dir__ + "/../views/layout.erb")).result_with_hash(vars)]
    ]
  end
end

class DashboardController
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

  def response(code, vars, headers = {})
    [
      code,
      {'Content-Type' => 'text/html'}.merge(headers),
      [ERB.new(File.read(__dir__ + "/../views/layout.erb")).result_with_hash(vars)]
    ]
  end
end

class ErrorController
  def get
    response(
      '404',
      {page_title: "Error Page",
        header: "Error",
        content: "error"})
  end

  def response(code, vars, headers = {})
    [
      code,
      {'Content-Type' => 'text/html'}.merge(headers),
      [ERB.new(File.read(__dir__ + "/../views/layout.erb")).result_with_hash(vars)]
    ]
  end
end

class MyRackApp
  def call(env)
    login_controller = LoginController.new
    dashboard_controller = DashboardController.new
    welcome_controller = WelcomeController.new
    error_controller = ErrorController.new

    case env["PATH_INFO"]
    when '/'
      welcome_controller.get
    when '/login'
      if env["REQUEST_METHOD"] == "GET"
        login_controller.get
      else
        login_controller.post
      end
    when '/dashboard'
      dashboard_controller.get
    else
      error_controller.get
    end
  end

  def response(code, vars, headers = {})
    [
      code,
      {'Content-Type' => 'text/html'}.merge(headers),
      [ERB.new(File.read(__dir__ + "/../views/layout.erb")).result_with_hash(vars)]
    ]
  end

end
