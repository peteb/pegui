
require 'gl'
require 'pruby'

include Gl

class Rectangle 
	attr_accessor :corner, :width, :height
	
	def initialize(corner, width, height)
		@corner = corner;
		@width = width
		@height = height;
	end
	
	def to_s
		corner[0].to_s + "x" + corner[1].to_s + "-" + width.to_s + "x" + height.to_s
	end	
	
	def coord_inside?(coord)
		mincoord = min
		maxcoord = max
		
		(coord[0] >= min[0] && coord[0] <= max[0] && coord[1] >= min[1] && coord[1] <= max[1])
	end

	def intersection(otherRect)
		ret = Rectangle.new(otherRect.corner, otherRect.width, otherRect.height)
		ret.corner = Vector[[otherRect.corner[0], @corner[0]].max, [otherRect.corner[1], @corner[1]].max]
		
		maxCorner1 = otherRect.max
		maxCorner2 = self.max
		
		retMaxCorner = Vector[[maxCorner1[0], maxCorner2[0]].min, [maxCorner1[1], maxCorner2[1]].min]
		ret.width = retMaxCorner[0] - ret.corner[0]
		ret.height = retMaxCorner[1] - ret.corner[1]
		
		return ret
	end
	
	def min
		corner
	end
	
	def max
		Vector[corner[0] + width, corner[1] + height]
	end
end
