# frozen_string_literal: true

require 'csv'
require 'config'
require 'debug'

namespace :youtube do
  desc 'YouTube Video Captions Report'
  task :caption_report, [:channel_id] do |_t, args|
    args.with_defaults(channel_id: Settings.youtube.channel_id)

    CSV.open('tmp/video_report.csv', 'w') do |csv|
      csv << ['Video ID', 'Title', 'Duration', 'Captioned', 'Views']

      # Output the video data to a csv file
      Youtube::Channel.new(channel_id: args[:channel_id]).videos.each do |video|
        video_id = video['id']['videoId']
        puts "#{video_id} - Title: #{video['snippet']['title']}"
        video_data = Youtube::Video.new(channel_id: args[:channel_id], video_id:).video_data

        csv << [
          video_id,
          video['snippet']['title'],
          Alor::DurationTranslator.translate(video_data['content_details']['duration']),
          video_data['content_details']['caption'],
          video_data['statistics']['view_count']
        ]
      end
    end
  end
end
