class MyWorker
  @queue = :default

  def self.perform(n)
    puts "Going to work!"
    n.times do
      puts "Working..."
      sleep(1)
    end
    puts "Done working!"
  end
end
