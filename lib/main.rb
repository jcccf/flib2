require_relative 'adj_graph'
require_relative 'plotter'
include Flib2

p = 0.0005 # Probability of linking to a random node
q = 0.0495 # Probability of linking to a node 2 steps away
a = 1.05 ** (1.0/30) # Daily growth rate
d = 6000 # Number of days to simulate

# Difference between number of nodes on day d+1 and day d
def diff(d,a)
  (a ** (d+1)).to_i - (a ** d).to_i
end

g = AdjGraph.new

d.times do |i|
  increase = diff(i,a)
  new_nodes = g.add_nodes(increase)
  puts "Added %d nodes" % increase
  
  g.each_node do |k,v|
    if !(new_nodes.include? v) # Do something iff not one of the new nodes
      x = rand
      if x < p # Link to random node
        g.link_nodes(v,g.random_node)
      elsif x < (q+p) # Do random-random
        v1 = v.random_adjacent
        g.link_nodes(v,v1.random_adjacent) if v1 != nil 
      end
    #else # Link each new node to a random node
    #  g.link_nodes(v,g.random_node)
    end
  end
  
end

dist = g.degree_distribution
dist.map! {|a| a.map{|v| Math.log(v)} }
yp, xp = dist.transpose

Plotter.plot("Log-log count, degree","log deg","log count",xp,yp,"../data/dist.png",plot_type="points")

File.open("../data/out.txt", "w") do |f|
  f.puts "Node Count: %d / Edge Count: %d / Density: %f" % [g.node_count, g.edge_count, g.edge_count/g.node_count.to_f]
  f.puts "Connected Components: %s" % g.connected_components
end
