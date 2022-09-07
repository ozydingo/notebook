words = File.readlines(__dir__ + "/words-oxford-5k-3,12.lst").map(&:strip)
puts words.sample(4)
