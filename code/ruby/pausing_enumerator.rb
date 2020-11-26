class PausingEnumerator
  def initialize(enumerator)
    @enum = enumerator
  end

  def pause_when(&blk)
    Enumerator.new do |e|
      loop do
        value = @enum.next
        e.yield(value)
        raise StopIteration if blk.call(value)
      end
    end
  end
end
