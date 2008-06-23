Gem::Specification.new do |s|
  require 'rake'
  s.name = "gchartrb"
  s.version = "0.9.1"
  s.authors = ["Deepak Jois"]
  s.email = "deepak.jois@gmail.com"
  s.date = "2008-06-16"
  s.homepage = "http://code.google.com/p/gchartrb"
  s.summary = "Ruby Wrapper for the Google Chart API"
  s.description = "gchartrb is a Ruby wrapper around the Google Chart API, located at http://code.google.com/apis/chart/. Visit http://code.google.com/p/gchartrb to track development regarding gchartrb."

  s.has_rdoc = true
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.rdoc_options = ["--main", "README.txt"]
  s.files = ["CREDITS", "History.txt", "Manifest.txt", "README.txt", "Rakefile", "TODO", "gchartrb.gemspec" ] + FileList["{lib,spec}/**/*"].to_a
  s.require_paths = ["lib"]
  s.rubyforge_project = "gchartrb"
  s.rubygems_version = "1.1.1"
end