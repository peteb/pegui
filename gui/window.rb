require 'rubygems'
require 'gosu'

require 'pruby'
require 'gui/component'
require 'gui/frames'
require 'gui/corner_handle'

class Window < Component
	include Frames
	
	def initialize(window, bounds, caption)
		super(bounds)
		
		@caption = caption
		@font = Gosu::Font.new(window, "Lucida Grande", 13)
		@fontColor = 0xFFFFFFFF
		@window = window
		
		theme = "hud_theme/"
		
		# @states = {:up=>Gosu::Image.load_tiles(window, theme + "button_normal.png", -3, -1, true),
		# 	:down=>Gosu::Image.load_tiles(window, theme + "button_pressed.png", -3, -1, true)}
			
		@content = Component.new(Rectangle.new(Vector[15, 30], bounds.width - 20, bounds.height - 40))
		@corner = CornerHandle.new(Rectangle.new(Vector[bounds.width - 25, bounds.height - 27], 18, 15), self, Vector[150, 100])
		@content.focusable = false
		@content.delegate = self
		
		_add_border_component @content
		_add_border_component @corner		
		
		@renderedText = Gosu::Image.from_text(window, caption, "Lucida Grande Bold", 16, 16, bounds.width - 10, :center)
		@tiles = Gosu::Image.load_tiles(window, theme + "window_focus.png", -3, -3, true)
		
		resize(bounds.width, bounds.height)
	end

	def _add_border_component(component)
		children << component
		component._on_add(self)
	end
	
	def add_component(component)
		@content.add_component(component)
	end
	
	def content
		@content
	end
	
	def mouse_down(localCoord, button)
		@pressed = true
		@mouseDownAt = localCoord
	end
	
	def mouse_up(localCoord, button)
		@pressed = false
		@mouseDownAt = nil
	end
	
	def mouse_move(localCoord)
		if @pressed
			pos = bounds.corner + localCoord - @mouseDownAt

			bounds.corner = pos
		end
	end
	
	def resize(width, height)
		super(width, height)
		
		@content.resize(width - @content.bounds.corner[0] * 2.0, height - @content.bounds.corner[1] - @content.bounds.corner[0])
		
		self.caption = "Window - " + width.to_i.to_s + "x" + height.to_i.to_s
	end
	
	def caption=(new_caption)
		@caption = new_caption
		@renderedText = Gosu::Image.from_text(@window, @caption, "Lucida Grande Bold", 14, 14, bounds.width.to_i - 10, :center)
	end
	
	def paint(window, globalBounds)
		draw_tiled_frame(@tiles, self, globalBounds)

		centerX = globalBounds.corner[0] + globalBounds.width / 2
		centerY = globalBounds.corner[1] + @tiles[1].height / 2
		textHalfWidth = @renderedText.width / 2
		textHalfHeight = @renderedText.height / 2
		@renderedText.draw((centerX - textHalfWidth).to_i, (centerY - textHalfHeight + 8).to_i, 0, 1, 1, @fontColor)

		# draw_line_frame(window, Gosu::Color.new(255, 0, 0, 0))
	end
end
