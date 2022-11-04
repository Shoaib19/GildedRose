# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'pry'
describe GildedRose do
  describe '#update_quality' do
    context 'when item is Sulfuras' do
      it 'should set item quality to 80' do
        items = [Item.new('Sulfuras', 0, 0)]
        described_class.new(items).update_quality
        expect(items[0].quality).to eq 80
      end
    end

    context 'when item is Aged Brie' do
      it 'should increase item quality by 1' do
        items = [Item.new('Aged Brie', 2, 30)]
        described_class.new(items).update_quality
        expect(items[0].quality).to eq 31
        expect(items[0].sell_in).to eq 1
      end
    end

    context 'when item is Backstage passes' do
      context 'when concert is ended' do
        it 'should set item quality to 0' do
          items = [Item.new('Backstage passes', 0, 20)]
          described_class.new(items).update_quality
          expect(items[0].quality).to eq 0
          expect(items[0].sell_in).to eq '-1'.to_i
        end
      end

      context 'when concert is 5 or less day closer' do
        it 'should increase item quality by 3' do
          items = [Item.new('Backstage passes', 3, 26)]
          described_class.new(items).update_quality
          expect(items[0].quality).to eq 29
          expect(items[0].sell_in).to eq 2
        end
      end

      context 'when concert is 10 or less day closer' do
        it 'should increase item quality by 2' do
          items = [Item.new('Backstage passes', 7, 33)]
          described_class.new(items).update_quality
          expect(items[0].quality).to eq 35
          expect(items[0].sell_in).to eq 6
        end
      end
    end

    context 'when item is Conjured' do
      it 'should decrease item quality by 2' do
        items = [Item.new('Conjured', 10, 32)]
        described_class.new(items).update_quality
        expect(items[0].quality).to eq 30
        expect(items[0].sell_in).to eq 9
      end
    end

    context 'when item is normal' do
      context 'when sell_in has passed' do
        it 'should decrease item quality by 2' do
          items = [Item.new('foo', 0, 40)]
          described_class.new(items).update_quality
          expect(items[0].quality).to eq 38
          expect(items[0].sell_in).to eq '-1'.to_i
        end
      end

      context 'when item still have days to sell' do
        it 'should decrease item quality by 1' do
          items = [Item.new('bar', 41, 40)]
          described_class.new(items).update_quality
          expect(items[0].quality).to eq 39
          expect(items[0].sell_in).to eq 40
        end
      end
    end
  end
end
