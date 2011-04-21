require_relative 'adj_graph'
require_relative 'plotter'
include Flib2

p = 0.005 # Probability of linking to a random node
q = 0.495 # Probability of linking to a node 2 steps away
a = 1.05 ** (1.0/30) # Daily growth rate
d = 6000 # Number of days to simulate

# Population growth - logistic function
def p(t)
  p0 = 5.0
  k = 7.0 * (10 ** 3)
  r = 0.05
  (k * p0 * Math.exp(r*t)) / (k + p0 * (Math.exp(r*t) - 1.0))
end

# Difference between number of nodes on day d+1 and day d
def diff(d,a)
  #p(d+1).to_i - p(d).to_i
  (a ** (d+1)).to_i - (a ** d).to_i
end

g = AdjGraph.new

n1 = g.add_node
n2 = g.add_node
n3 = g.add_node
n4 = g.add_node
n5 = g.add_node
g.link_nodes(n1,n2)
g.link_nodes(n1,n3)
g.link_nodes(n1,n4)
g.link_nodes(n1,n5)
g.link_nodes(n2,n3)
g.link_nodes(n2,n4)
g.link_nodes(n2,n5)
g.link_nodes(n3,n4)
g.link_nodes(n3,n5)
g.link_nodes(n4,n5)

nx, ny = [], []
nx << 0
ny << 5

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
    else # Link each new node to a random node
      #g.link_nodes(v,g.random_node) if rand < 0.85
      g.link_nodes(v,g.random_node_weighted_by(:degree))
    end
  end
  
  nx << i+1
  ny << g.node_count
  
end

dist = g.degree_distribution
dist.map! {|a| a.map{|v| Math.log(v)} }
yp, xp = dist.transpose

Dir.mkdir "../data" unless (File.directory? "../data")

Plotter.plot("Log-log count, degree","log deg","log count",yp,xp,"../data/dist.png",plot_type="points")
Plotter.plot("Nodes over time","Count","Time",nx,ny,"../data/nodes.png",plot_type="lines")


File.open("../data/out.txt", "w") do |f|
  f.puts "Node Count: %d / Edge Count: %d / Density: %f" % [g.node_count, g.edge_count, g.edge_count/g.node_count.to_f]
  f.puts "Connected Components: %s" % g.connected_components
end
