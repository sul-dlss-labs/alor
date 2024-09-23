# frozen_string_literal: true

module Youtube
  # ReportWriter writes the report to a date stamped CSV file
  class ReportWriter
    def initialize(channel_id:, headers:, data:)
      @channel_id = channel_id
      @headers = headers
      @data = data
    end

    attr_reader :channel_id, :headers, :data

    def write_report
      FileUtils.mkdir_p(Settings.reports.base_path) unless File.directory?(Settings.reports.base_path)

      CSV.open(report_filepath, 'w') do |csv|
        csv << headers
        data.each { |row| csv << row }
      end
    end

    private

    def report_filepath
      File.join(Settings.reports.base_path, report_filename)
    end

    def report_filename
      "#{channel_id}-#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
    end
  end
end
