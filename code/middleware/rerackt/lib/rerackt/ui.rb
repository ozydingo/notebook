module Rerackt
  class UI
    def call(env)
      static_app.call(env)
    end

    def static_app
      Rack::Static.new(nil, static_options)
    end

    def static_options
      {urls: ["/"], root: asset_path, index: 'index.html'}
    end

    # def static_app
    #   ActionnDispatch::Static.new(nil, asset_path)
    # end

    def asset_path
      @root ||= Rerackt.root.join("assets")
    end
  end
end
