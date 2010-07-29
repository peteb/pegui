require 'rubygems'
require 'gosu'

require 'gl'
require 'pruby'
require 'gui/component'
require 'matrix'

include Gl

module Frames
	def draw_line_frame(window, color, bounds)
		mincorner = bounds.corner
		maxcorner = Vector[mincorner[0] + bounds.width, mincorner[1] + bounds.height]
		
		vertices = [mincorner, 
			Vector[maxcorner[0], mincorner[1]],
			maxcorner, 
			Vector[mincorner[0], maxcorner[1]] 
		]
		
		(1..4).each do |x|
			startv = vertices[x - 1]
			endv = vertices[(x + 1) % 4 - 1]
			
			window.draw_line(startv[0], startv[1], color , endv[0], endv[1], color)
		end
		
	end
	
	def draw_quad_frame(window, color, bounds)
		mincorner = bounds.corner
		maxcorner = Vector[mincorner[0] + bounds.width, mincorner[1] + bounds.height]

		window.draw_quad(mincorner[0], mincorner[1], color,
							  maxcorner[0], mincorner[1], color,
							  maxcorner[0], maxcorner[1], color,
							  mincorner[0], maxcorner[1], color)
	end
	
	def draw_tiled_frame(tiles, window, bounds, dir = :horizontal)
		if tiles.size == 3
			if dir == :horizontal
				tiles[0].draw(bounds.corner[0], bounds.corner[1], 0)
				tiles[2].draw(bounds.corner[0] + bounds.width - tiles[2].width, bounds.corner[1], 0)
				tiles[1].draw(bounds.corner[0] + tiles[0].width, bounds.corner[1], 0, 
					(bounds.width - (tiles[0].width + tiles[2].width)).to_f / tiles[1].width.to_f)
			elsif dir == :vertical
				tiles[0].draw(bounds.corner[0], bounds.corner[1], 0)
				tiles[2].draw(bounds.corner[0], bounds.corner[1] + bounds.height - tiles[2].height, 0)
				tiles[1].draw(bounds.corner[0], bounds.corner[1] + tiles[0].height, 0, 1, (bounds.height - (tiles[0].height + tiles[2].height)).to_f / tiles[1].height.to_f)
			end
		elsif tiles.size == 9
			#draw corners first
			tiles[0].draw(bounds.corner[0], bounds.corner[1], 0)
			tiles[2].draw(bounds.corner[0] + bounds.width - tiles[2].width, bounds.corner[1], 0)
			tiles[6].draw(bounds.corner[0], bounds.corner[1] + bounds.height - tiles[6].height, 0)
			tiles[8].draw(bounds.corner[0] + bounds.width - tiles[8].width, bounds.corner[1] + bounds.height - tiles[6].height, 0)

			scaleX = (bounds.width - tiles[0].width - tiles[2].width) / tiles[4].width.to_f
			scaleY = (bounds.height - tiles[0].height - tiles[2].height) / tiles[4].height.to_f

			#filling
			tiles[4].draw(bounds.corner[0] + tiles[0].width, bounds.corner[1] + tiles[0].height, 0, scaleX, scaleY)
			tiles[1].draw(bounds.corner[0] + tiles[0].width, bounds.corner[1], 0, scaleX)
			tiles[7].draw(bounds.corner[0] + tiles[6].width, bounds.corner[1] + bounds.height - tiles[7].height, 0, scaleX)
			tiles[3].draw(bounds.corner[0], bounds.corner[1] + tiles[0].height, 0, 1.0, scaleY)
			tiles[5].draw(bounds.corner[0] + bounds.width - tiles[5].width, bounds.corner[1] + tiles[2].height, 0, 1.0, scaleY)
		end
	end
end
