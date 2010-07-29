require 'rubygems'
require 'gosu'
require 'pruby'

require 'gl'
require 'matrix'
require 'pruby'
require 'gui/button'
require 'gui/component'
require 'gui/event_mapper'
require 'gui/image'
require 'gui/window'
require 'gui/scrollbar'
require 'gui/checkbox'
require 'gui/grid'
require 'gui/scrollview'

include Gl

class GameWindow < Gosu::Window	
	def initialize
		super(900, 700, false)
		self.caption = "PeGame"
		
		# @tiles = Gosu::Image.load_tiles(self, "tileset.png", 16, 16, true)
		# @image = @tiles[0]
		# 
		# 
		# info=@image.gl_tex_info; 
		# 
		# glEnable(GL_TEXTURE_2D); 
		# glBindTexture(GL_TEXTURE_2D, info.tex_name);
		# glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
		# glDisable(GL_TEXTURE_2D);
		# 
		# @rot = 0;
		# @pos = Vector[0, 0];
		
		@background = Image.new(Rectangle.new(Vector[-100, -100], 0, 0), "hud_theme/background2.png", self)
		@windowArea = Component.new(Rectangle.new(Vector[0, 0], 900, 700))

		@background.clip_draw = false
		
		@testWindow = Window.new(self, Rectangle.new(Vector[10, 10], 300, 300), "Window")
		@windowArea.add_component(@testWindow)
		
		@testWindow2 = Window.new(self, Rectangle.new(Vector[400, 10], 308, 317), "Window")
		@windowArea.add_component @testWindow2
		
		
		
		@scrollarea = Component.new(Rectangle.new(Vector[0, 0], 256, 150))
		@scrollarea.focusable = false
		@scrollarea.delegate = @testWindow2.content
		@scrollcontent = Image.new(Rectangle.new(Vector[0, 0], 256, 395), "testimg.png", self)
		@scrollarea.add_component @scrollcontent
		
		@testWindow2.add_component @scrollarea
		@testWindow2.add_component Scrollbar.new(self, Rectangle.new(Vector[258, 0], 10, 150), @scrollcontent)
		
		@gridarea = Component.new(Rectangle.new(Vector[5, 75], 200, 100))
		
		@gridview = Grid.new(Rectangle.new(Vector[0, 0], 200, 100))
		#@gridview.delegate = @gridarea
		
		(1..15).each do |x|
			@gridview.add_component Checkbox.new(self, Rectangle.new(Vector[0, 0], 100, 20), "Check #" + x.to_s)
		end
		
		@gridview.add_component Button.new(self, Rectangle.new(Vector[0, 0], 60, 30), "eh")

		(1..15).each do |x|
			@gridview.add_component Checkbox.new(self, Rectangle.new(Vector[0, 0], 100, 20), "Check #" + x.to_s)
		end

		
		@scrollview1 = Scrollview.new(self, Rectangle.new(Vector[0, 160], 268, 100))
		@testWindow2.add_component @scrollview1

		@gridarea.add_component @gridview

		@gridscroll = Scrollbar.new(self, Rectangle.new(Vector[205, 75], 20, 100), @gridview)
		
		@testWindow.content.add_component @gridscroll
		@testWindow.content.add_component @gridarea
		@testWindow.content.add_component Checkbox.new(self, Rectangle.new(Vector[0, 50], 140, 20), "Checkbox")
		
		@myButton = Button.new(self, Rectangle.new(Vector[0, 0], 100, 20), "Magic Button")
		
		@testWindow.content.add_component(Button.new(self, Rectangle.new(Vector[0, 25], 100, 20), "Another"))		
		@testWindow.content.add_component(@myButton)		
		
		@corner = CornerHandle.new(Rectangle.new(Vector[85, 0], 15, 20), @myButton, Vector[50, 20], Vector[-1, 20])
		@corner.focusable = false
		@corner.delegate = @myButton
		
		@myButton.add_component @corner
		
		
		@eventMapper = EventMapper.new @windowArea	# @windowArea will receive events 
	
		
		@cursor = Image.new(Rectangle.new(Vector[0, 0], 1, 1), "cursor.png", self)
		@cursor.clip_draw = false
		
		@windowArea.add_component(@cursor)
		

	end

	def update
		# if button_down? Gosu::Button::KbUp then
		# 	@pos += Vector[Gosu::offset_x(@rot, 5.5), Gosu::offset_y(@rot, 5.5)]
		# end
		@eventMapper.mouse_move(Vector[mouse_x, mouse_y])
		@cursor.bounds.corner = Vector[mouse_x, mouse_y] - Vector[4, 4]
	end
	
	@@mouseMappings = {Gosu::MsLeft => :mouse_left, Gosu::MsRight => :mouse_right}
	
	def button_down(id)
		mouse = Vector[mouse_x, mouse_y]
		if @@mouseMappings.has_key? id
			@eventMapper.mouse_down(mouse, @@mouseMappings[id])	
		else
			@eventMapper.button_down(mouse, id)
		end
		
	end
	
	def button_up(id)
		mouse = Vector[mouse_x, mouse_y]
		if @@mouseMappings.has_key? id
			@eventMapper.mouse_up(mouse, @@mouseMappings[id])	
		else
			@eventMapper.button_up(mouse, id)
		end
	end

	def draw
		# glClearColor(0.93, 0.93, 0.93, 1.0)
		# glClear(GL_COLOR_BUFFER_BIT)
		size = Rectangle.new(Vector[0, 0], 640, 480)
		@background.draw(self, size)
		@windowArea.draw(self, size)

		
		# @rot = @rot + 1;
		# 	
		# 	@image = @tiles.at_random
		# 	@image.draw_rot(@pos[0], @pos[1], 0, @rot, 0.5, 0.5, 5.0, 5.0)
	end
end

window = GameWindow.new
window.show