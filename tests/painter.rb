#!/usr/bin/env ruby -wKU

# drawing application
# (c) Copyright 2010 Peter Backman. All Rights Reserved. 

main_window = window {
  title "A drawing application"
  
  position  default.position
  size      :w => 600, :h => 400 or last_setting.size
  
  
  drawing_area Canvas.new {
    size  :w => lambda {main_window.size.w}, 
          :h => lambda {main_window.size.h - 100}
  }
  
  
  text_area TextArea.new {
    position  :x => 0, :y => lambda {drawing_area.size.h}
    size      :w => lambda {main_window.size.w - 50}, :h => 100
  }
  
  
  exec_button Button.new {
    title "Execute!"
    
    position  :x => lambda {text_area.size.w},
              :y => lambda {text_area.position.y + 25}
    size      :w => 50, :h => 50
    
    on_click {
      puts "This is the code to execute: " + text_area.value
    }
  }

}

