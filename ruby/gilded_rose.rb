# frozen_string_literal: true
require 'pry'
# class GildedRose
class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next item.quality = 80 if item.name == 'Sulfuras'

      item.sell_in = decrease_sell_in_days(item.sell_in, 1)
      case item.name
      when 'Aged Brie'
        item.quality = quality_calc(item.quality, { 'inc' => 1 })
      when 'Backstage passes'
        if item.sell_in <= 0
          item.quality = 0
        elsif (1..5).member?(item.sell_in)
          item.quality = quality_calc(item.quality, { 'inc' => 3 })
        elsif (6..10).member?(item.sell_in)
          item.quality = quality_calc(item.quality, { 'inc' => 2 })
        end
      else
        item.quality = if item.name == 'Conjured' || item.sell_in <= 0
                         quality_calc(item.quality, { 'dec' => 2 })
                       else
                         quality_calc(item.quality, { 'dec' => 1 })
                       end
      end
    end
  end

  def decrease_sell_in_days(sell_in, days)
    sell_in - days
  end

  def quality_calc(quality, quality_adjustment)
    case quality_adjustment.keys.first
    when 'inc'
      quality_now = quality + quality_adjustment['inc']
      quality_now <= 50 ? quality_now : 50
    when 'dec'
      quality_now = quality - quality_adjustment['dec']
      quality_now >= 0 ? quality_now : 0
    end
  end
end

# item class
class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
