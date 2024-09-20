# frozen_string_literal: true

require 'google/apis/youtube_v3'

module Youtube
  # Channel encapsulates the data and methods for a YouTube channel
  class Video
    def initialize(channel_id:, video_id:)
      @channel_id = channel_id
      @video_id = video_id
    end

    attr_reader :channel_id, :video_id

    def video_data
      @video_data ||= CacheHandler.fetch(video_id) do
        youtube_client.video_data(video_id).merge(
          { captions: youtube_client.caption_data(video_id).items.map(&:to_h) }
        ).to_json
      end
    end

    private

    def youtube_client
      @youtube_client ||= Client.new(channel_id:)
    end
  end
end
