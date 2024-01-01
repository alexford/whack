# frozen_string_literal: true

module Whack
  class Layer < Array
    def self.from_layer(layer, order: nil)
      (layer.is_a?(self) ? layer : new(layer)).tap do |new_layer|
        new_layer.order = order if order
      end
    end

    attr_accessor :order
    alias objects entries

    def initialize(*args, order: Whack::LAYER_ORDER_MAIN, offset: [0, 0])
      super(*args)
      @order = order
      @offset_x, @offset_y = offset
    end

    def offset
      [@offset_x, @offset_y]
    end

    def offset=(args)
      @offset_x, @offset_y = args
    end

    def draw(backend: Whack::Backend)
      backend.translate(*offset) do
        objects.each do |object|
          object.draw
        rescue StandardError => e
          # TODO: what to do when an object fails to draw?
          puts e
        end
      end
    end
  end
end
