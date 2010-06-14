class Compiler
  
  def self.syntax_error?(code)
    work_dir = APP_CONFIG['work_dir']
    
    code_file_path = CozyFileUtils.unique_file_in(work_dir, 'tmp')
    f = File.open(code_file_path, 'w')
    f.write(code)
    f.close
    
    out = `gcc -x c -fsyntax-only #{code_file_path} 2>&1`
    out =~ /error/i ? true : false
  end

  def self.compile_to(code, dest_path)
    work_dir       = APP_CONFIG['work_dir']
    
    code_file_path = CozyFileUtils.unique_file_in(work_dir, 'tmp')
    f = File.open(code_file_path, 'w')
    f.write(code)
    f.close
    
    out = `gcc -x c -o #{dest_path} #{code_file_path} 2>&1`
    out =~ /error/i ? false : true
  end
end