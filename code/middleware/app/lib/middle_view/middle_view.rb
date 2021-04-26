module MiddleView
  class MiddleView
    def call(env)
      Rack::Static.new(nil, static_options).call(env)
    end

    def view_root
      @root ||= Pathname(__dir__).expand_path.join('views')
    end

    def static_options
      {:urls => [""], :root => view_root, :index => 'index.html'}
    end
  end
end
