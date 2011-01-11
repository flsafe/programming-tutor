module CozyFileUtils
  
  def self.unique_file_in(dir, prefix, opts = { :with_base => true })
    while true
     file = CozyFileUtils.rand_file_name(prefix)
     path = File.join(dir, file) 
     break unless File.exists?(path)
    end
    opts[:with_base] ? path : path.gsub(/#{dir}\//, "")
  end
  
   def self.rand_file_name(prefix)
    t = Time.now
    "#{prefix}-#{t.usec}-#{Kernel.rand(10000)+1}"
  end

  def self.language(filename)
    case CozyFileUtils.base_part_of(filename)
      when /\.c$/
        'c' 
      when /\.rb$/
        'ruby' 
      when /\.java$/
        'java'
      when /\.clj$/
        'clojure'
    end
  end
  
  def self.base_part_of(filename) 
    out = File.basename(filename).gsub(/[^\w._-]/, '') 
  end 
end
