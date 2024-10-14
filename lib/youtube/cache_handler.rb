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
      File.write(cache_file, yield) unless valid_cache?

      File.read(cache_file)
    end

    private

    def cache_file
      "#{Settings.cache.base_path}/#{key}"
    end

    # Returns the age of the cache file in days
    def cache_file_age
      ((Time.now - File.mtime(cache_file)) / 86_400).to_i
    end

    def valid_cache?
      return false unless File.exist?(cache_file)
      
      cache_file_age < Settings.cache.expiry_days
    end
  end
end
