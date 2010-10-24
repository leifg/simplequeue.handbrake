#!/usr/bin/env ruby
require 'rubygems'
require 'escape'

Dirname = "/Users/leifg/Movies/convert_ingoing/"

ingoing_dir = Dir.new(Dirname).entries.each do |file|
  file_to_add = Escape.shell_single_word(Dirname+file)
  if not File.directory?(file_to_add)
    puts "./simplequeue.rb -a "+ file_to_add
    system("./simplequeue.rb -a "+ file_to_add)
  end

end