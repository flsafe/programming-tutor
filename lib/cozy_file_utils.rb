module CozyFileUtils
  
  def self.unique_file_in(dir, prefix)
    begin
      FileUtils.mkdir_p(dir)
      CozyFileUtils.unique_file_path(dir, prefix)
    rescue Exception=>e
      nil
    end
  end
  
  protected
  
   def self.unique_file_path(dir, prefix)
    while true
     file = CozyFileUtils.rand_file_name(prefix)
     path = "#{dir}/#{file}"
     break unless File.exists?(path)
    end
    path
  end
  
   def self.rand_file_name(prefix)
    t = Time.now
    "#{prefix}-#{t.usec}-#{rand(10000)+1}"
  end
end