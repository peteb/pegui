# 1 ----------------------------------------------------------------------------
# TODO:
#   * How are positions and sizes defined? 'position :x => 23, :y => 23', for
#     each component? Any auto-sizing or default-sizing or whatnot?

#   * Implementation split between graphical representation and behavior;
#     the code below only describes behavior, what about graphics?
#     Maybe each theme has a factory that creates graphical representations?
#     ie, create_button. gfx rep. is a component that stores state; a scrollbar
#     has a max, min, value. the gfx fixes the rest
#     create_button => {button = object(); button.gfx = theme.create_button}

main_window = Window.new {              # can be wrapped by function 'window'
  title "My Window, eh!"

	position  :x => 10,   :y => 10
	size      :w => 500,  :h => 400
	
  button1 = Button.new {
    title "A button"
    position :x => 10, :y => 50         # relative to origin of parent
    
    on_click {document_window "boo"}
  }
  
  print = print_button
}


main_window = window {
  title "My Window, eh!"
  
  ...
}



main_window.button1.on_terminate {      # calling with block defines the event
  puts "Bye!"
}

main_window.button1.on_terminate        # without block executes the event


def document_window(name)
  Window.new {
    title "Document: " + name
		
    text = TextArea.new {
      ...
    }
  }
end

def print_button
  Button.new {
    title "Print!"
    on_click {
      document = get_doc;
      document.format
      printer = get_printer;
      printer.print document
    }
  }
end


# 1 but windows are invisible at creation --------------------------------------
# TODO:
#   * will a window exist in any lists before 'show' is called? probably not?
#     windows are not often used as children, they are free-standing and owned
#     at the same level as other windows.
#     'show', therefore, adds the window to that list if it doesn't exist yet
#     Calling 'show' more than once on the same window could result in a warning
#     'window already visible'.
 
main_window = Window.new {
  title "My Window, eh!"
	
  button1 = Button.new {
    title "A button"
    on_click {show document_window "boo"}
  }
  
  print = print_button
}

main_window.button1.on_terminate {
  puts "Bye!"
}



def document_window(name)
  Window.new {
    title "Document: " + name
		
    text = TextArea.new {
      ...
    }
  }
end

def print_button
  Button.new {
    title "Print!"
    on_click {
      document = get_doc;
      document.format
      printer = get_printer;
      printer.print document
    }
  }
end


show main_window


