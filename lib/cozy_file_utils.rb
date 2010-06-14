module CozyFileUtils
  
  def self.unique_file_in(dir, prefix, opts = { :with_base => true })
    while true
     file = CozyFileUtils.rand_file_name(prefix)
     path = "#{dir}/#{file}"
     break unless File.exists?(path)
    end
    opts[:with_base] ? path : path.gsub(/#{dir}\//, "")
  end
  
   def self.rand_file_name(prefix)
    t = Time.now
    "#{prefix}-#{t.usec}-#{Kernel.rand(10000)+1}"
  end
end