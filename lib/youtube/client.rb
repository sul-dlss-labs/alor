# frozen_string_literal: true

require 'google/apis/youtube_v3'

module Youtube
  # Client exposes the query methods for the YouTube_v3 API
  class Client
    def initialize(channel_id:)
      @id = channel_id
      youtube_client.key = Settings.youtube.api_key
      youtube_client
    end

    attr_reader :id

    def youtube_client
      @youtube_client ||= Google::Apis::YoutubeV3::YouTubeService.new
    end

    def channel_data
      youtube_client.list_channels('snippet', id:)
    end

    def videos
      page_token = nil
      [].tap do |videos|
        loop do
          results = fetch_videos(page_token:)
          videos << results.items # .map(&:to_h)
          page_token = results.next_page_token
          break if page_token.nil?
        end
      end.flatten
    end

    def video_data(id)
      youtube_client.list_videos('contentDetails,statistics', id:)
    end

    def caption_data(id)
      youtube_client.list_captions('id,snippet', id)
    end

    private

    def fetch_videos(page_token:)
      youtube_client.list_searches('snippet',
                                   channel_id: id,
                                   type: 'video',
                                   video_caption: 'any',
                                   page_token:)
    end
  end
end
