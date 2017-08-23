require "erb"
require "pp"
require "pry"

class MyRackApp
  def call(env)
    # binding.pry
    case env["PATH_INFO"]
    when '/'
      response(
        '200',
        {page_title: "Welcome Page",
          header: "Welcome",
          content: "button"})
    when '/login'
      if env["REQUEST_METHOD"] == "GET"
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
      else
        response(
          '302',
          {
            page_title: "Dashboard",
            header: "Dashboard",
            content: "hello user"
          },
          {"Location" => "/dashboard"})
      end
    else
      response(
        '404',
        {page_title: "Error Page",
          header: "Error",
          content: "error"})
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
