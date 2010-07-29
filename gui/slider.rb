require 'rubygems'
require 'gosu'
require 'pruby'

require 'gui/component'

class Slider < Component
	include Frames
	
	def initialize(window, bounds, minSize = Vector[-1, -1], maxSize = Vector[-1, -1])
		super(bounds)
	
		theme = "hud_theme/"
		@min_size = minSize
		@max_size = maxSize
		@pic = Gosu::Image.load_tiles(window, theme + "vscroll_slider.png", -1, -3, true)
		
		@listeners = []
	end
	
	def paint(window, globalBounds)
		draw_tiled_frame(@pic, self, globalBounds, :vertical)
		
	end
	
	def subscribe(&listener) 
		@listeners << listener
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
			x = pos[0]
			y = pos[1]
			
			x = [x, @min_size[0]].max if @min_size[0] != -1
			y = [y, @min_size[1]].max if @min_size[1] != -1
			x = [x, @max_size[0] - bounds.width].min if @max_size[0] != -1
			y = [y, @max_size[1] - bounds.height].min if @max_size[1] != -1
			
			bounds.corner = Vector[x, y]
			
			@listeners.each {|x| x.call()}
			#@parent.resize(bounds.corner[0] + @offset[0], bounds.corner[1] + @offset[1])
		end
		
		super(coord)
	end
	
end