# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  context 'generates id when build new item' do
    let(:title){  'Google News' }
    let(:image_src){ nil }
    let(:content){ 'Google Content!' }

    it 'assigns id from title' do
      item = Item.new(title, image_src, content)
      expect(item.id).to eq('Google_News')
    end
  end
end
