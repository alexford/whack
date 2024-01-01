# frozen_string_literal: true

require_relative 'rectangle'

module Whack
  module Objects
    class RectangleVectors < Whack::Objects::Rectangle
      def initialize(*args)
        super(*args)
        @last_x = @x
        @last_y = @y
      end

      def draw
        if @w > 2
          draw_rect(@last_x, @last_y, @w, @h, Color::BLUE)
          @last_x = @x
          @last_y = @y
        end
        super
      end
    end
  end
end
