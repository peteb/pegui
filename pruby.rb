
# defines some smalltalk-like behavior

class Range
	def at_random
		array = self.to_a;
		array.at_random
	end
end

class Array
	def at_random
		self[rand(self.size)];
	end
end

class Object
	def if
		yield self if self
	end
end
