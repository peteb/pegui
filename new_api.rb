
# 1 ----------------------------------------------------------------------------
main_window = Window.new {
	title "My Window, eh!"
	
	button1 = Button.new {
		title "A button"
		on_click {create_document_window "boo"}
	}
}



def create_document_window(name)
	Window.new {
		title "Document: " + name
		
		text = TextArea.new {
			...
		}
	}
end
