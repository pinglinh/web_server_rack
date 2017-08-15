class MyRackApp
  def call(env)
    case env["PATH_INFO"]
    when '/'
      response('200', 'Welcome')
    when '/login'
      response('200', "Login")
    else
      response('404', 'Not found')
    end
  end

  def response(code, body)
    [
      code,
      {'Content-Type' => 'text/html'},
      [body]
    ]
  end

end
