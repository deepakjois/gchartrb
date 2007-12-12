gchartrb
    by Deepak Jois
    http://code.google.com/p/gchartrb

== DESCRIPTION:
  
gchartrb is a Ruby wrapper around the Google Chart API, located at http://code.google.com/apis/chart/ 

Visit http://code.google.com/p/gchartrb to track development regarding gchartrb.

== FEATURES:
  
* Provides an object oriented interface in Ruby to create Google Chart URLs for charts.

== INSTALL:

=== Ruby Gem:

    sudo gem install gchartrb

=== Source Code:

Download the latest release from http://code.google.com/p/gchartrb/downloads/list

=== Subversion

    svn checkout http://gchartrb.googlecode.com/svn/trunk/ gchartrb-read-only

== Problems/TODO
The following features are pending :

* Horizontal and Vertical range Markers
* Line Styles
* Shape Markers
* Fill Area

However, you can still make use of the API to insert arbitrary parameters

    # Adding Extra params
    lc = GoogleChart::LineChart.new('320x200', "Line Chart", false)
    lc.data "Trend 1", [5,4,3,1,3,5,6], '0000ff'
    lc.data "Trend 2", [1,2,3,4,5,6], '00ff00'
    lc.data "Trend 3", [6,5,4,3,2,1], 'ff0000'
    puts lc.to_url({:chm => "r,000000,0,0.1,0.5"}) # Single black line as a horizontal marker by inserting arbitrary param

== SYNOPSIS:

    require 'rubygems'
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
    lc.axis :y, :range => [0,6], :color => 'ff00ff', :font_size => 16, :alignment => :center
    lc.axis :x, :range => [0,6], :color => '00ffff', :font_size => 16, :alignment => :center
    lc.grid :x_step => 100.0/6.0, :y_step => 100.0/6.0, :length_segment => 1, :length_blank => 0
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
    
    # Scatter Chart
    sc = GoogleChart::ScatterChart.new('320x200',"Scatter Chart")
    sc.data "Scatter Set", [[1,1,], [2,2], [3,3], [4,4]]
    sc.axis :x, :range => [0,4]
    sc.axis :y, :range => [0,4]
    sc.point_sizes [10,15,30,55] # Optional
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

== LICENSE:

(The MIT License)

Copyright (c) 2007 Deepak Jois

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
