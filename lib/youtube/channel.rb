# frozen_string_literal: true

require 'google/apis/youtube_v3'

module Youtube
  # Channel encapsulates the data and methods for a YouTube channel
  class Channel
    def initialize(channel_id:)
      @channel_id = channel_id
    end

    attr_reader :channel_id

    def title
      channel_detail['title']
    end

    def url
      "https://www.youtube.com/channel/#{channel_id}"
    end

    def custom_url
      "https://www.youtube.com/#{channel_detail['customUrl']}"
    end

    def videos
      channel_data['videos'].map do |video|
        Video.new(channel_id:, video_id: video['id']['videoId'], details: video['snippet'])
      end
    end

    private

    def channel_detail
      @channel_detail ||= channel_data['items'].first['snippet']
    end

    def channel_data
      @channel_data ||= JSON.parse(fetch_channel_data)
    end

    def fetch_channel_data
      CacheHandler.fetch(channel_id) do
        youtube_client.channel_data['videos'] = youtube_client.videos
      end
    end

    def youtube_client
      @youtube_client ||= Client.new(channel_id:)
    end
  end
end
