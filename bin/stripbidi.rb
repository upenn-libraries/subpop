#!/usr/bin/env ruby

def handle_line line
  s = line.strip
  s = "\"#{s}\"" unless line =~ /^"/
  s.gsub(/\u200F|\u200E/, '').gsub(/\&amp;/, '&')

end

IO.foreach(File.expand_path('../../doc/POP_Names.csv', __FILE__)) do |line|
  s = handle_line line
  puts s
end
