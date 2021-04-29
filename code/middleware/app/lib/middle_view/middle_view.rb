module MiddleView
  class MiddleView
    def call(env)
      static_app.call(env)
    end

    def static_app
      Rack::Static.new(Rails.application, static_options)
      # Rack::Directory.new(view_root, nil)
    end

    def static_options
      {:urls => ["/"], :root => view_root, :index => 'index.html'}
    end

    def view_root
      @root ||= Pathname(__dir__).expand_path.join('views')
    end
  end
end
