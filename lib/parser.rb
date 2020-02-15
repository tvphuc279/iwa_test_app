# frozen_string_literal: true

require 'readability'
require 'open-uri'

# Library for parsing content from URL
class Parser
  attr_reader :source, :options
  attr_accessor :parsed_document, :error

  def initialize(source, options = default_options)
    @source = source
    @options = options
    reset
    call
  end

  def content
    parsed_document&.content
  end

  def title
    parsed_document&.title
  end

  def image_src
    src = nil
    parsed_document&.images&.each do |image|
      src = image if uri?(image)
      break;
    end
    src
  end

  def html
    parsed_document.html
  end

  private

  def call
    begin
      if source?
        self.parsed_document = Readability::Document.new(load_source, options)
      else
        assign_error_message(I18n.t('errors.source_empty'))
      end
    rescue StandardError => e
      assign_error_message(e.message)
    end
  end

  def load_source
    open(source).read
  end

  def source?
    source.present?
  end

  def default_options
    { tags: %w[div p img a table tr td b],
      attributes: %w[src href],
      remove_empty_nodes: false }
  end

  def assign_error_message(message)
    self.error = message
  end

  def reset
    self.error = nil
    self.parsed_document = nil
  end

  def uri?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end
end
