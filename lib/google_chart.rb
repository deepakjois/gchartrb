%w(
    base
    pie_chart
    line_chart
    bar_chart
    venn_diagram
    scatter_chart     
).each do |filename|
    require File.dirname(__FILE__) + "/google_chart/#{filename}"
end
