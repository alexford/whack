# frozen_string_literal: true

require "spec_helper"

describe Whack do
  describe '::VERSION' do
    it 'has a version number' do
      expect(Whack::VERSION).not_to be_empty
    end
  end
end
