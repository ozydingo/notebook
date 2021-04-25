class Logout
  def initialize(app)
    @app = app
  end

  def call(env)
    ['401', {'Content-Type' => 'text/html'}, ["Logged out."]]
  end
end
