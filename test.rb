require 'google_chart'

# Pie Chart
pc = GoogleChart::PieChart.new('320x200', "Pie Chart",false)
pc.data "Apples", 40
pc.data "Banana", 20
pc.data "Peach", 30
pc.data "Orange", 60
puts pc.to_url

# Line Chart
lc = GoogleChart::LineChart.new('320x200', "Line Chart", false)
lc.data "Trend 1", [5,4,3,1,3,5,6], '0000ff'
lc.show_legend = true 
lc.show_labels = false
lc.data "Trend 2", [1,2,3,4,5,6], '00ff00'
lc.data "Trend 3", [6,5,4,3,2,1], 'ff0000'
puts lc.to_url

# Bar Chart
bc = GoogleChart::BarChart.new('800x200', "Bar Chart", :vertical, false)
bc.data "Trend 1", [5,4,3,1,3,5], '0000ff' 
bc.data "Trend 2", [1,2,3,4,5,6], 'ff0000'
bc.data "Trend 3", [6,5,4,4,5,6], '00ff00'
puts bc.to_url

# Line XY Chart
lcxy =  GoogleChart::LineChart.new('320x200', "Line XY Chart", true)
lcxy.data "Trend 1", [[1,1], [2,2], [3,3], [4,4]], '0000ff'
lcxy.data "Trend 2", [[4,5], [2,2], [1,1], [3,4]], '00ff00'
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
puts vd.to_url

# Solid fill
lc.fill(:background, :solid, {:color => 'fff2cc'})
lc.fill(:chart, :solid, {:color => 'ffcccc'})
puts lc.to_url

# Gradient fill
lc.fill(:background, :gradient, {:angle => 0,  :color => [['76A4FB',1],['ffffff',0]]})
lc.fill(:chart, :gradient, {:angle => 0, :color => [['76A4FB',1],['ffffff',0]]})
puts lc.to_url

# Stripes Fill
lc.fill(:chart, :stripes, {:angle => 90, :color => [['76A4FB',0.2],['ffffff',0.2]]})
puts lc.to_url

