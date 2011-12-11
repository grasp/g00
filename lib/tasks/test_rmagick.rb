require 'rubygems'
require 'RMagick'
include Magick

test_image = Image.new(100,100) { self.background_color = "green" }
test_image.write("green100x100.jpg")

#exit


