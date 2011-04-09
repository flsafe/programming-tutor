
require 'spec_helper'

describe Hint do

  describe "#text=" do
    it "substitues the start/end code tags" do
      input =<<-END
        [startcode]
          for(int i = 0 ; i < 100 ; i++)
        [endcode]
      END
      expected =<<-END
        <pre><code>for(int i = 0 ; i &lt; 100 ; i++)</code></pre>
      END

      hint = Hint.new
      hint.text = input
      hint.text.strip.chomp.should == expected.strip.chomp
    end
  end
end

