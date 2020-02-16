# frozen_string_literal: true

require 'rails_helper'

describe ProcessLatestItems do
  describe '.call' do
    let(:url) { 'https://news.ycombinator.com/best' }

    subject { described_class }

    context 'when can parse content from url' do
      let(:image_src1) {
        'https://i0.wp.com/media.boingboing.net/zuckerberg.jpg?fit=600%2C400&ssl=1'
      }
      let(:image_src2) {
        'https://i2.wp.com/media.boingboing.net/uploads/2020/02/facebook.jpg?fit=600%2C330&ssl=1'
      }
      let(:item1) {
        Item.new('Facebook Title 1', image_src1, Faker::Lorem.paragraph)
      }
      let(:item2) {
        Item.new('Facebook Title 2', image_src2, Faker::Lorem.paragraph)
      }

      before do
        subject.stub(:call).with(url).and_return([item1, item2])
      end

      it 'returns latest news' do
        expect(subject.call(url).size).to eq 2
      end
    end

    context 'when cannot parse context from url' do
      let(:invalid_url) { 'invalid_url' }

      before do
        subject.stub(:call).with(invalid_url).and_return(I18n.t('errors.cannot_parse_url'))
      end

      it 'returns error message' do
        expect(subject.call(invalid_url)).to eq I18n.t('errors.cannot_parse_url')
      end
    end
  end
end