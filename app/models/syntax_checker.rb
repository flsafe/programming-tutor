class SyntaxChecker
  def self.syntax_error?(code)
    error = `echo "#{code}" | gcc -x c -fsyntax-only - 2>&1`
    error
  end
end