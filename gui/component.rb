
require 'gl'
require 'pruby'
require 'gui/rectangle'
require 'gui/frames'
include Gl

class Component 
	attr_accessor :bounds
	attr_reader :children
	attr_accessor :clip_draw
	attr_accessor :focusable
	attr_accessor :delegate
	attr_reader :parent
	
	include Frames
	
	def initialize(bounds)
		@bounds = bounds
		@children = []
		@clip_draw = true
		@focusable = true
	end
	
	def draw(window, parentBounds)
		globalBounds = global_bounds #Rectangle.new(parentBounds.corner + bounds.corner, bounds.width, bounds.height)
		
		if @clip_draw
			cliparea = self.clip_area
			#draw_line_frame(window, 0xFFFF0000, cliparea)		# bra för debug...
			window.clip_to(cliparea.corner[0].to_i, cliparea.corner[1].to_i - 1, cliparea.width.to_i + 1, cliparea.height.to_i + 1) do
				paint(window, globalBounds)
				
				
				children.compact.each do |x| 
					intersection = cliparea.intersection(x.global_bounds)
					
					if intersection.width > 0 and intersection.height > 0
						x.draw(window, globalBounds)
					end
				end
			end
		else
			paint(window, globalBounds)
			children.each {|x| x.draw(window, globalBounds)}
		end
	end
	
	def clip_area
		if @parent
			parentArea = @parent.clip_area
			intersection = parentArea.intersection global_bounds
			
			intersection.width = 0 if intersection.width < 0
			intersection.height = 0 if intersection.height < 0
			
			return intersection
		else
			@bounds
		end
	end
	
	def global_bounds
		if @parent
			parentBounds = @parent.global_bounds
			return Rectangle.new(parentBounds.corner + bounds.corner, @bounds.width, @bounds.height)
		else
			return @bounds
		end
	end
	
	def paint(window, globalBounds)	# override this one
		# draw_line_frame(window, 0xFFFF0000, globalBounds)
	end

	def resize(width, height)
		@bounds.width = width
		@bounds.height = height
	end
	
	def add_component(component)
		children << component
		component._on_add(self)
	end
	
	def _on_add(parent)
		@parent = parent
	end
	
	def focus!
		if @parent
			@parent.putTop(self) if @focusable
			@parent.focus!
		end		
	end
	
	def putTop(component)
		if @children.include? component
			@children.delete(component)
			@children.insert(1, component)
		end
	end
	
	def each_overlapping_component(coord)
		children.reverse_each do |child|
			if child and child.bounds.coord_inside? coord
				yield child
			end		
		end
	end
	
	def each_recursive_overlapping_component(coord, &block)
		children.reverse_each do |child|
			if child and child.bounds.coord_inside? coord
				localCoord = coord - child.bounds.corner
				child.each_recursive_overlapping_component(localCoord, &block)
				
				yield child
			end
		end
	end
	
	def leaf_for_coord(coord)
		each_overlapping_component(coord) do |child|
			leaf = child.leaf_for_coord(coord - child.bounds.corner)
			return leaf if leaf
		end
		
		self
	end
		
	def _mouse_down(globalCoord, button)
		localCoord = globalCoord - global_bounds.corner
		mouse_down(localCoord, button)
	end
	
	def _mouse_up(globalCoord, button)
		localCoord = globalCoord - global_bounds.corner
		parentCoord = globalCoord - parent_bounds.corner
		
		_clicked(localCoord, button) if bounds.coord_inside? parentCoord
		
		mouse_up(localCoord, button)
	end
	
	def _mouse_move(globalCoord)
		mouse_move(globalCoord - global_bounds.corner)
	end

	def _clicked(localCoord, button)
		clicked(localCoord, button)
	end
	
	def parent_bounds
		if @parent
			return @parent.global_bounds
		else
			return Rectangle.new(Vector[0, 0], bounds.width, bounds.height)
		end
	end
	
	def mouse_down(coord, button)	# override this one
		@delegate.mouse_down(coord, button) if @delegate
	end
	
	def mouse_up(coord, button)
		@delegate.mouse_up(coord, button) if @delegate
		
	end

	def clicked(coord, button)
		@delegate.clicked(coord, button) if @delegate
	end
	
	def mouse_entered
		
	end
	
	def mouse_left
		
	end
	
	def mouse_move(coord)
		@delegate.mouse_move(coord) if @delegate
	end
	
	def button_up(id)
		
	end
end
