require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GoogleChart::QrCode do
  before(:each) { @qr_code = GoogleChart::QrCode.new }

  it "should have the correct type by default" do
    @qr_code.chart_type.should == "qr"
  end

  it "should default to UTF-8 output encoding" do
    @qr_code.output_encoding.should == "UTF-8"
  end

  it "should default to L error_correction_level" do
    @qr_code.error_correction_level.should == "L"
  end

  it "should default to margin 4" do
    @qr_code.margin.should == 4
  end

  it "should generate the correct url" do
    @qr_code.data "Hello World"
    @qr_code.height = 200
    @qr_code.width = 200

    url = @qr_code.to_url

    #?choe=UTF-8&cht=qr&chl=Hello%20World&chs=200x200&chld=L%7C4&chts=
    url.should include("choe=UTF-8")
    url.should include("cht=qr")
    url.should include("chl=Hello%20World")
    url.should include("chs=200x200")
    url.should include("chs=200x200")
    url.should include("chld=L%7C4")
  end
end
