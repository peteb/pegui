require 'rubygems'
require 'gosu'

require 'pruby'
require 'gui/component'
require 'gui/frames'

class Button < Component
	include Frames
	
	def initialize(window, bounds, caption)
		super(bounds)
		
		@caption = caption
		@font = Gosu::Font.new(window, "Lucida Grande", 13)
		@fontColor = 0xFFFFFFFF
		@focusable = false
		
		theme = "hud_theme/"
		
		@states = {:up=>Gosu::Image.load_tiles(window, theme + "button_normal.png", -3, -1, true),
			:down=>Gosu::Image.load_tiles(window, theme + "button_pressed.png", -3, -1, true)}
			
		@renderedText = Gosu::Image.from_text(window, caption, "Lucida Grande Bold", 14, 14, bounds.width - 10, :center)
		
		@currentState = :up
		@mouseDown = false
	end

	def paint(window, globalBounds)
		# draw_quad_frame(window, @currentBgcolor)
		#startY = globalBounds.corner[1] + globalBounds.height / 2.0 - @states[@currentState][0].height / 2.0
		#centeredBounds = Rectangle.new(Vector[globalBounds.corner[0], startY.to_i], globalBounds.width, globalBounds.height)
		
		draw_tiled_frame(@states[@currentState], self, globalBounds)
			centerX = globalBounds.corner[0] + globalBounds.width / 2
			centerY = globalBounds.corner[1] + @states[@currentState][0].height / 2 - 2
			textHalfWidth = @renderedText.width / 2
			textHalfHeight = @renderedText.height / 2
			@renderedText.draw((centerX - textHalfWidth).to_i, (centerY - textHalfHeight + 8).to_i, 0, 1, 1, @fontColor)
		# end

		# draw_line_frame(window, Gosu::Color.new(255, 0, 0, 0))
	end
	
	def mouse_down(coord, button)
		@currentState = :down
		@mouseDown = true
	end
	
	def mouse_up(coord, button)
		@currentState = :up
		@mouseDown = false
	end
	
	def clicked(coord, button)	
		puts "Clicked  " + @caption + " " + button.to_s + " @ " + coord.to_s
	#	bounds.corner = Vector[bounds.corner[0], (1..@parent.bounds.height - bounds.height).at_random]
	end
	
	def mouse_entered
		puts "mouse enter " + @caption
		@currentState = :down if @mouseDown
	end
	
	def mouse_left
		puts "mouse leave " + @caption
		@currentState = :up if @mouseDown
	end
	
	def mouse_move(coord)
		
	end
end
