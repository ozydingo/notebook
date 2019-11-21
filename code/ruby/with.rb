module With
  module_function

  def [](object)
    yield(object)
  ensure
    object.close
  end
end
