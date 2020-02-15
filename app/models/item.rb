# frozen_string_literal: true

# Non-ActiveRecord class for handling item instances
class Item
  extend ActiveModel::Naming

  def initialize(title, image_src, content)
    @title = title
    @image_src = image_src
    @content = content
    self.id = generate_id
  end

  attr_reader :title, :image_src, :content
  attr_accessor :id

  private

  def generate_id
    title.to_s.gsub(/[^\w\-]/, '_')
  end
end
