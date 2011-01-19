class CozyStringUtils 

  def self.scrub_all_includes(src_code)
    src_code.strip.gsub(/^.*#.+/, "")
  end

  def self.escape_back_slashes(src_code)
    src_code.gsub(/\\/, '\\\\\\\\')
  end
end
