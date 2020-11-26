x = [1,2,3].each

y = Enumerator.new do |g|
  loop do
    item = x.next
    g.yield(item)
    raise StopIteration if item == 2
  end
end

x = [1,2,3].each
z = Enumerator.new do |g|
  memo = 0
  loop {
    while memo < 1
      g.yield(x.next)
      memo += 1
    end
  }
end
