# frozen_string_literal: true

module Youtube
  # Handler manages the caching of YouTube API responses
  class CacheHandler
    def self.fetch(key, &)
      new(key).fetch(&)
    end

    def initialize(key)
      @key = key
    end

    attr_reader :key

    def fetch
      File.write(cache_file, yield) unless File.exist?(cache_file)

      File.read(cache_file)
    end

    private

    def cache_file
      "#{Settings.cache.base_path}/#{key}"
    end
  end
end
