#!/usr/bin/env ruby

# Constants.
USAGE = 'ruby process_country_codes.rb [input_filename]'
COUNTRY_CODE_REGEX = /^.+;(\w{2})$/    # Regex to pull country code.
ROW_SEPARATOR = "\n"


#
# Main Program.
#
# Read command-line arguments.
unless ARGV.length == 1
  puts USAGE
  exit
end

input_filename = File.dirname(__FILE__) + '/' + ARGV[0]

# Process the file contents line by line.
country_codes = []
IO.foreach(input_filename, ROW_SEPARATOR) do |line|
  match = line.match(COUNTRY_CODE_REGEX)
  country_codes << match[1].to_sym unless match.nil?
end

puts "[ :#{country_codes.join(', :')} ]"