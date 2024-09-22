# frozen_string_literal: true

require 'csv'
require 'config'
require 'debug'

namespace :youtube do
  desc 'YouTube Video Captions Report'
  task :caption_report, [:channel_id] do |_t, args|
    args.with_defaults(channel_id: Settings.youtube.channel_id)

    CSV.open('tmp/video_report.csv', 'w') do |csv|
      csv << ['Video ID', 'Title', 'Duration', 'Views', 'Captioned', 'ASR Languages', 'Edited Languages']

      # Output the video data to a csv file
      Youtube::Channel.new(channel_id: args[:channel_id]).videos.each do |video|
        puts "#{video.video_id} - Title: #{video.title}"
        csv << [
          video.video_id,
          video.title,
          video.duration,
          video.view_count,
          video.captioned?,
          video.asr_languages,
          video.edited_languages
        ]
      end
    end
  end
end
