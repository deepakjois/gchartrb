require 'gchartrb'
# Pie Chart
GoogleChart::PieChart.new do |pc|
  pc.data "Apples", 40
  pc.data "Banana", 20
  pc.data "Peach", 30
  pc.data "Orange", 60

  puts "\nPie Chart"
  puts pc.to_url

  pc.show_labels = false
  puts "\nPie Chart (with no labels)"
  puts pc.to_url
end

# Line Chart
GoogleChart::LineChart.new do |lc|
  lc.title = "Line Chart"
  lc.show_legend = true

  lc.data "Trend 1", [5,4,3,1,3,5,6], '0000ff'
  lc.data "Trend 2", [1,2,3,4,5,6], '00ff00'
  lc.data "Trend 3", [6,5,4,3,2,1], 'ff0000'

  lc.axis(:left) do |axis|
    axis.alignment = :center
    axis.color = "ff00ff"
    axis.font_size = 16
    axis.range = 0..6
  end

  lc.axis :bottom, :alignment => :center, :color => "ff00ff", :font_size => 16, :range => 0..6
  lc.grid :x_step => 100.0/6.0, :y_step => 100.0/6.0, :line_segment => 1, :blank_segment => 0

  puts "\nLine Chart"
  puts lc.to_url
end

# Bar Chart
GoogleChart::BarChart.new do |bc|
  bc.title = "Bar Chart"
  bc.width = 800
  bc.height = 200
  bc.orientation = :vertical
  bc.grouping = :grouped

  bc.data "Trend 1", [5,4,3,1,3,5], '0000ff'
  bc.data "Trend 2", [1,2,3,4,5,6], 'ff0000'
  bc.data "Trend 3", [6,5,4,4,5,6], '00ff00'

  bc.bar_width = 5
  bc.bar_spacing = 2
  bc.group_spacing = 10

  bc.shape_marker :text, :text => "Test", :color => "000000" ,:data_set => 0, :data_point => 1, :size => 14
  puts "\nBar Chart"
  puts bc.to_url
end

# Line XY Chart
line_chart_xy = GoogleChart::LineXYChart.new do |lcxy|
  lcxy.title = "Line XY Chart"
  lcxy.show_legend = true

  lcxy.data "Trend 1", [[1,1], [2,2], [3,3], [4,4]], '0000ff'
  lcxy.data "Trend 2", [[4,5], [2,2], [1,1], [3,4]], '00ff00'
  puts "\nLine XY Chart (inside a block)"

  puts lcxy.to_url
end

# Venn Diagram
GoogleChart::VennDiagram.new(:title => 'Venn Diagram') do |vd|
  vd.show_legend = true

  vd.data "Blue", 100, '0000ff'
  vd.data "Green", 80, '00ff00'
  vd.data "Red",   60, 'ff0000'

  vd.intersections 30,30,30,10
  puts "\nVenn Diagram"
  puts vd.to_url
end

# Scatter Plot
GoogleChart::ScatterPlot.new do |sc|
  sc.title = "Scatter Chart"
  sc.data "Scatter Set", [[1,1,], [2,2], [3,3], [4,4]]
  sc.max_x = 5
  sc.max_y = 5
  sc.point_sizes [10,15,30,55]

  sc.axis(:bottom, :range => 0..5)
  sc.axis(:left, :range => 0..5, :labels => [0,1,2,3,4,5])
  puts "\nScatter Chart"
  puts sc.to_url
end

# Solid fill
line_chart_xy.fill :solid, :type => :background, :color => 'fff2cc'
line_chart_xy.fill(:solid, :type => :chart ,:color => 'ffcccc')
puts "\nLine Chart with Solid Fill"
puts line_chart_xy.to_url

# Gradient Fill
line_chart_xy.fill :gradient, :type => :background, :angle => 0,  :colors => ['76A4FB','ffffff'], :offsets => [1,0]
line_chart_xy.fill :gradient, :type => :chart, :angle => 0, :colors => ['76A4FB','ffffff'], :offsets => [1,0]
puts "\nLine Chart with Gradient Fill"
puts line_chart_xy.to_url

# Stripes Fill
line_chart_xy.fill :stripes, :type => :chart, :angle => 90, :colors => ['76A4FB','ffffff'], :widths => [0.2,0.2]
puts "\nLine Chart with Stripes Fill"
puts line_chart_xy.to_url

# Range and Shape Markers
puts "\nLine Chart with range markers and shape markers"
GoogleChart::LineChart.new do |lc|
  lc.title = "Line Chart"
  lc.title_color = 'ff00ff'
  lc.show_legend = true

  lc.data "Trend 1", [5,4,3,1,3,5,6], '0000ff'
  lc.data "Trend 2", [1,2,3,4,5,6], '00ff00'
  lc.data "Trend 3", [6,5,4,3,2,1], 'ff0000'
  lc.max = 10

  lc.range_marker :horizontal, :color => 'E5ECF9', :start => 0.1, :end => 0.5
  lc.range_marker :vertical, :color => 'a0bae9', :start => 0.1, :end => 0.5

  # Draw an arrow shape marker against lowest value in dataset
  lc.shape_marker :arrow, :color => '000000', :data_set => 0, :data_point => 3, :size => 10
  puts lc.to_url
end

# Bryan Error condition
lcxy =  GoogleChart::LineXYChart.new
lcxy.title = "Line Chart"
lcxy.show_legend = true
lcxy.data 'A', [[0, 32], [1, 15], [2, 23], [3, 18], [4, 41],  [5, 53]],'0000ff'
lcxy.data 'B', [[0, 73], [1, 0],  [2, 28], [3, 0],  [4, 333], [5, 0]], '00ff00'
lcxy.data 'C', [[0, 22], [1, 26], [2, 14], [3, 33], [4, 17],  [5, 7]], 'ff0000'
lcxy.data 'D', [[0, 4],  [1, 39], [2, 0],  [3, 5],  [4, 11],  [5, 14]], 'cc00ff'
puts "\nBryan Error Condition"
puts lcxy.to_url

# Stacked Chart error
stacked = GoogleChart::BarChart.new

stacked.title = "Stacked Chart"
stacked.title_color='ff0000'
stacked.title_font_size=18
stacked.orientation = :vertical
stacked.grouping = :stacked
stacked.encoding = :text

stacked.data "Trend 1", [60,80,20], '0000ff'
stacked.data "Trend 2", [50,5,100], 'ff0000'
stacked.axis :left, :range => 0..120
puts "\nStacked Chart with colored title"
puts stacked.to_url

# Encoding Error (Bar Chart)
bc = GoogleChart::BarChart.new do |chart|
  chart.width = 800
  chart.height = 350
  chart.orientation = :vertical
  chart.grouping = :stacked
  chart.encoding = :extended

  chart.data "2^i", (0..8).to_a.collect{|i| 2**i}, "ff0000"
  chart.data "2.1^i", (0..8).to_a.collect{|i| 2.1**i}, "00ff00"
  chart.data "2.2^i", (0..8).to_a.collect{|i| 2.2**i}, "0000ff"
  chart.max =  (2**8 + 2.1**8 + 2.2**8)

  chart.axis :left, :range => 0..(chart.max), :color => "000000", :font_size => 16, :alignment => :center
  chart.axis :bottom, :labels => (0..8).to_a, :color => "000000", :font_size => 16, :alignment => :center
end
puts "\nBar chart encoding error test"
puts bc.to_url

# Sparklines
GoogleChart::SparklineChart.new do |sp|
  sp.data "", [3,10,20,37,40,25,68,75,89,99], "ff0000"
  puts "\nSparklines"
  puts sp.to_url
end

# Maps.
mc = GoogleChart::MapChart.new do |chart|
  chart.title = "Hospital Procedural Compliance Nationally"
  chart.title_color = '000000'
  chart.title_font_size = 18
  
  chart.width = 440
  chart.height = 220
  chart.geographical_area = :usa
  
  chart.data :NY, 100
  chart.data :TX, 50
  chart.data :CA, 25
  
  chart.default_color = 'FFFFFF'
  chart.gradient = [ 'FF0000', '00FF00', '0000FF' ]
  
  chart.fill(:solid, :color => 'EAF7FE')
  
  puts "\nMap Chart"
  puts chart.to_url
end

__END__
# Line Style
lc = GoogleChart::LineChart.new('320x200', "Line Chart", false) do |lc|
  lc.data "Trend 1", [5,4,3,1,3,5], '0000ff'
  lc.data "Trend 2", [1,2,3,4,5,6], '00ff00'
  lc.data "Trend 3", [6,5,4,3,2,1], 'ff0000'
  lc.line_style 0, :length_segment => 3, :length_blank => 2, :line_thickness => 3
  lc.line_style 1, :length_segment => 1, :length_blank => 2, :line_thickness => 1
  lc.line_style 2, :length_segment => 2, :length_blank => 1, :line_thickness => 5
end
puts "\nLine Styles"
puts lc.to_url

puts "\nLine Styles (encoded URL)"
puts lc.to_escaped_url

# Fill Area (Multiple Datasets)
lc = GoogleChart::LineChart.new('320x200', "Line Chart", false) do |lc|
  lc.show_legend = false
  lc.data "Trend 1", [5,5,6,5,5], 'ff0000'
  lc.data "Trend 2", [3,3,4,3,3], '00ff00'
  lc.data "Trend 3", [1,1,2,1,1], '0000ff'
  lc.data "Trend 4", [0,0,0,0,0], 'ffffff'
  lc.fill_area '0000ff',2,3
  lc.fill_area '00ff00',1,2
  lc.fill_area 'ff0000',0,1
end
puts "\nFill Area (Multiple Datasets)"
puts lc.to_url

# Fill Area (Single Datasets)
lc = GoogleChart::LineChart.new('320x200', "Line Chart", false) do |lc|
  lc.show_legend = false
  lc.data "Trend 1", [5,5,6,5,5], 'ff0000'
  lc.fill_area 'cc6633', 0, 0
end
puts "\nFill Area (Single Dataset)"
puts lc.to_url
