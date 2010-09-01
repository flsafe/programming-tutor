module CozyTimeUtils
  
  def self.time_remaining(start_t, alloted_minutes)
    puts "*" * 10
    puts "start time: #{start_t}"
    puts "end time: #{alloted_minutes}"
    
    time_remaining  = "00:00"
    
    alloted_seconds = alloted_minutes * 60
    
    elapsed_seconds = Time.now.to_i - start_t.to_i
    time_remaining  = [alloted_seconds - elapsed_seconds, 0].max
      
    minutes_remain  = time_remaining / 60
    seconds_remain  = time_remaining % 60
    
    "#{'0' if minutes_remain < 10}#{minutes_remain}:#{'0' if seconds_remain < 10}#{seconds_remain}"
  end
end