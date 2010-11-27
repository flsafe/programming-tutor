class IncludeScrubber

  def self.scrub_all_includes(src_code)
    src_code.strip.gsub(/^.*#.+/, "")
  end
end
