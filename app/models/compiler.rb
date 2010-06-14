class Compiler
  
  def self.syntax_error?(code)
    path = unique_file_name(APP_CONFIG['work_dir'])
    f = File.open(path, 'w')
    f.write(code)
    f.close
    
    out = `gcc -x c -fsyntax-only #{path} 2>&1`
    out =~ /error/i ? true : false
  end

  def self.compile_to(code, dest_path)
    code_file_path = Compiler.unique_file_name(APP_CONFIG['work_dir'])
    f = File.open(code_file_path, 'w')
    f.write(code)
    f.close
    
    out = `gcc -x c -o #{dest_path} #{code_file_path} 2>&1`
    out =~ /error/i ? false : true
  end
  
  protected
  
  def self.unique_file_name(base)
    path = unique(base)
    while File.exists?(path)
      path = unique(base)
    end
    path
  end
  
  def self.unique(base)
    t = Time.now
    "#{base}/tmp-#{t.usec}-#{rand(10000)+1}"
  end

end