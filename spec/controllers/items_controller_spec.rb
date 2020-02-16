# frozen_string_literal: true

require 'rails_helper'
require 'factories/process_latest_items_success_command'

RSpec.describe ItemsController, type: :controller do
  let(:image_src1) {
      'https://i0.wp.com/media.boingboing.net/zuckerberg.jpg?fit=600%2C400&ssl=1'
  }
  let(:item1) {
    Item.new('Facebook Title 1', image_src1, Faker::Lorem.paragraph)
  }

  describe 'GET index' do
    let(:image_src2) {
      'https://i2.wp.com/media.boingboing.net/uploads/2020/02/facebook.jpg?fit=600%2C330&ssl=1'
    }
    let(:item2) {
      Item.new('Facebook Title 2', image_src2, Faker::Lorem.paragraph)
    }
    let!(:items) { [item1, item2] }

    before do
      allow(Rails.cache).to receive(:fetch).and_return(ProcessLatestItemsSuccessCommand.call(items))
    end

    subject(:do_request) { get :index }

    it 'renders index template' do
      do_request

      expect(response).to have_http_status(:success)
      expect(response).to render_template('index')
    end

    it 'assigns @items' do
      do_request

      expect(response).to have_http_status(:success)
      expect(assigns(:items)).to eq items
    end
  end

  describe 'GET show' do
    context 'when item exist' do
      let(:valid_id) { 'Facebook_Title_1' }

      subject(:do_request) { get :show, params: { id: valid_id } }

      before do
        allow(Rails.cache).to receive(:fetch).and_return(ProcessLatestItemsSuccessCommand.call([item1]))
      end

      it 'renders show template' do
        do_request

        expect(response).to have_http_status(:success)
        expect(response).to render_template('show')
      end

      it 'assigns @item' do
        do_request

        expect(response).to have_http_status(:success)
        expect(assigns(:item)).to eq item1
      end
    end

    context 'when item does not exist' do
      let(:invalid_id) { 'Invalid_ID' }

      subject(:do_request) { get :show, params: { id: invalid_id } }

      before do
        allow(Rails.cache).to receive(:fetch).and_return(ProcessLatestItemsSuccessCommand.call([item1]))
      end

      it 'renders index template' do
        do_request

        expect(response).to have_http_status(:success)
        expect(response).to render_template('index')
      end
    end
  end
end
