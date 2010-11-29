class Compiler
  
  def self.syntax_error?(code)
    out = Compiler.check_syntax(code)
    out =~ /error/i ? true : false
  end
  
   def self.check_syntax(code)
    work_dir       = APP_CONFIG['work_dir']
    f              = Tempfile.new('syntax', work_dir)
    code_file_path = f.path
    begin
      f.write(code)
      f.flush
      out = `gcc -x c -fsyntax-only #{code_file_path} 2>&1`
      out.gsub(/#{f.path}:/, '')
    rescue
      raise "Could not write tmp scratch file to do the syntax check!"
    ensure
      f.close
    end
  end

  def self.compile_to(code, dest_path, options="")
    f              = Tempfile.new('exec', APP_CONFIG['work_dir'])
    code_file_path = f.path
    begin
      f.write(code)
      f.flush
      out = `gcc #{options} -x c -o #{dest_path} #{code_file_path} 2>&1`
      if out =~ /error/i
        raise "Could not compile solution!"
      end
      true
    ensure
      f.close      
    end
  end
end
