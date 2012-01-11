# To change this template, choose Tools | Templates
# and open the template in the editor.

def load_cookie
 # cookie_dir ="D:\\Profiles\\w22812\\Application Data\\Mozilla\\Firefox\\Profiles\\623tc49u.default"  
 # cookie_dir ="D:\\w090\\cookie"  
cookie_dir ="/home/hunter/tttk3240"
#cookie_dir ="C:\\Documents and Settings\\Administrator\\Application Data\\Mozilla\\Firefox\\Profiles\\tttk3240.default"  

 cookie = String.new  
  Dir.chdir(cookie_dir){|dir|  
    db = SQLite3::Database.new('cookies.sqlite')  
    p = Proc.new{|s| s.to_i.zero? ? 'TRUE' : 'FALSE'}  
    db.execute("SELECT  host, isHttpOnly, path, isSecure, expiry, name, value FROM moz_cookies   
    ORDER BY id DESC"){|r|  
      cookie << [r[0], p.call(r[1]), r[2], p.call(r[3]), r[4], r[5], r[6]].join("\t") << "\n"  
    }  
  }  
  $cookie= cookie
  return cookie
end

load_cookie