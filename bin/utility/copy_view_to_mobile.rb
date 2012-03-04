# To change this template, choose Tools | Templates
# and open the template in the editor.


require 'rubygems'
require "pathname"
require 'fileutils'
class CopyView
include FileUtils
def copy

pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent #do we have one line solution?

view_path=File.join(project_root,"app","views")
puts "view_path=#{view_path}"

Dir.chdir(view_path)

#list each view folder
Dir.entries(view_path).each do |view_dir| 
  if File.directory?(view_dir) 
    unless (view_dir=="." || view_dir=="..")
      #new_dir=File.join(project_root,"app","views",view_dir) 
      #Dir.chdir(new_dir)
      unless  Dir.entries(view_dir).include?("mobile") # if no mobile folder, than create a mobile dir
        Dir.chdir("./#{view_dir}")
        Dir.mkdir("mobile")
        Dir.chdir("../#{view_dir}")
        Dir.chdir("../")
        puts "mkdir for #{view_dir}"
      end   
    end
  end
end

#now copy file into mobile with changed mobile name

Dir.entries(view_path).each do |view_dir| 
  if File.directory?(view_dir) 
    unless (view_dir=="." || view_dir=="..")
      all_entry=Dir.entries(view_dir)
      if  all_entry.include?("mobile")  &&  all_entry.size>3# if no mobile folder, than create a mobile dir
        unless  Dir.entries("./#{view_dir}/mobile").size >3
          puts "already copied #{view_dir}"
        else
      #  puts "we will copy for #{view_dir}"
        Dir.entries("./#{view_dir}").each do |file|
        
          if file=="mobile"
            #  puts "will copy #{file}"
            #  new_file_name=file.gsub(/\.html\./,".mobile.")
           #   puts "will copy new file as #{new_file_name}"
            #   FileUtils.copy("./#{view_dir}/#{file}","./#{view_dir}/mobile/#{new_file_name}")
             Dir.entries("./#{view_dir}/#{file}").each do |new_file_name|
            FileUtils.remove_file("./#{view_dir}/mobile/#{new_file_name}")
               puts "delete #{ new_file_name} done"
             end
           end
        end               
        end
      end   
    end
  end
end
end
end

CopyView.new.copy #only run once
