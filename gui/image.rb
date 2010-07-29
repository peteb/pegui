require 'rubygems'
require 'gosu'

require 'pruby'
require 'gui/component'
require 'matrix'


class Image < Component
	def initialize(bounds, filename, window)
		super(bounds)
		@image = Gosu::Image.new(window, filename, false)
	end
	
	def paint(window, globalBounds)
		@image.draw(globalBounds.corner[0], globalBounds.corner[1], 0)
	end
	
	
	
end
