module MiddleView
  class MiddleView
    def initialize(app = nil)
      @app = app
    end

    def call(env)
      Rack::Static.new(@app, static_options).call(env)
    end

    def view_root
      @root ||= Pathname(__FILE__).dirname.expand_path.join('views')
    end

    def static_options
      {:urls => [""], :root => view_root, :index => 'index.html'}
    end
  end
end
