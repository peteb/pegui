require 'rubygems'
require 'gosu'

require 'gui/component'
require 'gui/slider'

class Scrollview < Component
	include Frames

	
	def initialize(window, bounds)
		super(bounds)
	
		@content = Component.new(Rectangle.new(Vector[0, 0], bounds.width - 12, bounds.height))
		add_component @content
	end
	
	
	def onSliderUpdate
		percentHeight = @slider.bounds.corner[1].to_f / (bounds.height.to_f - @slider.bounds.height.to_f)
		percentHeight = [percentHeight, 1.0].min
		fixedY = -(@content.bounds.height.to_f - @content.parent.bounds.height.to_f) * percentHeight
		
		@content.bounds.corner = Vector[@content.bounds.corner[0], fixedY.to_i]
	end
end