class ABigStick
  def call(env)
    static_app.call(env)
  end

  def static_app
    Rack::Static.new(nil, static_options)
  end

  def static_options
    {urls: [""], root: view_root, index: 'index.html'}
  end

  def view_root
    @root ||= Pathname(__dir__).expand_path.join('assets')
  end
end
