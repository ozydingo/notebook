class Pong
  def initialize(app)
    @app = app
  end

  def call(env)
    return [200, {'Content-Type' => 'text/html'}, ["PONG!!!"]] if params(env).key?("pong")

    @app.call(env)
  end

  def params(env)
    Rack::Utils.parse_nested_query(env["QUERY_STRING"])
  end
end
