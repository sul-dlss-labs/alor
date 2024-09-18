# frozen_string_literal: true

module Alor
  class DurationTranslator
    def self.translate(duration)
      new(duration).translate
    end

    def initialize(duration)
      @duration = duration
    end

    def translate
      return '00:00:00' if @duration.nil? || @duration == 'P0D'

      hours, minutes, seconds = @duration.match(/PT(\d+H)?(\d+M)?(\d+S)?/).captures.map { |x| x.to_i }

      "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
    end
  end
end