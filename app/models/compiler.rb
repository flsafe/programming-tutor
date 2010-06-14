class Compiler
  
  def self.syntax_error?(code)
    work_dir       = APP_CONFIG['work_dir']
    f              = Tempfile.new('syntax', work_dir)
    code_file_path = f.path
    begin
      f.write(code)
      f.flush
      out = `gcc -x c -fsyntax-only #{code_file_path} 2>&1`
      out =~ /error/i ? true : false
    rescue
      raise "Could not write tmp scratch file to do the syntax check!"
    ensure
      f.close
    end
  end

  def self.compile_to(code, dest_path)
    work_dir       = APP_CONFIG['work_dir']
    f              = Tempfile.new('exec', work_dir)
    code_file_path = f.path
    begin
      f.write(code)
      f.flush
      out = `gcc -x c -o #{dest_path} #{code_file_path} 2>&1`
      out =~ /error/i ? false : true
    rescue
      raise "Could not write the user's solution code to a tmp scratch file to be compiled!"
    ensure
      f.close      
    end
  end
end