require 'yaml'

class MyRackApp
  def call(env)
    if env["PATH_INFO"] == '/'
      ['200',
      {'Content-Type' => 'text/html'},
      ["Welcome"]]
    elsif env["PATH_INFO"] == '/login'
      ['200',
      {'Content-Type' => 'text/html'},
      ["Login"]]
    else
      ['404',
      {'Content-Type' => 'text/html'},
      ["Not found"]]
    end
  end
end
