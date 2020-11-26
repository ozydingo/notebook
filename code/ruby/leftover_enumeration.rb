x = 10.times.map { |ii| "x#{ii}" }
y = 1.times.map { |ii| "y#{ii}" }

def cap(enum, limit)
  Enumerator.new do |g|
    limit.times do
      g.yield enum.next
    end
  end
end

def cap2(enum, limit)
  return enum_for :cap2, enum, limit) if !block_given?

  limit.times do
    yield enum.next
  end
end

ex = Enumerator.new do |g|
  x.each do |val|
    g.yield(val)
  end
end

ey = Enumerator.new do |g|
  y.each do |val|
    g.yield(val)
  end
end

cex = cap(ex, 2)
cey = cap(ey, 2)

sampler = Enumerator.new do |g|
  loop { g.yield(cex.next) }
  loop { g.yield(cey.next) }
  loop { g.yield(ex.next) }
  loop { g.yield(ey.next) }
end

sampler.each { |item| puts "got #{item}"}

sampler2 = Enumerator.new do |g|
  cex.each { |item| g.yield(item) }
  cey.each { |item| g.yield(item) }
  ex.each { |item| g.yield(item) }
  ey.each { |item| g.yield(item) }
end

sampler2.each { |item| puts "got #{item}"}

## method 2: enum_for

def leftovers(n, e1, e2)
  return enum_for(:leftovers, n, e1, e2) if !block_given?

  ce1 = cap(e1, n)
  ce2 = cap(e2, n)
  loop { yield(ce1.next) }
  loop { yield(ce2.next) }
  loop { yield(e1.next) }
  loop { yield(e2.next) }
end
