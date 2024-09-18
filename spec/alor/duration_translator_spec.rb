# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Alor::DurationTranslator do
  describe '.translate' do
    context 'when the duration is nil' do
      it 'returns 00:00:00' do
        expect(described_class.translate(nil)).to eq('00:00:00')
      end
    end

    context 'when the duration is P0D' do
      it 'returns 00:00:00' do
        expect(described_class.translate('P0D')).to eq('00:00:00')
      end
    end

    context 'when the duration is PT1H2M3S' do
      it 'returns 01:02:03' do
        expect(described_class.translate('PT1H2M3S')).to eq('01:02:03')
      end
    end

    context 'when the duration is PT10H20M30S' do
      it 'returns 10:20:30' do
        expect(described_class.translate('PT10H20M30S')).to eq('10:20:30')
      end
    end
  end
end