class Users
  def initialize(app)
    @app = app
  end

  def call(env)
    Rails.logger.info("In Users middleware")
    Rails.logger.info(User.count)
    @app.call(env)
  end
end
