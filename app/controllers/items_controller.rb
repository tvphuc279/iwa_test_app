# frozen_string_literal: true

# Class for handling latest news from URL 'https://news.ycombinator.com/best'
class ItemsController < ApplicationController
  def index
    @items = []
    command = load_process_latest_items_cached
    if command.success?
      @items = command.result
    else
      # handle errors
    end
  end

  def show
    @item = load_item
    render :index unless @item
  end

  private

  def load_process_latest_items_cached
    Rails.cache.fetch('process_latest_items_cache', expires_in: 30.minute) do
      command = ProcessLatestItems.call('https://news.ycombinator.com/best')
    end
  end

  def load_item
    command = load_process_latest_items_cached
    command.result.select{ |item| item.id == params[:id] }.last
  end
end
