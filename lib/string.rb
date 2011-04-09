class String

  # Text between [startcode] and [endcode] is wrapped around <pre><code> </code></pre>
  # and any < characters in between are escaped to &lt;
  CODE_TAG_REGEX = /\[startcode\](.*?)\[endcode\]/m

  def sub_start_end_code()
     self.gsub(CODE_TAG_REGEX) do |match|
        match.gsub!(/(\[startcode\]|\[endcode\])/, '')
        "<pre><code>" + match.gsub(/</, '&lt;').strip + "</code></pre>"
    end
  end
end
