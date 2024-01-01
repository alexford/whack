# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.setup

require 'gosu'

# TODO: why is this required for the constants to get added,
# but VERSION from version.rb is already there?
require_relative 'whack/constants'

module Whack
  Backend = Gosu
end
