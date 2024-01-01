require 'gosu'

module Whack
  class Objects::Base
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
