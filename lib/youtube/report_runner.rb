# frozen_string_literal: true

module Youtube
  # ReportRunner runs the selected report for the YouTube channel
  class ReportRunner
    def initialize(channel_id:)
      @channel_id = channel_id
    end

    attr_reader :channel_id

    def caption_report_for_channel
      ReportWriter.new(channel_id:,
                       headers: caption_report_headers,
                       data: caption_report_data).write_report
    end

    private

    def caption_report_headers
      ['Video ID', 'Title', 'Duration', 'Views', 'Captioned', 'ASR Languages', 'Edited Languages']
    end

    def caption_report_data
      [].tap do |data|
        youtube_client.videos.each do |video|
          puts "#{video.video_id} - Title: #{video.title}"
          data << [video.video_id, video.title, video.duration, video.view_count,
                   video.captioned?, video.asr_languages, video.edited_languages]
        end
      end
    end

    def youtube_client
      @youtube_client ||= Youtube::Channel.new(channel_id:)
    end
  end
end
