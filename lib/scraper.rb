module BostonStreetScraper
  class Scraper
    attr_reader :response, :response_table, :attributes
    include HTTParty
    format :html
    def initialize(street_name)
      @response = HTTParty.get "http://www.cityofboston.gov/publicworks/sweeping/?streetname=#{street_name.bytes.collect { |a| a.chr.capitalize}.join}&Neighborhood="
      @attributes = Nokogiri::HTML(@response).css('#tblsweeping tr').collect do |item|
        parsed = item.css('td').collect {|i|i.children.to_s.gsub("\302", ' ').gsub("\240", " ").gsub(/\s\s+/, ' ').strip}
        {:street => parsed[0], :district => parsed[1], :side => parsed[2], :section => Scraper.parse_section(parsed[3] || ''), :schedule => Scraper.parse_schedule(parsed[4] || '')}
      end
      @attributes.reject! {|i| i[:street].blank?}
    end

    def self.parse_section(section)
      section.gsub(/\[.*\]/, '').strip
    end

    def self.parse_schedule(schedule)
      schedule.split('<br>').collect {|i| i.strip.gsub(/\(|\)/, '')}
    end
  end
end