require 'rubygems'
require 'gosu'

require 'pruby'
require 'gui/component'
require 'gui/frames'

class CornerHandle < Component
	include Frames
	
	def initialize(bounds, parent, min_size, max_size = Vector[-1, -1])
		super(bounds)
		@pressed = false
		@offset = Vector[parent.bounds.width - bounds.corner[0], parent.bounds.height - bounds.corner[1]]
		@min_size = min_size
		@max_size = max_size
	end
	
	def paint(window, globalBounds)
		# draw_line_frame(window, 0xFFFF0000, globalBounds)
	end
	
	def mouse_down(coord, button)
		@downAt = coord
		@pressed = (button == :mouse_left)
		
		super(coord, button)
	end

	def mouse_up(coord, button)
		@pressed = !(button == :mouse_left)

		super(coord, button)
	end
	
	def mouse_move(coord)
		if @pressed 
			pos = bounds.corner + coord - @downAt
			
			# diff = parent_bounds.corner + coord - @downAt #coord - @downAt
			# @downAt = parent_bounds.corner + coord
			x = pos[0] + bounds.width
			y = pos[1] + bounds.height
			
			x = [x, @min_size[0]].max if @min_size[0] != -1
			y = [y, @min_size[1]].max if @min_size[1] != -1
			x = [x, @max_size[0]].min if @max_size[0] != -1
			y = [y, @max_size[1]].min if @max_size[1] != -1
			
			bounds.corner = Vector[x - bounds.width, y - bounds.height]
			@parent.resize(bounds.corner[0] + @offset[0], bounds.corner[1] + @offset[1])
		end
		
		super(coord)
	end
	
end
