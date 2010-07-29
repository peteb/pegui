require 'rubygems'
require 'gosu'

require 'gui/component'
require 'gui/slider'

class Grid < Component
	def initialize(bounds)
		super(bounds)
		
		@backgroundColor = 0x11000000
		@gridColor = 0x11C1C1C1
		@sorted_items = []
	end
	
	
	def paint(window, globalBounds)
		accY = 0
		gridLine = false
		cliparea = clip_area
		
		@sorted_items.each do |child|
			color = @backgroundColor if gridLine
			color = @gridColor unless gridLine
			
			cellarea = Rectangle.new(Vector[globalBounds.corner[0], globalBounds.corner[1] + accY], globalBounds.width, child.bounds.height)
			intersect = cellarea.intersection(cliparea)
			
			if intersect.height > 0
				window.draw_quad(
					globalBounds.corner[0], globalBounds.corner[1] + accY, color,
					globalBounds.corner[0] + globalBounds.width, globalBounds.corner[1] + accY, color,
					globalBounds.corner[0] + globalBounds.width, globalBounds.corner[1] + child.bounds.height + 2 + accY, color,
					globalBounds.corner[0], globalBounds.corner[1] + child.bounds.height + 2 + accY, color)
			end
			
			accY += child.bounds.height + 2
			
			gridLine = !gridLine
		end
	end
	
	def _calculateHeight
		@sorted_items.inject(0) {|prev, x| prev + x.bounds.height + 2}
	end
	
	def add_component(component)
		component.bounds.corner = Vector[2, _calculateHeight + 2]
		children << component
		@sorted_items << component
		component._on_add(self)
		bounds.height = _calculateHeight
	end
	
	def button_up(id)
		bounds.corner = Vector[bounds.corner[0], bounds.corner[1] + 20] if id == Gosu::MsWheelUp
		bounds.corner = Vector[bounds.corner[0], bounds.corner[1] - 20] if id == Gosu::MsWheelDown
		
	end
end