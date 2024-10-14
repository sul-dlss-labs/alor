# frozen_string_literal: true

require 'csv'
require 'config'
require 'debug'

require_relative '../../config/boot'

namespace :youtube do
  desc 'YouTube Video Captions Report'
  task :caption_report, [:channel_id] do |_t, args|
    args.with_defaults(channel_id: Settings.youtube.channel_id)

    Youtube::ReportRunner.new(channel_id: args[:channel_id]).caption_report_for_channel
  end
end
