# frozen_string_literal: true

require 'csv'
require 'google/apis/youtube_v3'
require 'config'

namespace :youtube do
  task display_channel_data: :environment do
    # Initialize the YouTube API client
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.key = Settings.youtube.api_key # Rails.application.credentials.youtube[:api_key]

    # Get the channel ID from the configuration
    channel_id = Settings.youtube.channel_id # Rails.application.config_for(:youtube)['channel_id']

    puts "Testing DurationTranslator: #{Alor::DurationTranslator.translate('PT1H2M3S')}"

    # Get the channel data
    channel_data = youtube.list_channels('snippet', id: channel_id).items.first.snippet
    puts "Channel Data: #{channel_data.title}"
  end

  desc 'Harvest YouTube Channel Data'
  task harvest_channel_data: :environment do
    # Initialize the YouTube API client
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.key = Settings.youtube.api_key # Rails.application.credentials.youtube[:api_key]

    # Get the channel ID from the configuration
    channel_id = Settings.youtube.channel_id # Rails.application.config_for(:youtube)['channel_id']

    # Get the channel data
    # channel_data = youtube.list_channels('snippet', id: channel_id).items.first.snippet

    page_token = nil
    File.open('tmp/out.json', 'w') do |f|
      f.write('[')
      loop do
        # Get the list of videos for the channel
        # -> items
        #    -> id: id.video_id
        videos = youtube.list_searches('snippet', channel_id:, type: 'video', video_caption: "any", page_token:)
        f.write(videos.items.map(&:to_json).join(",\n"))
        page_token = videos.next_page_token
        break if page_token.nil?

        f.write(",\n")
      end
      f.write(']')
    end
  end

  desc 'Harvest YouTube Video Data'
  task harvest_video_data: :environment do
    # Initialize the YouTube API client
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.key = Settings.youtube.api_key # Rails.application.credentials.youtube[:api_key]

    # Get the channel ID from the configuration
    channel_id = Settings.youtube.channel_id # Rails.application.config_for(:youtube)['channel_id']

    list_of_channel_videos = JSON.parse(File.read('tmp/out.json'))

    FileUtils.mkdir_p('tmp/videos')

    # Print the video data
    list_of_channel_videos.each do |video|
      video_id = video['id']['videoId']
      File.open("tmp/videos/#{video_id}.json", 'w') do |f|
        yt_data = youtube.list_videos('contentDetails,statistics', id: video_id).items.first
        puts "#{video_id} - Title: #{video['snippet']['title']}"
        f.write(yt_data.to_json)
      end
    end
  end

  desc 'Harvest YouTube Video Captions'
  task harvest_caption_data: :environment do
    # Initialize the YouTube API client
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.key = Settings.youtube.api_key # Rails.application.credentials.youtube[:api_key]

    # Get the channel ID from the configuration
    channel_id = Settings.youtube.channel_id # Rails.application.config_for(:youtube)['channel_id']

    list_of_channel_videos = JSON.parse(File.read('tmp/out.json'))

    FileUtils.mkdir_p('tmp/captions')

    # Print the video data
    list_of_channel_videos.each do |video|
      video_id = video['id']['videoId']
      File.open("tmp/captions/#{video_id}.json", 'w') do |f|
        yt_data = youtube.list_captions('id,snippet', video_id).items.first
        puts "#{video_id} - Title: #{video['snippet']['title']}"
        f.write(yt_data.to_json)
      end
    end
  end

  desc 'Harvest YouTube Video Captions'
  task harvest_caption_files: :environment do
    # Initialize the YouTube API client
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.key = Settings.youtube.api_key # Rails.application.credentials.youtube[:api_key]

    # Get the channel ID from the configuration
    channel_id = Settings.youtube.channel_id # Rails.application.config_for(:youtube)['channel_id']

    list_of_channel_videos = JSON.parse(File.read('tmp/out.json'))

    FileUtils.mkdir_p('tmp/caption_files')

    # Print the video data
    list_of_channel_videos.each do |video|
      video_id = video['id']['videoId']
      caption_data = JSON.parse(File.read("tmp/captions/#{video_id}.json"))
      caption_id = caption_data.present? ? caption_data['id'] : nil
      if caption_id.present?
        File.open("tmp/caption_files/#{video_id}.xml", 'w') do |f|
          yt_data = youtube.download_caption(caption_id)
          debugger
          f.write(yt_data)
        end
      end
    end
  end

  desc 'YouTube Video Harvest Report'
  task harvest_report: :environment do
    list_of_channel_videos = JSON.parse(File.read('tmp/out.json'))

    CSV.open("tmp/video_report.csv", "w") do |csv|
      csv << ["Video ID", "Title", "Duration", "Captioned", "Views"]
      # Output the video data to a csv file
      list_of_channel_videos.each do |video|
        video_id = video['id']['videoId']
        video_data = JSON.parse(File.read("tmp/videos/#{video_id}.json"))
        puts "#{video_id} - Title: #{video['snippet']['title']}"
        csv << [
          video_id,
          video['snippet']['title'],
          DurationTranslator.translate(video_data['contentDetails']['duration']),
          video_data['contentDetails']['caption'],
          video_data['statistics']['viewCount']
        ]
        # puts "#{video_id} - Title: #{video['snippet']['title']}"
        # puts "  Duration: #{video_data['contentDetails']['duration']}"
        # puts "  Views: #{video_data['statistics']['viewCount']}"
        # puts "  Likes: #{video_data['statistics']['likeCount']}"
        # puts "  Dislikes: #{video_data['statistics']['dislikeCount']}"
        # puts "  Comments: #{video_data['statistics']['commentCount']}"
      end
    end
  end

  desc 'YouTube Video Caption Report'
  task caption_report: :environment do
    list_of_channel_videos = JSON.parse(File.read('tmp/out.json'))

    list_of_channel_videos.each do |video|
      video_id = video['id']['videoId']
      video_data = JSON.parse(File.read("tmp/videos/#{video_id}.json"))
      caption_data = JSON.parse(File.read("tmp/captions/#{video_id}.json"))
      type = caption_data.present? ? caption_data['snippet']['trackKind'] : ''
      puts "#{video_id} - Captions: #{video_data['contentDetails']['caption']}, Type: #{type}"
    end
  end
end  
