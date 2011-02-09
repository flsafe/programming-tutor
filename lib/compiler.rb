require 'tempfile'

class Compiler

  def self.syntax_error?(code)
    Compiler.check_syntax(code)
    $? == 0 ? false : true
  end
  
   def self.check_syntax(code)
    work_dir       = APP_CONFIG['work_dir']
    f              = Tempfile.new('syntax', work_dir)
    code_file_path = f.path
    begin
      f.write(code)
      f.flush
      out = `gcc -Wall -x c -fsyntax-only #{code_file_path} 2>&1`
      out.gsub(/#{f.path}:/, '')
    rescue
      raise "Could not write tmp scratch file to do the syntax check!"
    ensure
      f.close
    end
  end
end
