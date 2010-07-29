require 'rubygems'
require 'gosu'

require 'gl'
require 'pruby'
require 'gui/component'

include Gl

class EventMapper
	def initialize(root)
		@root = root
		@pressedComponents = {}
	end
	
	def mouse_down(globalCoord, button)
		leaf = @root.leaf_for_coord(globalCoord)
		leaf._mouse_down(globalCoord, button)
		leaf.focus!
		@pressedComponents[button] = leaf
	end
	
	def mouse_up(globalCoord, button)
		@pressedComponents[button]._mouse_up(globalCoord, button) if @pressedComponents[button]
		@pressedComponents[button] = nil	
	end
	
	def mouse_move(globalCoord)
		componentsPressed = @pressedComponents.values.select {|x| x}
		if componentsPressed.empty?		# no pressed components for any mouse buttons
			if @lastMousePos
				if (globalCoord - @lastMousePos).r >= 0.5
					@lastMousePos = globalCoord
					_mouse_move(globalCoord)
				end
			else
				@lastMousePos = globalCoord
				_mouse_move(globalCoord)		
			end 
		else		# a component is pressed
			leaf = @root.leaf_for_coord(globalCoord)

			componentsPressed.each do |x| 
				x._mouse_move(globalCoord)
				
				if leaf != @lastLeaf && (@lastLeaf == x || leaf == x)
					x.mouse_left if @lastLeaf
					leaf.mouse_entered
				end
			end

			@lastLeaf = leaf

		end
	end
	
	def _mouse_move(globalCoord)
		@root.each_recursive_overlapping_component(globalCoord) {|c| c._mouse_move(globalCoord)}
		leaf = @root.leaf_for_coord(globalCoord)
		
		if leaf != @lastLeaf
			@lastLeaf.mouse_left if @lastLeaf
			leaf.mouse_entered
			@lastLeaf = leaf
		end
	end
	
	def button_down(globalCoord, id)
		
	end
	
	def button_up(globalCoord, id)
		@root.each_recursive_overlapping_component(globalCoord) {|c| c.button_up(id)}
	end
	
end
