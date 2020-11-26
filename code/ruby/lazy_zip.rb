x = Enumerator.new do |g|
  g.yield 1
  g.yield 2
  puts "TWO"
  g.yield 3
end

y = [10, 20, 30]

xy = x.lazy.zip(y)

puts xy.next
