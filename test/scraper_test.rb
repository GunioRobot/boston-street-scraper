require 'test_helper'
require 'fakeweb'

class TokenTest < Test::Unit::TestCase
  
  def test_parse_section
    assert_equal 'Brookline Ave - Kenmore St', BostonStreetScraper::Scraper.parse_section("Brookline Ave - Kenmore St [<a target=\"_blank\" href=\"http://maps.google.com/maps?q=Newbury+St+and+Brookline+Ave,+boston+ma\">Map</a>]")
  end
  
  def test_parse_schedule
    assert_equal ['2nd 4th Wed', '12:01am - 7am', 'Apr 13'], BostonStreetScraper::Scraper.parse_schedule("2nd 4th Wed <br>12:01am - 7am<br>(Apr 13)")
  end

  def test_initialize
    # FakeWeb mock: http://www.cityofboston.gov/publicworks/sweeping/?streetname=NEWBURY&Neighborhood=
    FakeWeb.register_uri :get, "http://www.cityofboston.gov/publicworks/sweeping/?streetname=NEWBURY&Neighborhood=",
      :body => File.open('test/fixtures/newbury.html').read
    scraper = BostonStreetScraper::Scraper.new('newbury')
    assert_equal File.open('test/fixtures/newbury.html').read, scraper.response
    
     expected = [
      {:section=>"Brookline Ave - Kenmore St",
       :schedule=>["Everyday", "12:01am - 7am"],
       :street=>"Newbury St",
       :district=>"Roxbury",
       :side=>""},
      {:section=>"Arlington St - Charlesgate East",
       :schedule=>["Everyday", "12:01am - 7am"],
       :street=>"Newbury St",
       :district=>"Roxbury",
       :side=>""},
      {:section=>"Commonwealth - Brookline",
       :schedule=>["2nd 4th Wed","12pm - 4pm", "Apr 13"],
       :street=>"Newbury St",
       :district=>"Roxbury",
       :side=>"Even"},
      {:section=>"Commonwealth - Brookline",
       :schedule=>["1st 3rd Wed", "12pm - 4pm","Apr 6"],
       :street=>"Newbury St",
       :district=>"Roxbury",
       :side=>"Odd"}]
    assert_equal expected, scraper.attributes
  end
end