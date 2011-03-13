require 'Set'

module Flib2
  
  class Node
    attr_accessor :adjacent, :data
    attr_reader :degree, :id
  
    @@id_counter = 0
  
    def initialize
      @id = @@id_counter += 1
      @adjacent = Set.new
      @degree = 0
      @data = {}
    end
  
    # Link this node to "other"
    def link_to(other)
      if other != self
        add(other)
        other.add(self)
        true
      else
        false
      end
    end
  
    # Return a random adjacent node
    def random_adjacent
      #@adjacent.to_a.sort_by{ rand }[0]
      adjacent.to_a[rand(adjacent.size)]
    end
  
    def to_s
      s = sprintf("[%s=>", @id)
      @adjacent.each { |n| s += sprintf(" %s", n.id) }
      s += "]"
      return s
    end
  
    protected
  
    def add(other)
      @degree += 1 unless @adjacent.include? other
      @adjacent.add other
    end
  
  end

end