class SyntaxChecker
  
  def initialize
  end
  
  def check_syntax(code)
    out = `echo "#{code}" | gcc -x c -fsyntax-only - 2>&1`
  end
end