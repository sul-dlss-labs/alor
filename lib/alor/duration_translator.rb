# frozen_string_literal: true

module Alor
  # DurationTranslator translates a YouTube video duration string into a human-readable format
  # Ex: PT1H2M3S -> 01:02:03
  class DurationTranslator
    def self.translate(duration)
      new(duration).translate
    end

    def initialize(duration)
      @duration = duration
    end

    def translate
      return '00:00:00' if @duration.nil? || @duration == 'P0D'

      @duration.match(/PT(\d+H)?(\d+M)?(\d+S)?/).captures.map { |x| x.to_i.to_s.rjust(2, '0') }.join(':')
    end
  end
end
