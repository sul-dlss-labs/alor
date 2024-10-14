# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Youtube::CacheHandler do
  let(:cache_file) { 'tmp/storage/cache/video' }
  let(:api_response) { File.read('spec/fixtures/video.json') }
  let(:key) { 'video' }

  before do
    allow(Settings.cache).to receive(:base_path).and_return('tmp/storage/cache')
    FileUtils.mkdir_p('tmp/storage/cache')
  end

  after do
    FileUtils.rm_rf('tmp/storage/cache')
  end

  describe '.fetch' do
    context 'when the file is not in the cache' do
      it 'writes the file and returns the content' do
        expect(File).not_to exist(cache_file)
        described_class.fetch(key) { api_response }
        expect(File).to exist(cache_file)
        expect(File.read(cache_file)).to eq(api_response)
      end
    end

    context 'when the file is already in the cache' do
      before do
        File.write(cache_file, api_response)
      end

      it 'returns the cached content' do
        allow(File).to receive(:write)
        expect(File).to exist(cache_file)
        described_class.fetch(key) { api_response }
        expect(File.read(cache_file)).to eq(api_response)
        expect(File).not_to have_received(:write).with(cache_file, api_response)
      end
    end
  end
end
