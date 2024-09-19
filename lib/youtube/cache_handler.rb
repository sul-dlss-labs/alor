# frozen_string_literal: true

module Youtube
  # Handler manages the caching of YouTube API responses
  class CacheHandler
    def self.fetch(key, &block)
      new(key).fetch(&block)
    end

    def initialize(key)
      @key = key
    end

    attr_reader :key

    def fetch
      return JSON.parse(File.read(cache_file)) if File.exist?(cache_file)

      # Yield to the block to get the content
      data = yield.call if block_given?

      File.open(cache_file, 'w') do |f|
        f.write(data)
      end
    end

    private

    def cache_file
      "#{Settings.cache.base_path}/#{key}"
    end
  end
end
