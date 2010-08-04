class Window
  def initialize(&b)
    self.instance_eval &b
  end
  
  def title(name)
    puts "Setting title to " + name
  end

  def position(new_pos)
    puts "Setting pos to " + new_pos.inspect
  end

  def size(new_size)
    puts "Setting size to " + new_size.inspect
  end
  
  def metaclass
    class << self
      self
    end
  end
  
  def method_missing(m, *args, &block)
    puts "Regging component: " + m.to_s
    metaclass.send :attr_accessor, m
    self.send "#{m}=".to_sym, args[0]
  end
end

class Button
  def initialize(&b)
    self.instance_eval &b
  end
  
  def title(new_name)
    puts "Caption sets to: " + new_name
    @name = new_name
  end
  
  def get_title
    @name
  end
end

def window(&block)
  Window.new &block
end






main_window = Window.new {
  title "My Window, eh!"
  
  position :x => 10, :y => 10
  size :w => 600, :h => 400
  
  my_button Button.new {
    title "Knapp"
  }
}

puts main_window.my_button.get_title