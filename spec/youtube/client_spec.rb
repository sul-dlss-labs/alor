# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Youtube::Client do
  subject { described_class.new(channel_id:) }

  let(:channel_id) { 'channel' }
  let(:channel_data) { File.read('spec/fixtures/api_channel_response.json') }
  let(:video_list) { JSON.parse(File.read('spec/fixtures/api_videos_response.json'))['items'] }
  let(:search_response) { instance_double(Google::Apis::YoutubeV3::SearchListsResponse, items: video_list, next_page_token: nil) }
  let(:client) { instance_double(Google::Apis::YoutubeV3::YouTubeService, list_channels: channel_data, list_searches: search_response) }

  before do
    allow(Google::Apis::YoutubeV3::YouTubeService).to receive(:new).and_return(client)
    allow(client).to receive(:key=)
  end

  describe '.channel_data' do
    it 'retrieves channel data' do
      expect(subject.channel_data).to eq(channel_data)
    end
  end

  describe '.videos' do
    it 'retrieves list of videos for the channel' do
      expect(subject.videos).to eq(video_list)
    end
  end
end
