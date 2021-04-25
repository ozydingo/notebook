class RackHeader
  def initialize(app)
    @app = app
  end

  def call(env)
    code, headers, response = @app.call(env)
    headers["X-Rack"] = "yes"
    return code, headers, response
  end
end
