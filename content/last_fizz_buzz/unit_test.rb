def create_expected_string
  (1..100).to_a.map do |i|
    case
      when i % 15 == 0
        "fizzbuzz"
      when i % 3 == 0
        "fizz"
      when i % 5 == 0
        "buzz"
      else
        i
    end
  end.join("\n")
end

def test_fizz_buzz
  run_with_and_expect('', create_expected_string)
end
