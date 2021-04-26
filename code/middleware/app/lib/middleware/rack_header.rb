class RackHeader
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    code, headers, response = @app.call(env)
    headers["X-Rack"] = "yes" if req.params.key?("rack")
    return code, headers, response
  end
end
