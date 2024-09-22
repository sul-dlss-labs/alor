# frozen_string_literal: true

require 'google/apis/youtube_v3'

module Youtube
  # Channel encapsulates the data and methods for a YouTube channel
  class Video
    # TODO: Refactor to take details hash
    def initialize(channel_id:, video_id:, details: {})
      @channel_id = channel_id
      @video_id = video_id
      @details = details
    end

    attr_reader :channel_id, :video_id, :details

    def video_data
      @video_data ||= JSON.parse(fetch_video_data)
    end

    def asr_languages
      asr_caption_tracks = video_data['captions'].select { |caption| caption['snippet']['track_kind'] == 'asr' }
      asr_caption_tracks.map { |caption| caption['snippet']['language'] }.join(', ')
    end

    def captioned?
      video_data['content_details']['caption']
    end

    def duration
      DurationTranslator.translate(video_data['content_details']['duration'])
    end

    def edited_languages
      edited_caption_tracks = video_data['captions'].reject { |caption| caption['snippet']['track_kind'] == 'asr' }
      edited_caption_tracks.map { |caption| caption['snippet']['language'] }.join(', ')
    end

    def title
      video_data['title']
    end

    def view_count
      video_data['statistics']['view_count']
    end

    private

    def fetch_video_data
      CacheHandler.fetch(video_id) do
        [
          details,
          youtube_client.video_data(video_id).items.first.to_h,
          { captions: youtube_client.caption_data(video_id).items.map(&:to_h) }
        ].reduce(&:merge).to_json
      end
    end

    def youtube_client
      @youtube_client ||= Client.new(channel_id:)
    end
  end
end
