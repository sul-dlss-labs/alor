# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Youtube::Channel do
  let(:channel_id) { 'channel' }
  let(:channel) { described_class.new(channel_id:) }

  before do
    allow(Settings.cache).to receive(:base_path).and_return('tmp/storage/cache')
    FileUtils.mkdir_p('tmp/storage/cache')
  end

  after do
    FileUtils.rm_rf('tmp/storage/cache')
  end

  context 'when the channel data is in the cache' do
    before do
      FileUtils.cp('spec/fixtures/channel.json', 'tmp/storage/cache/channel')
    end

    it 'returns the cached content' do
      expect(channel.title).to eq('Alphabet Soup Systems & Services Live')
      expect(channel.url).to eq('https://www.youtube.com/channel/channel')
      expect(channel.custom_url).to eq('https://www.youtube.com/@abcdefjghijklmnopqrstuvwxyz')
      expect(channel.videos.size).to eq(1)
    end
  end
end
