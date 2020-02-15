# frozen_string_literal: true

require './lib/parser'

# Class for processing news links from URL 'https://news.ycombinator.com/best'
class ProcessLatestItems
  prepend SimpleCommand

  def initialize(url)
    @url = url
  end

  def call
    items = []
    parsed_document = Parser.new(url)

    if parsed_document.present?
      parsed_document.html.css('a.storylink').each do |link|
        link_url = link.attributes['href'].value

        item = process_link(link_url) if link_url.present?
        if item.content.present?
          items << item
        end
      end

      return items
    else
      errors.add(:parse_error, I18n.t('errors.cannot_parse_url'))
    end

    nil
  end

  attr_reader :url

  private

  def build_item(parsed_link)
    Item.new(parsed_link.title, parsed_link.image_src, parsed_link.content)
  end

  def process_link(link_url)
    parsed_link = Parser.new(link_url)
    build_item(parsed_link)
  end
end
