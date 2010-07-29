require 'rubygems'
require 'gosu'

require 'gui/component'
require 'gui/slider'

class Checkbox < Component
	include Frames

	attr_accessor :pressed
	
	def initialize(window, bounds, caption)
		super(bounds)
	
		theme = "hud_theme/"
		@tiles = Gosu::Image.load_tiles(window, theme + "checkbox.png", -4, -1, true)
		@renderedText = Gosu::Image.from_text(window, caption, "Lucida Grande Bold", 14, 14, bounds.width, :left)
		@pressed = false
		@mouse_down = false
		@selected = false
	end
	
	def paint(window, globalBounds)
		correctTile = 0 unless @pressed
		correctTile = 2 if @pressed
		correctTile += 1 if @mouse_down
		
		@tiles[correctTile].draw(globalBounds.corner[0], globalBounds.corner[1] + 2, 0)
		@renderedText.draw(globalBounds.corner[0] + @tiles[0].width + 5, globalBounds.corner[1] + 2, 0)
	end
	
	def clicked(coord, button)	
		@pressed = !@pressed
	end
	
	def mouse_down(coord, button)
		@mouse_down = true
		@selected = true
	end
	
	def mouse_up(coord, button)
		@mouse_down = false
		@selected = false
	end
	
	def mouse_entered
		@mouse_down = true if @selected
	end
	
	def mouse_left
		@mouse_down = false if @selected
	end
end