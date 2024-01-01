# Proof of concept runner/renderer based on Gosu
# Simple, single threaded: game is called once per update (60hz)

require 'gosu'
require_relative './base.rb'

module Whack
  class Runners::Gosu < Whack::Runners::Base
    def run
      super
      window.show
    end

    def stop
      super
      # TODO: stop loop somehow (some kind of poison?)
    end

    def down_keys
      @window&.down_keys || []
    end

    private

    def window
      @window ||= Window.new(self)
    end

    class Window < Gosu::Window
      private attr_reader :runner
      attr_reader :down_keys

      def initialize(runner)
        @runner = runner
        @down_keys = []
        super runner.env[:window][:width], runner.env[:window][:height]
        self.caption = "Whack Gosu" # TODO: config game name
      end

      def update
        runner.call_game!
      end

      def draw
        update_start = runner.mono_time

        layers.each do |layer|
          layer.draw
          Gosu.flush
        end

        # TODO: rename to draw time
        runner.record_update_time(runner.mono_time - update_start)

        runner.frame += 1
      end

      def button_down(id)
        @down_keys << id
        @down_keys.uniq!
      end

      def button_up(id)
        @down_keys.uniq!
        @down_keys = @down_keys - [id]
      end

      private

      def layers
        (runner.layers || [])
          .reject(&:empty?)
          .map.with_index do |layer, i|
            # Create Whack::Layers from any Arrays, set implicit order value
            Whack::Layer.from_layer(layer, order: i)
          end.sort_by(&:order)
      end
    end
  end
end
