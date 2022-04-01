class Base
  def self.inherited(klass)
    puts "#{klass} inherited #{self}"
  end
end

class Child < Base
  puts "Start of Child"

  class Foo
    def foo
      "foo"
    end
  end

  raise "nope"

  puts "End of Child"
end

# Output idicates inherited is executed immediately, not on class close:
# Child inherited Base
# Start of Child
# End of Child
