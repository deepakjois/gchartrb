# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/google_chart.rb'

class Hoe
  def extra_deps; @extra_deps.reject { |x| Array(x).first == "hoe" } end
end # copied from the Rakefile of the sup project

Hoe.new('gchartrb', "0.3.0") do |p|
  p.rubyforge_name  = 'gchartrb'
  p.author          = 'Deepak Jois'
  p.email           = 'deepak.jois@gmail.com'
  p.summary         = 'Ruby Wrapper for the Google Chart API'
  p.description     = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url             = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes         = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.remote_rdoc_dir = ''
end

# vim: syntax=Ruby
