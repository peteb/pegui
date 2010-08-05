#!/usr/bin/env ruby -wKU

# testing basic component size/position
# (c) Copyright 2010 Peter Backman. All Rights Reserved. 

class Component
  attr_accessor :last_setting
  
  def initialize(&b)
    self.last_setting = {}
    # self.last_setting[:size] = {:w => 1111, :h => 666}
    # TODO: Should the last settings always be used? Maybe!
    
    self.instance_eval(&b)
  end
  
  def size(*args)
    if args.empty?
      @size
    else
      puts "Setting size to " + args[0].inspect
      @size = args[0]  
    end
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


# TODO: a generic way to get the size of a component, no matter if it's 
#       an absolute value or a lambda
# TODO: store sizes and positions like this? Makes for ugly syntax when
#       accessing the components. .size[:w], etc.  .size.width would look nicer

my_component = Component.new {
  size :w => 400, :h => 300
  size last_setting[:size] || {:w => 600, :h => 400}

  sub_component Component.new {
    size :w => lambda{my_component.size[:w] / 2}, :h => 10
  }
}

puts my_component.size[:w].to_s
puts my_component.sub_component.size[:w].call

