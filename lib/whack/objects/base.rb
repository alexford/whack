# frozen_string_literal: true

require 'gosu'

module Whack
  module Objects
    class Base
      include Whack::Backend

      attr_accessor :x, :y

      def initialize(x, y)
        @x = x
        @y = y
      end

      def draw
        # Should be overriden
        draw_rect(@x, @y, @x, @y, Color::WHITE)
      end
    end
  end
end
