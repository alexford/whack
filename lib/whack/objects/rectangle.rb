require_relative './base.rb'

module Whack
  class Objects::Rectangle < Whack::Objects::Base
    attr_accessor :x, :y, :w, :h

    def initialize(x, y, w, h, color = Color::WHITE)
      super(x, y)
      @w = w
      @h = h
      @color = color
    end

    def draw
      draw_rect(@x, @y, @w, @h, @color)
    end
  end
end
