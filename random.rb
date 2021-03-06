#!/usr/bin/ruby

# A class to generate pseudo-random (unique, non-sequential)
# numbers based on a fixed size pool
#
# Initialize an instance by passing in the starting size of the "pool."
#
# The "pool" is an array of the "random" numbers (generated by Kernel.rand)
# the instance has seen so far that are within the range of 0 to one less
# than the size passed to the constructor.
#
# Note: We could further code the Kernel.rand calls to pass a min, max range
# of only numbers greater than, or less than the current number that matches
# one already in the pool. This is probably premature optimization, plus
# it would lower entropy and the whole point of this is to go for a higher
# overall distribution within a fixed set.

# scroll to bottom for sample usage

class Rand

	attr_accessor :size

	def initialize(size)
		@size = size
		@seen = []
	end

	# when size is reset manually, we forget the previously
	# seen numbers and start over, avoiding only the last seen
	def size=(size)
		@size = size
		@seen = []
	end

	def next
		# we need at least one new "random" number from the pool
		r = Kernel.rand(@size)

		# if the pool is exhausted, forget everything we've seen
		# except for the last seen number
		if @seen.size >= @size
			# new pool starts with number at least two away from last seen
			while r == @seen.last || r == @seen.last - 1 || r == @seen.last + 1 
				r = Kernel.rand(@size)
			end
			@seen = [r]
		# otherwise get the next available "random" number
		else
			while @seen.include?(r) 
				r = Kernel.rand(@size)
			end
			@seen << r
		end

		return r
	end

end


# sample use 
if __FILE__ == $0

	# create a pool of size 10
	r = Rand.new(10)

	# get ten "random" numbers
	o = []
	10.times { o << r.next }
	p(o)

	# dynamically change the size of the pool to 20
	o = []
	r.size = 20
	20.times { o << r.next }
	p(o)

	# get another 50...check out distribution.rb in this dir for live
	# comparison with Kernel.rand...our distribution is much more
	# irregular. yayz!
	o = []
	50.times { o << r.next }
	p(o)

end

