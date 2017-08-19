require "erb"

class MyRackApp
  def call(env)
    case env["PATH_INFO"]
    when '/'
      response('200', {page_title: "Welcome Page", header: "Welcome", content: "button"})
    when '/login'
      response('200', {page_title: "Login Page", header: "Login", content: "login-form"})
    else
      response('404', {page_title: "Error Page", header: "Error", content: "error"})
    end
  end

  def response(code, vars)
    [
      code,
      {'Content-Type' => 'text/html'},
      [ERB.new(File.read(__dir__ + "/../views/layout.erb")).result_with_hash(vars)]
    ]
  end

end
