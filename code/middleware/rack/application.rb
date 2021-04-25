class Application
  def call(env)
    body = File.read("./index.html")
    ['200', {'Content-Type' => 'text/html'}, [body]]
  end
end
