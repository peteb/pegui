
# 1 ----------------------------------------------------------------------------
main_window = Window.new {
  title "My Window, eh!"
	
  button1 = Button.new {
    title "A button"
    on_click {document_window "boo"}
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


# 1 but windows are invisible at creation --------------------------------------
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


