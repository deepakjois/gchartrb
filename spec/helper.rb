$LOAD_PATH.unshift(File.expand_path("#{File.dirname(__FILE__)}/../lib"))
require 'uri'
def query_string_to_hash(url)
  uri = URI.parse(url)
  uri.query.split("&").inject({}) { |h,a| param,val = a.split("=") ; h[param.to_sym] = val ; h }
end

class Hash
  def except(*rejected)
    reject { |k,v| rejected.include?(k) }
  end
end

require "spec"
require "gchartrb"
