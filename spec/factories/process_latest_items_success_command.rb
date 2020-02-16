# frozen_string_literal: true

# This class for stub response with simple_command object
class ProcessLatestItemsSuccessCommand
  prepend SimpleCommand

  def initialize(items)
    @items = items
  end

  def call
    items
  end

  attr_reader :items
end
