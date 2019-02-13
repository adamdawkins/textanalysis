require 'httparty'
require 'nokogiri'

class TextFinder
  attr_reader :body, :doc

  def initialize(url)
    @body = HTTParty.get(url)
    @doc = Nokogiri(@body)

    self
  end
  
  def phrases
    @doc.css('h1,h2,h3,h4,h5,h6,p,a').map { |e| e.text }
  end

  def words
    phrases.join(' ').split(' ').collect(&:downcase)
  end
  def counts
    words.each_with_object(Hash.new(0)) do |word, counts|
      counts[word] += 1
    end.sort_by(&:last).reverse.to_h
  end
end

class MultipleTextFinder
  attr_reader :finders
  def initialize(*urls)
    pp "URLS:", urls
    @finders = urls.map { |u| TextFinder.new(u) }
  end

  def words
    @finders.map {|f| f.words }.flatten
  end

  def counts
    words.each_with_object(Hash.new(0)) do |word, counts|
      counts[word] += 1
    end.sort_by(&:last).reverse.to_h
  end
end
