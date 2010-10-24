#!/usr/bin/env ruby
require 'rubygems'
require 'configatron'
require 'directory_watcher'
require 'directory_watcher/scanner'
require 'directory_watcher/rev_scanner'
require 'escape'
require 'fileutils'

config = configatron.configure_from_yaml(File.expand_path(File.dirname(__FILE__) + "/config/config.yml"))

if (config)
  dws = Array.new
  
  all_folders = config['watch_folders'].split ','
  move_folder = config['convert_folder']
  
  all_folders.each do |dir|
    dw = DirectoryWatcher.new dir, :glob => "**/*.{#{config['extensions']}}", :interval => config['watch_interval']
    dws << dw
  end

  dws.each do |dw|
    dw.add_observer do |*args|
      args.each do |file|
        
        if file.type != :removed
          command = "./simplequeue.rb "+Escape.shell_single_word(file.path)
          puts "execute #{command}"
          system command
        end
      end
    end
    dw.start
  end

  gets
  
  dws.each do |dw|
    dw.stop
  end
end