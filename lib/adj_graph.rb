require_relative 'node'
require_relative 'disjoint_set'
require_relative 'tarjan'
include Flib2

module Flib2
  
  class AdjGraph
    
    attr_accessor :edge_count
    
    def initialize
      @nodelist = {}
      @nodelist_a = []
      @edge_count = 0
      @tarjan = Tarjan.new
      @disjoint = DisjointSet.new
    end
    
    # Add a node to the graph and returns it
    def add_node
      a = add_nodes(1)
      a[0]
    end
    
    # Add t nodes to the graph and returns an array of the created nodes
    def add_nodes(t)
      new_nodes = []
      t.times do
        n = Node.new
        #ds_init(n)
        @disjoint.add(n.id)
        @nodelist[n.id] = n
        @nodelist_a << n
        new_nodes << n
        
      end
      new_nodes
    end
    
    # Add an edge between n1 and n2
    def link_nodes(n1,n2)
      if n1.link_to n2
        @edge_count += 1
      end
      #ds_union n1.id, n2.id
      @disjoint.union(n1.id,n2.id)
    end
    
    # Get a random node from the graph
    def random_node
      @nodelist_a[rand(@nodelist_a.size)]
    end
    
    # Return an iterator over each node in the graph
    def each_node
      if block_given?
        @nodelist.each { |k,v| yield k,v }
      else
        raise ArgumentException, "No Block Given"
      end
    end
    
    # Return the degree distribution of the graph in an array
    def degree_distribution
      degrees = Hash.new(0)
      @nodelist_a.each do |v|
        degrees[v.degree] += 1
      end
      degrees.sort
    end
    
    # Return the sizes of the weakly connected components
    def connected_components
      @disjoint.largestsize
    end
    # def connected_components
    #   ds_optimize
    #   sizes = Hash.new(0)
    #   @nodelist.each { |_,v| sizes[v.data["i"]] += 1 }
    #   result = sizes.sort{ |a,b| a[1] <=> b[1] }.reverse
    #   s = ""
    #   result.each { |_,v| s += v.to_s + " " }
    #   s
    # end
    
    def node_count
      @nodelist.count
    end
    
    def to_s
      s = ""
      @nodelist.each { |k,v| s += v.to_s + "\n" }
      s
    end
    
    private
    
    #
    # Connected Component Private Methods
    #
    
    # def ds_init(n)
    #   n.data["r"] = 0
    #   n.data["i"] = n.id
    # end
    # 
    # def ds_parent(id)
    #   i = @nodelist[id].data["i"]
    #   if id != i
    #     @nodelist[id].data["i"] = ds_parent(i)
    #   else
    #     id
    #   end
    # end
    # 
    # def ds_union(id1,id2)
    #   id1 = ds_parent(id1)
    #   id2 = ds_parent(id2)
    #   r1 = @nodelist[id1].data["r"]
    #   r2 = @nodelist[id2].data["r"]
    #   if r1 < r2
    #     @nodelist[id1].data["i"] = id2
    #   else
    #     @nodelist[id2].data["i"] = id1
    #     if r1 == r2
    #       @nodelist[id1].data["r"] += 1
    #     end
    #   end
    # end
    # 
    # def ds_optimize
    #   @nodelist.each { |k,_| ds_parent(k) }
    # end
    
  end
  
end