require 'rubygems'
require 'gosu'

require 'gui/component'
require 'gui/slider'

class Scrollbar < Component
	include Frames

	
	def initialize(window, bounds, content)
		super(bounds)
	
		theme = "hud_theme/"
		@content = content
		@transparent = Gosu::Image.load_tiles(window, theme + "vscroll_trans.png", -1, -3, true)
	
		@slider = Slider.new(window, Rectangle.new(Vector[0, 0], bounds.width, 40), Vector[0, 0],  Vector[bounds.width, bounds.height])
		add_component @slider
		@slider.subscribe &self.method(:onSliderUpdate)
		update
	end
	
	# TODO: klicka i scrollbaren
	# TODO: ScrollView, har content och scrollbar utanför. ser till att scroll med hjulet funkar också
	# 		  ScrollView:en är focusable, men inget annat är, förutom textlåda. fönster är focusable
	# 		  ScrollView har en contentarea, som man assignar.
	
	def paint(window, globalBounds)
		#update
		draw_tiled_frame(@transparent, self, globalBounds, :vertical)
		
	end
	
	def update
		contentHeightPercent = @content.bounds.height.to_f / @content.parent.bounds.height.to_f
		contentStart = @content.bounds.corner[1] / (@content.bounds.height - @slider.bounds.height).to_f
		@slider.bounds.height = [bounds.height.to_f / contentHeightPercent, 13].max
		@slider.bounds.corner = Vector[@slider.bounds.corner[0], contentStart * -bounds.height.to_f]
	end
	
	def onSliderUpdate
		percentHeight = @slider.bounds.corner[1].to_f / (bounds.height.to_f - @slider.bounds.height.to_f)
		percentHeight = [percentHeight, 1.0].min
		fixedY = -(@content.bounds.height.to_f - @content.parent.bounds.height.to_f) * percentHeight
		
		@content.bounds.corner = Vector[@content.bounds.corner[0], fixedY.to_i]
	end
end