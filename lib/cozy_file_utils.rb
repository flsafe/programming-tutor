module CozyFileUtils
  
  def self.unique_file_in(dir, prefix)
    while true
     file = CozyFileUtils.rand_file_name(prefix)
     path = "#{dir}/#{file}"
     break unless File.exists?(path)
    end
    path
  end
  
  protected
  
   def self.rand_file_name(prefix)
    t = Time.now
    "#{prefix}-#{t.usec}-#{Kernel.rand(10000)+1}"
  end
end