class Compiler
  
  def self.syntax_error?(code)
    `echo "#{code}" | gcc -x c -fsyntax-only - 2>&1`
  end

  def self.compile_to(code, dest_path)
    `echo #{code} | gcc -x c -o #{dest_path} - 2>&1`
  end
  
end