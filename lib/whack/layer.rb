module Whack
  class Layer < Array
    include Whack::Backend

    def self.from_layer(layer, order: nil)
      (layer.is_a?(self) ? layer : self.new(layer)).tap do |new_layer|
        new_layer.order ||= order
      end
    end

    attr_accessor :order
    alias_method :objects, :entries

    def initialize(*args, order: Whack::LAYER_ORDER_MAIN, offset: [0,0])
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

    def draw
      translate(*offset) do
        objects.each do |object|
          object.draw
        rescue => e
          # TODO: what to do when an object fails to draw?
          puts e
        end
      end
    end
  end
end
