#coding:utf-8
require "sqlite3"
require 'mechanize'
cookie_dir ="D:\\Profiles\\w22812\\Application Data\\Mozilla\\Firefox\\Profiles\\623tc49u.default"  

cookie = String.new  
Dir.chdir(cookie_dir){|dir|  
  db = SQLite3::Database.new('cookies.sqlite')  
  p = Proc.new{|s| s.to_i.zero? ? 'TRUE' : 'FALSE'}  
  db.execute("SELECT  host, isHttpOnly, path, isSecure, expiry, name, value FROM moz_cookies   
    ORDER BY id DESC"){|r|  
    cookie << [r[0], p.call(r[1]), r[2], p.call(r[3]), r[4], r[5], r[6]].join("\t") << "\n"  
  }  
}  


agent = Mechanize.new  
agent.cookie_jar.load_cookiestxt(StringIO.new(cookie))  

puts "done"