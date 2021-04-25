class Main
  def call(env)
    body = File.read("ui/build/index.html")
    return [200, {"Content-Type" => "text/html"}, [body]]
  end
end
