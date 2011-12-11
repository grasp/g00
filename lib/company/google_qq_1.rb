#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.


require 'rubygems'
require 'mechanize'

start_time=Time.now
puts "loaded gem on #{start_time}"

#key word 物流专线qq,
#物流有限公司 qq 
#物流 竭诚为你服务   qq,
#物流  欢迎来电    qq



require 'rubygems'
require 'mechanize'

a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
  agent.set_proxy("wwwgate0-ch.mot.com", 1080) 
}
page_links=Array.new
  
a.get('http://google.com/') do |page|
  search_result = page.form_with(:name => 'f') do |search|
    search.q = 'Hello world'
  end.submit
#get the first search result

  search_result.links.each do |link|
   if link.href.match(/&start=\d\d/)
    page_links<<link.href
   end
  end
end

page_links.each do |link|
a.get(link) do |page|
  puts link
  page.parser().css("st").each do |one_result| 
    puts one_result.content
  end
  end
  
end
