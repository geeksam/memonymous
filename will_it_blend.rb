require 'rubygems'
require 'memonymous'

class FrankSinatra
  attr_reader :call_count
  def dont_be_afraid_you_can_call_me
    @call_count ||= 0
    @call_count += 1
  end
end

class MemoizedFrankSinatra < FrankSinatra
  include Memonymous
  memoize :dont_be_afraid_you_can_call_me
end

naked_frank = FrankSinatra.new
3.times do
  naked_frank.dont_be_afraid_you_can_call_me
end
p naked_frank.call_count # => 3

memoized_frank = MemoizedFrankSinatra.new
3.times do
  memoized_frank.dont_be_afraid_you_can_call_me
end
p memoized_frank.call_count # => 1
