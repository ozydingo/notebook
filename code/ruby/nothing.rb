require 'singleton'

class NothingClass
  include Singleton

  def inspect
    "nothing"
  end

  def method_missing(*args)
    self
  end
end

module DeepNothing
  CANT_TOUCH_THIS = [
    :deep_nothing,
    :nil?,
    :methods,
    :method,
    :nothingify,
    :define_singleton_method,
    :convert_key,
  ]
  def deep_nothing
    methods.each do |method_name|
      cant_touch_this = CANT_TOUCH_THIS
      next if cant_touch_this.include?(method_name)
      next if method(method_name).super_method.nil? || method(method_name).super_method.none?
      begin
        define_singleton_method(method_name) do |*args, &blk|
          result = super(*args, &blk).nothingify
          return result
        end
      rescue
        puts "Failed to define #{method_name}"
      else
        # puts "Defined #{method_name}"
      end
    end
    return self
  end
end

Object.include(DeepNothing)

module Kernel
  def nothingify
    nil? ? NothingClass.instance : deep_nothing
  end
end

require 'hashie'
response = Hashie::Mash.new({data: {x: "hello", y: "world"}})
# response.nothingify.data.x
# # => "hello"
# response.nothingify.oops.x

response.extend(DeepNothing)
puts "response.deep_nothing"
x = response.deep_nothing
p x
puts "response.deep_nothing.data.x"
p response.deep_nothing.data.x
puts "response.deep_nothing.oops.x"
p response.deep_nothing.oops.x
puts "response.deep_nothing.data.oops"
p response.deep_nothing.data.oops
