class BusyBee
  @queue = :default

  def self.perform(n = 30)
    puts "Going to work for #{n} seconds!"
    n.times do |i|
      sleep(1)
      puts "Working (#{i + 1})..."
    end
    puts "Done working!"
  end
end
