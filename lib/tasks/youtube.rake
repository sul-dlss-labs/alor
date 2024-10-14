# frozen_string_literal: true

require 'csv'
require 'config'
require 'debug'

require_relative '../../config/boot'

namespace :youtube do
  task :display_channel_data, [:channel_id] do |_t, args|
    args.with_defaults(channel_id: Settings.youtube.channel_id)
    channel = Youtube::Channel.new(channel_id: args[:channel_id])

    puts "Title: #{channel.title}"
    puts "URL: #{channel.url}"
    puts "Custom URL: #{channel.custom_url}"
  end

  desc 'Harvest YouTube Video Captions'
  task harvest_caption_files: :environment do
    # Initialize the YouTube API client
    youtube = Youtube::Client.new

    list_of_channel_videos = JSON.parse(File.read('tmp/out.json'))

    FileUtils.mkdir_p('tmp/caption_files')

    # Print the video data
    list_of_channel_videos.each do |video|
      video_id = video['id']['videoId']
      caption_data = JSON.parse(File.read("tmp/captions/#{video_id}.json"))
      caption_id = caption_data.present? ? caption_data['id'] : nil
      next unless caption_id.present?

      File.open("tmp/caption_files/#{video_id}.xml", 'w') do |f|
        yt_data = youtube.download_caption(caption_id)
        f.write(yt_data)
      end
    end
  end
end
