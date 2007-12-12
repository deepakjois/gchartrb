require 'google_chart'

# Pie Chart
pc = GoogleChart::PieChart.new('320x200', "Pie Chart",false)
pc.data "Apples", 40
pc.data "Banana", 20
pc.data "Peach", 30
pc.data "Orange", 60
puts "Pie Chart"
puts pc.to_url

# Line Chart
lc = GoogleChart::LineChart.new('320x200', "Line Chart", false)
lc.data "Trend 1", [5,4,3,1,3,5,6], '0000ff'
lc.show_legend = true 
lc.show_labels = false
lc.data "Trend 2", [1,2,3,4,5,6], '00ff00'
lc.data "Trend 3", [6,5,4,3,2,1], 'ff0000'
lc.axis :y, :range => [0,6], :color => 'ff00ff', :font_size => 16, :alignment => :center
lc.axis :x, :range => [0,6], :color => '00ffff', :font_size => 16, :alignment => :center
lc.grid :x_step => 100.0/6.0, :y_step => 100.0/6.0, :length_segment => 1, :length_blank => 0
puts "Line Chart"
puts lc.to_url

# Bar Chart
bc = GoogleChart::BarChart.new('800x200', "Bar Chart", :vertical, false)
bc.data "Trend 1", [5,4,3,1,3,5], '0000ff' 
bc.data "Trend 2", [1,2,3,4,5,6], 'ff0000'
bc.data "Trend 3", [6,5,4,4,5,6], '00ff00'
puts "Bar Chart"
puts bc.to_url

# Line XY Chart
lcxy =  GoogleChart::LineChart.new('320x200', "Line XY Chart", true)
lcxy.data "Trend 1", [[1,1], [2,2], [3,3], [4,4]], '0000ff'
lcxy.data "Trend 2", [[4,5], [2,2], [1,1], [3,4]], '00ff00'
puts "Line XY Chart"
puts lcxy.to_url 

# Venn Diagram
# Supply three vd.data statements of label, size, color for circles A, B, C
# Then, an :intersections with four values:
# the first value specifies the area of A intersecting B
# the second value specifies the area of B intersecting C
# the third value specifies the area of C intersecting A
# the fourth value specifies the area of A intersecting B intersecting C
vd = GoogleChart::VennDiagram.new("320x200", 'Venn Diagram') 
vd.data "Blue", 100, '0000ff'
vd.data "Green", 80, '00ff00'
vd.data "Red",   60, 'ff0000'
vd.intersections 30,30,30,10
puts "Venn Diagram"
puts vd.to_url

# Scatter Chart
sc = GoogleChart::ScatterChart.new('320x200',"Scatter Chart")
sc.data "Scatter Set", [[1,1,], [2,2], [3,3], [4,4]]
sc.max_value [5,5] # Setting the max value
sc.axis :x, :range => [0,5]
sc.axis :y, :range => [0,5], :labels => [0,1,2,3,4,5]
sc.point_sizes [10,15,30,55] # Optional
puts "Scatter Chart"
puts sc.to_url

# Solid fill
lc.fill(:background, :solid, {:color => 'fff2cc'})
lc.fill(:chart, :solid, {:color => 'ffcccc'})
puts lc.to_url

# Gradient fill
lc.fill :background, :gradient, :angle => 0,  :color => [['76A4FB',1],['ffffff',0]]
lc.fill :chart, :gradient, :angle => 0, :color => [['76A4FB',1],
                                                   ['ffffff',0]]
puts lc.to_url

# Stripes Fill
lc.fill :chart, :stripes, :angle => 90, :color => [['76A4FB',0.2],
                                                   ['ffffff',0.2]]
puts lc.to_url

# Adding Extra params
lc = GoogleChart::LineChart.new('320x200', "Line Chart", false)
lc.data "Trend 1", [5,4,3,1,3,5,6], '0000ff'
lc.data "Trend 2", [1,2,3,4,5,6], '00ff00'
lc.data "Trend 3", [6,5,4,3,2,1], 'ff0000'
puts lc.to_url({:chm => "r,000000,0,0.1,0.5"}) # Single black line as a horizontal marker

# Bryan Error condition
lcxy =  GoogleChart::LineChart.new('320x200', "Line XY Chart", true)
lcxy.data 'A', [[0, 32], [1, 15], [2, 23], [3, 18], [4, 41],  [5, 53]],'0000ff'
lcxy.data 'B', [[0, 73], [1, 0],  [2, 28], [3, 0],  [4, 333], [5, 0]], '00ff00'
lcxy.data 'C', [[0, 22], [1, 26], [2, 14], [3, 33], [4, 17],  [5, 7]], 'ff0000'
lcxy.data 'D', [[0, 4],  [1, 39], [2, 0],  [3, 5],  [4, 11],  [5, 14]], 'cc00ff'
puts lcxy.to_url

