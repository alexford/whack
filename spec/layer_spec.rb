# frozen_string_literal: true

require "spec_helper"

describe Whack::Layer do
  describe '#initialize' do
    it 'accepts an Array literal and sets defaults' do
      layer = described_class.new([1,2,3])
      expect(layer.objects).to eq [1,2,3]

      # default order and offset
      expect(layer.order).to eq Whack::LAYER_ORDER_MAIN
      expect(layer.offset).to eq [0,0]
    end

    it 'accepts order and offset as keyword arguments' do
      layer = described_class.new([1,2,3], order: 10, offset: [10,20])

      # default order and offset
      expect(layer.order).to eq 10
      expect(layer.offset).to eq [10,20]
    end

    describe 'nifty initializations inherited from Array' do
      # Sanity-check that normal Array stuff works in combination with our
      # additional kwargs
      it 'accepts a length and a block' do
        layer = described_class.new(5, order: 10, offset: [1,2]) { |i| i }

        expect(layer).to eq [0,1,2,3,4]
        expect(layer.order).to eq 10
        expect(layer.offset).to eq [1,2]
      end

      it 'accepts a length' do
        layer = described_class.new(3, order: 10, offset: [1,2])

        expect(layer).to eq [nil, nil, nil]
        expect(layer.order).to eq 10
        expect(layer.offset).to eq [1,2]
      end

      it 'accepts a length and a value' do
        layer = described_class.new(3, 'foo', order: 10, offset: [1,2])

        expect(layer).to eq ['foo','foo','foo']
        expect(layer.order).to eq 10
        expect(layer.offset).to eq [1,2]
      end
    end

  end

  describe '#offset=' do
    let(:layer) { described_class.new([1,2,3]) }

    it "accepts an [x,y] array" do
      layer.offset = [10,20]
      expect(layer.offset).to eq [10,20]
    end

    it "accepts separate x,y args" do
      layer.offset = 20,30
      expect(layer.offset).to eq [20,30]
    end
  end

  describe '#draw' do
    let(:objects) { [double, double, double] }
    let(:layer) { described_class.new(objects, offset: [20,30]) }

    let(:mock_backend) { class_double(Whack::Backend) }

    before do
      allow(mock_backend).to receive(:translate).and_yield
      objects.each { |o| allow(o).to receive(:draw) }
    end

    it 'uses backend.translate using the offset' do
      layer.draw(backend: mock_backend)
      expect(mock_backend).to have_received(:translate).with(20, 30)
    end

    it 'calls #draw on each object' do
      layer.draw(backend: mock_backend)
      objects.each { |o| expect(o).to have_received(:draw).once }
    end
  end

  describe '.from_layer' do
    let(:layer) { [1,2,3] }
    let(:order) { nil }

    subject { described_class.from_layer(layer, order: order) }

    context 'when the input is an array' do
      it 'returns a Whack::Layer with the contents' do
        expect(subject).to be_a Whack::Layer
        expect(subject.objects).to eq [1,2,3]
        expect(subject.order).to eq Whack::LAYER_ORDER_MAIN # default
      end

      context 'when the order argument is passed' do
        let(:order) { 12 }

        it 'sets order on the new Whack::Layer' do
          expect(subject.order).to eq 12
        end
      end
    end

    context 'when the input is a Whack::Layer' do
      let(:layer) { described_class.new([4,5,6], order: 12) }

      it 'returns that layer' do
        expect(subject).to be layer
        expect(subject.objects).to eq [4,5,6]
        expect(subject.order).to eq 12 # does not reset to default
      end

      context 'when the order argument is passed' do
        let(:order) { 25 }

        it 'sets order on the Whack::Layer' do
          expect(subject).to be layer
          expect(subject.order).to eq 25
        end
      end
    end
  end
end
