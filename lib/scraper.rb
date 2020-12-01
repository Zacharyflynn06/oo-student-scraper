require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    cards = doc.css(".student-card a")
    cards.map do |card|
      {:name => card.css(".student-name").text ,
        :location => card.css(".student-location").text,
        :profile_url => card.attr('href')
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    new_hash = {}
    
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    
    card = doc.css(".vitals-container .social-icon-container a")

    card.each do |element|
      if element.attr('href').include?("twitter")
        new_hash[:twitter] = element.attr('href')
      elsif element.attr('href').include?("linkedin")
        new_hash[:linkedin] = element.attr('href')
      elsif element.attr('href').include?("github")
        new_hash[:github] = element.attr('href')
      elsif element.attr('href').end_with?("com/")
        new_hash[:blog] = element.attr('href')
      end
    end

    new_hash[:profile_quote] = doc.css(".vitals-container .vitals-text-container .profile-quote").text
    new_hash[:bio] = doc.css(".bio-block.details-block .bio-content.content-holder .description-holder p").text

new_hash
end

end

